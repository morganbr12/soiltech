import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/core/network/dio_provider.dart';
import '../../../app/core/storage/auth_storage.dart';
import '../../../app/core/utils/app_logger.dart';
import '../../../shared/models/auth_session.dart';
import 'auth_api.dart';

final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi(ref.watch(dioProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.watch(authApiProvider),
    ref.read(authStorageProvider),
    ref.watch(dioProvider),
  );
});

class AuthRepository {
  final AuthApi _api;
  final AuthStorage _storage;
  final Dio _dio;

  AuthRepository(this._api, this._storage, this._dio);

  Future<AuthSession> login(String phone, String password) async {
    final response = await _api.login({'phone': phone, 'password': password});
    if (response.data == null) throw Exception(response.message ?? 'Login failed');
    final session = await _saveSession(response.data!.toJson());
    return _enrichWithProfile(session);
  }

  Future<AuthSession> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String accountType,
    String? address,
  }) async {
    final response = await _api.register({
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'password': password,
      'role': 'customer',
      'accountType': accountType,
      if (address != null && address.isNotEmpty) 'address': address,
    });
    if (response.data == null) throw Exception(response.message ?? 'Registration failed');
    final session = await _saveSession(response.data!.toJson());
    return _enrichWithProfile(session);
  }

  Future<void> logout() async {
    final token = _storage.refreshToken;
    if (token != null) {
      try {
        await _api.logout({'refreshToken': token});
      } catch (_) {}
    }
    await _storage.clearSession();
  }

  AuthSession? getStoredSession() {
    if (!_storage.hasSession) return null;
    return AuthSession(
      accessToken: _storage.accessToken!,
      refreshToken: _storage.refreshToken!,
      userId: _storage.userId ?? '',
      email: _storage.email ?? '',
      role: _storage.role ?? 'customer',
      fullName: _storage.fullName ?? '',
      phone: _storage.phone,
      address: _storage.address,
      profileImageUrl: _storage.profileImageUrl,
    );
  }

  Future<AuthSession> _saveSession(Map<String, dynamic> data) async {
    // Response shape: { accessToken, refreshToken, tokenType, expiresIn, role: {name, value, permissions} }
    // userId, email, fullName are NOT in the login response — decode from the JWT payload instead.

    final accessToken = (data['accessToken'] as String?) ?? '';
    final refreshToken = (data['refreshToken'] as String?) ?? '';

    if (accessToken.isEmpty || refreshToken.isEmpty) {
      throw Exception('Login failed: server did not return auth tokens');
    }

    // role is an object — pull the lowercase value string (e.g. "customer", "agent")
    final roleObj = data['role'] as Map<String, dynamic>?;
    final role = (roleObj?['value'] as String?) ?? 'customer';

    // Decode JWT payload to get user identity claims
    final claims = _decodeJwt(accessToken);
    appLogger.d('JWT claims: $claims');

    final userId = claims['sub']?.toString() ?? '';
    final email = claims['email']?.toString() ?? '';
    final fullName = (claims['fullName'] ?? claims['name'] ?? claims['full_name'])?.toString() ?? '';

    final session = AuthSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      userId: userId,
      email: email,
      role: role,
      fullName: fullName,
    );

    await _storage.saveSession(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      userId: session.userId,
      email: session.email,
      role: session.role,
      fullName: session.fullName,
    );
    return session;
  }

  /// Base64-decodes the JWT payload without any external package.
  Map<String, dynamic> _decodeJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return {};
      final payload = base64Url.decode(base64Url.normalize(parts[1]));
      return jsonDecode(utf8.decode(payload)) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  /// Fetches /customer/me after login/register and persists the extra
  /// fields (phone, address, profileImageUrl, fullName).
  Future<AuthSession> _enrichWithProfile(AuthSession session) async {
    if (session.role != 'customer') return session;
    try {
      final res = await _dio.get('/customer/me');
      final profileData = res.data['data'] as Map<String, dynamic>;
      final phone = profileData['phone'] as String?;
      final address = profileData['address'] as String?;
      final profileImageUrl = profileData['profileImageUrl'] as String?;
      final fullName = (profileData['fullName'] as String?)?.isNotEmpty == true
          ? profileData['fullName'] as String
          : session.fullName;
      await _storage.saveProfile(
        phone: phone,
        address: address,
        profileImageUrl: profileImageUrl,
        fullName: fullName,
      );
      return AuthSession(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
        userId: session.userId,
        email: session.email,
        role: session.role,
        fullName: fullName,
        phone: phone,
        address: address,
        profileImageUrl: profileImageUrl,
      );
    } catch (_) {
      // Profile fetch is best-effort — don't fail login if this errors
      return session;
    }
  }
}
