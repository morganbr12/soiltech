import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/core/utils/app_logger.dart';
import '../../../../shared/models/auth_session.dart';
import '../../../../shared/models/enums.dart';
import '../../data/auth_repository.dart';

enum AuthStatus { initial, authenticating, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final String? userId;
  final String? email;
  final String? fullName;
  final String? phone;
  final String? profileImageUrl;
  final UserRole? role;
  final String? error;

  const AuthState({
    this.status = AuthStatus.initial,
    this.userId,
    this.email,
    this.fullName,
    this.phone,
    this.profileImageUrl,
    this.role,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? userId,
    String? email,
    String? fullName,
    String? phone,
    String? profileImageUrl,
    UserRole? role,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
      error: error ?? this.error,
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;

  AuthNotifier(this._repo) : super(const AuthState());

  /// Called from SplashScreen to restore a persisted session.
  Future<void> restoreSession() async {
    final session = _repo.getStoredSession();
    if (session == null) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return;
    }
    state = _sessionToState(session);
  }

  Future<bool> login(String phone, String password) async {
    state = state.copyWith(status: AuthStatus.authenticating, error: null);
    try {
      final session = await _repo.login(phone, password);
      state = _sessionToState(session);
      return true;
    } on DioException catch (e) {
      final msg = _extractMessage(e) ?? 'Invalid phone number or password';
      state = state.copyWith(status: AuthStatus.unauthenticated, error: msg);
      return false;
    } catch (e, st) {
      appLogger.e('Login error', error: e, stackTrace: st);
      state = state.copyWith(status: AuthStatus.unauthenticated, error: e.toString());
      return false;
    }
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String accountType,
    String? address,
  }) async {
    state = state.copyWith(status: AuthStatus.authenticating, error: null);
    try {
      final session = await _repo.register(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
        accountType: accountType,
        address: address,
      );
      state = _sessionToState(session);
      return true;
    } on DioException catch (e) {
      final msg = _extractMessage(e) ?? 'Registration failed. Please try again.';
      state = state.copyWith(status: AuthStatus.unauthenticated, error: msg);
      return false;
    } catch (e, st) {
      appLogger.e('Register error', error: e, stackTrace: st);
      state = state.copyWith(status: AuthStatus.unauthenticated, error: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  /// Used by the legacy OtpScreen. Actual password reset goes through ForgotPasswordScreen.
  Future<bool> verifyOtp(String otp) async => false;

  AuthState _sessionToState(AuthSession session) {
    final role = session.role == 'customer' ? UserRole.customer : UserRole.agent;
    return AuthState(
      status: AuthStatus.authenticated,
      userId: session.userId,
      email: session.email,
      fullName: session.fullName,
      phone: session.phone,
      profileImageUrl: session.profileImageUrl,
      role: role,
    );
  }

  String? _extractMessage(DioException e) {
    try {
      final data = e.response?.data;
      if (data is Map) return data['message'] as String?;
    } catch (_) {}
    return null;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.read(authRepositoryProvider)),
);

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).status == AuthStatus.authenticated;
});

final userRoleProvider = Provider<UserRole?>((ref) {
  return ref.watch(authProvider).role;
});
