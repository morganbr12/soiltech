import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/core/theme/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  int _step = 0; // 0: phone, 1: otp, 2: new password, 3: success
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _isLoading = false;
        if (_step < 3) _step++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: const Text('Reset Password'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Step indicators
            Row(
              children: List.generate(4, (i) {
                final isActive = i <= _step;
                final isCurrent = i == _step;
                return Expanded(
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primary : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isActive ? AppColors.primary : theme.dividerColor,
                            width: isCurrent ? 2.5 : 1.5,
                          ),
                        ),
                        child: Center(
                          child: isActive && i < _step
                              ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                              : Text(
                                  '${i + 1}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: isActive
                                        ? Colors.white
                                        : theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                        ),
                      ),
                      if (i < 3)
                        Expanded(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: 2,
                            color: i < _step ? AppColors.primary : theme.dividerColor,
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 36),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.1, 0),
                    end: Offset.zero,
                  ).animate(anim),
                  child: child,
                ),
              ),
              child: _buildStep(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(ThemeData theme) {
    switch (_step) {
      case 0:
        return _buildPhoneStep(theme);
      case 1:
        return _buildOtpStep(theme);
      case 2:
        return _buildNewPasswordStep(theme);
      default:
        return _buildSuccessStep(theme);
    }
  }

  Widget _buildPhoneStep(ThemeData theme) {
    return Column(
      key: const ValueKey(0),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHeader(
          icon: Icons.phone_outlined,
          title: 'Enter Phone Number',
          subtitle: 'We\'ll send a reset code to your registered number.',
        ),
        const SizedBox(height: 28),
        AppTextField(
          label: 'Phone Number',
          hint: '+233 XX XXX XXXX',
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          prefixIcon: Icons.phone_outlined,
        ),
        const SizedBox(height: 28),
        AppButton(
          label: 'Send Reset Code',
          onPressed: _isLoading ? null : _next,
          isLoading: _isLoading,
          icon: Icons.send_rounded,
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.05, end: 0);
  }

  Widget _buildOtpStep(ThemeData theme) {
    return Column(
      key: const ValueKey(1),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHeader(
          icon: Icons.sms_outlined,
          title: 'Enter Reset Code',
          subtitle: 'A 6-digit code has been sent to your phone.',
        ),
        const SizedBox(height: 28),
        AppTextField(
          label: 'Reset Code',
          hint: '------',
          controller: _otpController,
          keyboardType: TextInputType.number,
          prefixIcon: Icons.pin_outlined,
          maxLength: 6,
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: const Text('Resend Code'),
          ),
        ),
        const SizedBox(height: 16),
        AppButton(
          label: 'Verify Code',
          onPressed: _isLoading ? null : _next,
          isLoading: _isLoading,
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.05, end: 0);
  }

  Widget _buildNewPasswordStep(ThemeData theme) {
    return Column(
      key: const ValueKey(2),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHeader(
          icon: Icons.lock_reset_rounded,
          title: 'Create New Password',
          subtitle: 'Choose a strong password with at least 8 characters.',
        ),
        const SizedBox(height: 28),
        AppTextField(
          label: 'New Password',
          hint: 'At least 8 characters',
          controller: _newPasswordController,
          obscureText: true,
          prefixIcon: Icons.lock_outline_rounded,
        ),
        const SizedBox(height: 16),
        AppTextField(
          label: 'Confirm Password',
          hint: 'Repeat your new password',
          controller: _confirmPasswordController,
          obscureText: true,
          prefixIcon: Icons.lock_outline_rounded,
        ),
        const SizedBox(height: 28),
        AppButton(
          label: 'Reset Password',
          onPressed: _isLoading ? null : _next,
          isLoading: _isLoading,
          icon: Icons.check_rounded,
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.05, end: 0);
  }

  Widget _buildSuccessStep(ThemeData theme) {
    return Column(
      key: const ValueKey(3),
      children: [
        const SizedBox(height: 24),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.successLight,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_circle_rounded, size: 52, color: AppColors.success),
        )
            .animate()
            .scale(begin: const Offset(0.5, 0.5), duration: 600.ms, curve: Curves.elasticOut),
        const SizedBox(height: 28),
        Text(
          'Password Reset!',
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Your password has been successfully reset.\nYou can now sign in with your new password.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 36),
        AppButton(
          label: 'Back to Sign In',
          onPressed: () => context.go('/login'),
          icon: Icons.login_rounded,
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }
}

class _StepHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _StepHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, size: 28, color: AppColors.primary),
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
