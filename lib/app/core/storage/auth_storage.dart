import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';

final authBoxProvider = Provider<Box>((ref) => throw UnimplementedError('authBoxProvider not overridden'));

final authStorageProvider = Provider<AuthStorage>((ref) {
  return AuthStorage(ref.read(authBoxProvider));
});

class AuthStorage {
  static const _kAccessToken = 'accessToken';
  static const _kRefreshToken = 'refreshToken';
  static const _kUserId = 'userId';
  static const _kEmail = 'email';
  static const _kRole = 'role';
  static const _kFullName = 'fullName';
  static const _kPhone = 'phone';
  static const _kAddress = 'address';
  static const _kProfileImageUrl = 'profileImageUrl';

  final Box _box;
  AuthStorage(this._box);

  String? get accessToken => _box.get(_kAccessToken) as String?;
  String? get refreshToken => _box.get(_kRefreshToken) as String?;
  String? get userId => _box.get(_kUserId) as String?;
  String? get email => _box.get(_kEmail) as String?;
  String? get role => _box.get(_kRole) as String?;
  String? get fullName => _box.get(_kFullName) as String?;
  String? get phone => _box.get(_kPhone) as String?;
  String? get address => _box.get(_kAddress) as String?;
  String? get profileImageUrl => _box.get(_kProfileImageUrl) as String?;

  bool get hasSession => accessToken != null && refreshToken != null;

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required String userId,
    required String email,
    required String role,
    required String fullName,
  }) async {
    await _box.putAll({
      _kAccessToken: accessToken,
      _kRefreshToken: refreshToken,
      _kUserId: userId,
      _kEmail: email,
      _kRole: role,
      _kFullName: fullName,
    });
  }

  Future<void> saveProfile({
    String? phone,
    String? address,
    String? profileImageUrl,
    String? fullName,
  }) async {
    final updates = <String, dynamic>{};
    if (phone != null) updates[_kPhone] = phone;
    if (address != null) updates[_kAddress] = address;
    if (profileImageUrl != null) updates[_kProfileImageUrl] = profileImageUrl;
    if (fullName != null) updates[_kFullName] = fullName;
    if (updates.isNotEmpty) await _box.putAll(updates);
  }

  Future<void> clearSession() async {
    await _box.clear();
  }
}
