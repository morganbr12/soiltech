import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthState { unauthenticated, authenticating, authenticated, error }

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState.unauthenticated);

  Future<bool> login(String phone, String password) async {
    state = AuthState.authenticating;
    await Future.delayed(const Duration(seconds: 2));
    if (phone.isNotEmpty && password.length >= 6) {
      state = AuthState.authenticated;
      return true;
    }
    state = AuthState.error;
    return false;
  }

  Future<bool> verifyOtp(String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    if (otp.length == 6) {
      state = AuthState.authenticated;
      return true;
    }
    return false;
  }

  Future<bool> resetPassword(String phone) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  void logout() {
    state = AuthState.unauthenticated;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider) == AuthState.authenticated;
});
