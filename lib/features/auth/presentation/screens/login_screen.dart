import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/core/theme/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController(text: '+233 24 567 8901');
  final _passwordController = TextEditingController(text: 'password123');
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final success = await ref
        .read(authProvider.notifier)
        .login(_phoneController.text, _passwordController.text);
    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        context.go('/home');
      } else {
        setState(() => _errorMessage = 'Invalid credentials. Please try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero header
            Container(
              width: double.infinity,
              height: size.height * 0.35,
              decoration: BoxDecoration(gradient: AppColors.heroGradient),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.agriculture_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'SoilTech',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      )
                          .animate()
                          .fadeIn(duration: 500.ms)
                          .slideX(begin: -0.1, end: 0),
                      const SizedBox(height: 24),
                      const Text(
                        'Welcome back,\nAgent',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.2,
                          letterSpacing: -0.5,
                        ),
                      )
                          .animate(delay: 150.ms)
                          .fadeIn(duration: 500.ms)
                          .slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to continue your field operations',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      )
                          .animate(delay: 250.ms)
                          .fadeIn(duration: 400.ms),
                    ],
                  ),
                ),
              ),
            ),

            // Form card
            Transform.translate(
              offset: const Offset(0, -24),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sign In',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Enter your credentials to access the platform',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Phone field
                      AppTextField(
                        label: 'Phone Number',
                        hint: '+233 XX XXX XXXX',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icons.phone_outlined,
                        textInputAction: TextInputAction.next,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Phone number required';
                          return null;
                        },
                      )
                          .animate(delay: 300.ms)
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 16),

                      // Password field
                      AppTextField(
                        label: 'Password',
                        hint: 'Enter your password',
                        controller: _passwordController,
                        obscureText: true,
                        prefixIcon: Icons.lock_outline_rounded,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _handleLogin(),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Password required';
                          if (v.length < 6) return 'Password too short';
                          return null;
                        },
                      )
                          .animate(delay: 400.ms)
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: 0.1, end: 0),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => context.push('/forgot-password'),
                          child: const Text('Forgot Password?'),
                        ),
                      )
                          .animate(delay: 450.ms)
                          .fadeIn(duration: 300.ms),

                      // Error message
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.errorLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.error.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline, size: 16, color: AppColors.error),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.error,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).animate().shake(duration: 400.ms),
                        const SizedBox(height: 8),
                      ],

                      const SizedBox(height: 8),

                      // Login button
                      AppButton(
                        label: 'Sign In',
                        onPressed: _isLoading ? null : _handleLogin,
                        isLoading: _isLoading,
                        icon: Icons.login_rounded,
                      )
                          .animate(delay: 500.ms)
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: 0.1, end: 0),

                      const SizedBox(height: 20),

                      // OTP option
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: theme.dividerColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'or',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: theme.dividerColor)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      AppButton(
                        label: 'Sign in with OTP',
                        variant: AppButtonVariant.outline,
                        icon: Icons.sms_outlined,
                        onPressed: () => context.push(
                          '/otp?phone=${Uri.encodeComponent(_phoneController.text)}',
                        ),
                      )
                          .animate(delay: 600.ms)
                          .fadeIn(duration: 400.ms),
                    ],
                  ),
                ),
              ),
            )
                .animate(delay: 200.ms)
                .fadeIn(duration: 500.ms)
                .slideY(begin: 0.1, end: 0),

            // Footer
            Padding(
              padding: const EdgeInsets.only(bottom: 32, top: 8),
              child: Column(
                children: [
                  Text(
                    'Protected by end-to-end encryption',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_rounded, size: 12, color: AppColors.primary.withValues(alpha: 0.6)),
                      const SizedBox(width: 4),
                      Text(
                        'SoilTech LBC v1.0.0',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.primary.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
                .animate(delay: 700.ms)
                .fadeIn(duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
