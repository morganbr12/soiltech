class AuthSession {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final String email;
  final String role;
  final String fullName;
  final String? phone;
  final String? address;
  final String? profileImageUrl;

  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.email,
    required this.role,
    required this.fullName,
    this.phone,
    this.address,
    this.profileImageUrl,
  });
}
