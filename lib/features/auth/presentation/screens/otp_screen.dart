import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/core/theme/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../providers/auth_provider.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String phone;
  const OtpScreen({super.key, required this.phone});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  bool _canResend = false;
  int _countdown = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _canResend = false;
      _countdown = 60;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdown <= 1) {
        t.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _countdown--);
      }
    });
  }

  String get _otp => _controllers.map((c) => c.text).join();

  Future<void> _verify() async {
    if (_otp.length != 6) return;
    setState(() => _isLoading = true);
    final success = await ref.read(authProvider.notifier).verifyOtp(_otp);
    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        context.go('/home');
      } else {
        for (final c in _controllers) {
          c.clear();
        }
        _focusNodes[0].requestFocus();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid OTP. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: const Text('Verify OTP'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.sms_rounded,
                size: 36,
                color: AppColors.primary,
              ),
            )
                .animate()
                .scale(begin: const Offset(0.8, 0.8), duration: 500.ms, curve: Curves.elasticOut)
                .fadeIn(duration: 300.ms),
            const SizedBox(height: 24),
            Text(
              'Enter Verification Code',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ).animate(delay: 100.ms).fadeIn(duration: 400.ms),
            const SizedBox(height: 10),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(text: 'We sent a 6-digit code to\n'),
                  TextSpan(
                    text: widget.phone.isEmpty ? '+233 XX XXX XXXX' : widget.phone,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ).animate(delay: 150.ms).fadeIn(duration: 400.ms),
            const SizedBox(height: 40),

            // OTP inputs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (i) => _OtpInput(
                controller: _controllers[i],
                focusNode: _focusNodes[i],
                isDark: isDark,
                onChanged: (val) {
                  if (val.length == 1 && i < 5) {
                    _focusNodes[i + 1].requestFocus();
                  } else if (val.isEmpty && i > 0) {
                    _focusNodes[i - 1].requestFocus();
                  }
                  if (_otp.length == 6) _verify();
                },
              )),
            )
                .animate(delay: 200.ms)
                .fadeIn(duration: 400.ms)
                .slideY(begin: 0.1, end: 0),
            const SizedBox(height: 36),

            // Verify button
            AppButton(
              label: 'Verify Code',
              onPressed: _otp.length == 6 && !_isLoading ? _verify : null,
              isLoading: _isLoading,
              icon: Icons.verified_rounded,
            )
                .animate(delay: 300.ms)
                .fadeIn(duration: 400.ms),
            const SizedBox(height: 24),

            // Resend
            if (_canResend)
              TextButton.icon(
                onPressed: _startCountdown,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Resend Code'),
              ).animate().fadeIn(duration: 300.ms)
            else
              Text(
                'Resend code in $_countdown seconds',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ).animate(delay: 400.ms).fadeIn(duration: 300.ms),

            const SizedBox(height: 32),
            // Demo hint
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.infoLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.info),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Demo: Enter any 6-digit code to proceed',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.info.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            )
                .animate(delay: 500.ms)
                .fadeIn(duration: 400.ms),
          ],
        ),
      ),
    );
  }
}

class _OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isDark;
  final void Function(String) onChanged;

  const _OtpInput({
    required this.controller,
    required this.focusNode,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 56,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: isDark ? const Color(0xFF1E2E20) : const Color(0xFFF0F6F1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFD4E4D4),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (val) {
          if (val.length > 1) {
            controller.text = val[val.length - 1];
            controller.selection = TextSelection.fromPosition(
              TextPosition(offset: controller.text.length),
            );
          }
          onChanged(controller.text);
        },
      ),
    );
  }
}
