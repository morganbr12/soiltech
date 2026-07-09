import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/core/theme/app_colors.dart';
import '../../../../shared/models/enums.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _pageController = PageController();
  int _currentStep = 0;

  // Step 1 controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Step 2
  CustomerAccountType _accountType = CustomerAccountType.individual;
  bool _useGps = true;
  final _addressController = TextEditingController();

  // Step 3
  bool _acceptedTerms = false;
  bool _isLoading = false;

  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0 && !(_step1Key.currentState?.validate() ?? false)) return;
    if (_currentStep == 1 && !_useGps && !(_step2Key.currentState?.validate() ?? false)) return;
    if (_currentStep < 2) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _submit() async {
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the terms to continue.')),
      );
      return;
    }
    setState(() => _isLoading = true);

    final success = await ref.read(authProvider.notifier).register(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
      accountType: _accountType.apiValue,
      address: _useGps ? null : _addressController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      context.go('/customer/home');
    } else {
      final error = ref.read(authProvider).error ?? 'Registration failed. Please try again.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 24, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _currentStep > 0 ? _prevStep : () => context.pop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  const Expanded(
                    child: Text(
                      'Create Account',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    '${_currentStep + 1}/3',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // Progress bar
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (_currentStep + 1) / 3,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  color: AppColors.primary,
                  minHeight: 4,
                ),
              ),
            ),

            // Step labels
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StepLabel(label: 'Personal', step: 0, current: _currentStep),
                  _StepLabel(label: 'Account Type', step: 1, current: _currentStep),
                  _StepLabel(label: 'Confirm', step: 2, current: _currentStep),
                ],
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _Step1PersonalInfo(
                    formKey: _step1Key,
                    nameController: _nameController,
                    phoneController: _phoneController,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    confirmController: _confirmPasswordController,
                    isDark: isDark,
                  ),
                  _Step2AccountType(
                    formKey: _step2Key,
                    selectedType: _accountType,
                    onTypeChanged: (t) => setState(() => _accountType = t),
                    useGps: _useGps,
                    onToggleGps: (v) => setState(() => _useGps = v),
                    addressController: _addressController,
                    isDark: isDark,
                  ),
                  _Step3Terms(
                    accepted: _acceptedTerms,
                    onChanged: (v) => setState(() => _acceptedTerms = v),
                    customerName: _nameController.text,
                    accountType: _accountType,
                    isDark: isDark,
                  ),
                ],
              ),
            ),

            // Bottom action
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: _currentStep < 2
                  ? AppButton(
                      label: 'Continue',
                      onPressed: _nextStep,
                      icon: Icons.arrow_forward_rounded,
                    )
                  : AppButton(
                      label: 'Create Account',
                      onPressed: _isLoading ? null : _submit,
                      isLoading: _isLoading,
                      icon: Icons.check_rounded,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Step widgets ─────────────────────────────────────────────────────────────

class _StepLabel extends StatelessWidget {
  final String label;
  final int step;
  final int current;

  const _StepLabel({required this.label, required this.step, required this.current});

  @override
  Widget build(BuildContext context) {
    final isActive = step <= current;
    return Text(
      label,
      style: TextStyle(
        fontSize: 11,
        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
        color: isActive ? AppColors.primary : Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _Step1PersonalInfo extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmController;
  final bool isDark;

  const _Step1PersonalInfo({
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.passwordController,
    required this.confirmController,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'Tell us a bit about yourself',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 20),
            AppTextField(
              label: 'Full Name',
              hint: 'e.g. Abena Osei',
              controller: nameController,
              prefixIcon: Icons.person_outline_rounded,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              validator: (v) => (v == null || v.trim().length < 2) ? 'Enter your full name' : null,
            ).animate(delay: 50.ms).fadeIn().slideY(begin: 0.1, end: 0),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Phone Number',
              hint: '+233 XX XXX XXXX',
              controller: phoneController,
              keyboardType: TextInputType.phone,
              prefixIcon: Icons.phone_outlined,
              textInputAction: TextInputAction.next,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Phone number required' : null,
            ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.1, end: 0),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Email Address',
              hint: 'you@example.com',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
              textInputAction: TextInputAction.next,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Email required';
                if (!v.contains('@')) return 'Enter a valid email';
                return null;
              },
            ).animate(delay: 150.ms).fadeIn().slideY(begin: 0.1, end: 0),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Password',
              hint: 'Min. 8 characters',
              controller: passwordController,
              obscureText: true,
              prefixIcon: Icons.lock_outline_rounded,
              textInputAction: TextInputAction.next,
              validator: (v) {
                if (v == null || v.length < 8) return 'Password must be at least 8 characters';
                return null;
              },
            ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1, end: 0),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Confirm Password',
              hint: 'Re-enter your password',
              controller: confirmController,
              obscureText: true,
              prefixIcon: Icons.lock_outline_rounded,
              textInputAction: TextInputAction.done,
              validator: (v) {
                if (v != passwordController.text) return 'Passwords do not match';
                return null;
              },
            ).animate(delay: 250.ms).fadeIn().slideY(begin: 0.1, end: 0),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _Step2AccountType extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final CustomerAccountType selectedType;
  final ValueChanged<CustomerAccountType> onTypeChanged;
  final bool useGps;
  final ValueChanged<bool> onToggleGps;
  final TextEditingController addressController;
  final bool isDark;

  const _Step2AccountType({
    required this.formKey,
    required this.selectedType,
    required this.onTypeChanged,
    required this.useGps,
    required this.onToggleGps,
    required this.addressController,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Type',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'How will you be using SoilTech?',
              style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            ...CustomerAccountType.values.map((type) {
              final isSelected = selectedType == type;
              return GestureDetector(
                onTap: () => onTypeChanged(type),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.08)
                        : (isDark ? AppColors.cardDark : AppColors.cardLight),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : theme.colorScheme.outlineVariant,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(type.icon, style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          type.label,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected
                                ? AppColors.primary
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
                    ],
                  ),
                ),
              ).animate(delay: (CustomerAccountType.values.indexOf(type) * 50).ms).fadeIn().slideX(begin: 0.05, end: 0);
            }),

            const SizedBox(height: 20),

            Text(
              'Delivery Location',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                _LocationOption(
                  label: 'Use GPS',
                  icon: Icons.gps_fixed_rounded,
                  isSelected: useGps,
                  onTap: () => onToggleGps(true),
                ),
                const SizedBox(width: 12),
                _LocationOption(
                  label: 'Enter Address',
                  icon: Icons.location_on_outlined,
                  isSelected: !useGps,
                  onTap: () => onToggleGps(false),
                ),
              ],
            ),

            if (!useGps) ...[
              const SizedBox(height: 14),
              AppTextField(
                label: 'Delivery Address',
                hint: 'Street, City, Region',
                controller: addressController,
                prefixIcon: Icons.home_outlined,
                maxLines: 2,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter your address' : null,
              ),
            ],

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _LocationOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _LocationOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.08)
                : Theme.of(context).colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.primary : Theme.of(context).colorScheme.outlineVariant,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? AppColors.primary : Theme.of(context).colorScheme.onSurfaceVariant, size: 22),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppColors.primary : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Step3Terms extends StatelessWidget {
  final bool accepted;
  final ValueChanged<bool> onChanged;
  final String customerName;
  final CustomerAccountType accountType;
  final bool isDark;

  const _Step3Terms({
    required this.accepted,
    required this.onChanged,
    required this.customerName,
    required this.accountType,
    required this.isDark,
  });

  static const _benefits = [
    ('Farm-fresh produce delivered to you', Icons.local_shipping_outlined),
    ('Verified farmers with quality guarantees', Icons.verified_outlined),
    ('Real-time order tracking', Icons.gps_fixed_rounded),
    ('Secure payment methods', Icons.shield_outlined),
    ('Direct chat with farmers', Icons.chat_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.heroGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.white70, size: 28),
                const SizedBox(height: 12),
                Text(
                  customerName.isNotEmpty ? 'Welcome, $customerName!' : 'Almost there!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Account type: ${accountType.label}',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0),

          const SizedBox(height: 24),

          Text(
            'What you get',
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          ..._benefits.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.successLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(entry.value.$2, size: 18, color: AppColors.success),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(entry.value.$1, style: const TextStyle(fontSize: 13)),
                  ),
                ],
              ).animate(delay: (entry.key * 60).ms).fadeIn().slideX(begin: 0.05, end: 0),
            ),
          ),

          const SizedBox(height: 24),

          GestureDetector(
            onTap: () => onChanged(!accepted),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: accepted,
                  onChanged: (v) => onChanged(v ?? false),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  activeColor: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                        children: const [
                          TextSpan(text: 'I agree to SoilTech\'s '),
                          TextSpan(
                            text: 'Terms of Service',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
