import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/app_models.dart';
import '../../../../shared/models/dummy_data.dart';

enum AuthStatus { unauthenticated, authenticating, authenticated, error }

class AuthStateData {
  final AuthStatus status;
  final UserRole? role;
  final String? error;

  const AuthStateData({
    this.status = AuthStatus.unauthenticated,
    this.role,
    this.error,
  });

  AuthStateData copyWith({AuthStatus? status, UserRole? role, String? error}) {
    return AuthStateData(
      status: status ?? this.status,
      role: role ?? this.role,
      error: error ?? this.error,
    );
  }
}

class CustomerRegistrationData {
  final String fullName;
  final String phone;
  final String email;
  final String password;
  final CustomerAccountType accountType;
  final String location;

  const CustomerRegistrationData({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.password,
    required this.accountType,
    required this.location,
  });
}

class AuthNotifier extends StateNotifier<AuthStateData> {
  AuthNotifier() : super(const AuthStateData());

  Future<bool> login(String identifier, String password) async {
    state = state.copyWith(status: AuthStatus.authenticating, error: null);
    await Future.delayed(const Duration(seconds: 2));

    if (identifier.trim().isEmpty || password.length < 6) {
      state = state.copyWith(status: AuthStatus.error, error: 'Invalid credentials.');
      return false;
    }

    final agentPhone = DummyData.agent.phone.replaceAll(' ', '');
    final inputClean = identifier.replaceAll(' ', '');
    final isAgent = inputClean == agentPhone ||
        identifier.trim() == DummyData.agent.phone.trim() ||
        identifier.trim() == DummyData.agent.email;

    state = state.copyWith(
      status: AuthStatus.authenticated,
      role: isAgent ? UserRole.agent : UserRole.customer,
    );
    return true;
  }

  Future<bool> register(CustomerRegistrationData data) async {
    state = state.copyWith(status: AuthStatus.authenticating, error: null);
    await Future.delayed(const Duration(seconds: 2));
    // Simulate registration → auto-login as customer
    state = state.copyWith(status: AuthStatus.authenticated, role: UserRole.customer);
    return true;
  }

  Future<bool> verifyOtp(String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    if (otp.length == 6) {
      state = state.copyWith(status: AuthStatus.authenticated);
      return true;
    }
    return false;
  }

  Future<bool> resetPassword(String phone) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  void logout() {
    state = const AuthStateData();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthStateData>(
  (ref) => AuthNotifier(),
);

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).status == AuthStatus.authenticated;
});

final userRoleProvider = Provider<UserRole?>((ref) {
  return ref.watch(authProvider).role;
});
