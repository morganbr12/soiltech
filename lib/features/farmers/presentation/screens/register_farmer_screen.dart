import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/core/constants/app_constants.dart';
import '../../../../app/core/theme/app_colors.dart';
import '../../../../app/core/utils/app_logger.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../data/farmers_repository.dart';
import '../providers/farmers_provider.dart';

class RegisterFarmerScreen extends ConsumerStatefulWidget {
  const RegisterFarmerScreen({super.key});

  @override
  ConsumerState<RegisterFarmerScreen> createState() => _RegisterFarmerScreenState();
}

class _RegisterFarmerScreenState extends ConsumerState<RegisterFarmerScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _isLoading = false;
  String? _errorMessage;

  // Step 1 — Personal details
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _nationalIdController = TextEditingController();

  // Step 2 — Location
  final _districtController = TextEditingController();
  final _communityController = TextEditingController();

  // Step 3 — Crops
  final Set<String> _selectedCrops = {};

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _nationalIdController.dispose();
    _districtController.dispose();
    _communityController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() { _isLoading = true; _errorMessage = null; });

    try {
      final body = <String, dynamic>{
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'district': _districtController.text.trim(),
        'community': _communityController.text.trim(),
        if (_emailController.text.trim().isNotEmpty)
          'email': _emailController.text.trim(),
        if (_nationalIdController.text.trim().isNotEmpty)
          'nationalId': _nationalIdController.text.trim(),
        if (_selectedCrops.isNotEmpty)
          'cropTypes': _selectedCrops.map((c) => c.toUpperCase()).toList(),
      };

      await ref.read(farmersRepositoryProvider).createFarmer(body);

      // Refresh the farmers list so the new entry appears immediately
      ref.invalidate(farmersListProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${_firstNameController.text.trim()} ${_lastNameController.text.trim()} registered successfully!',
            ),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e, st) {
      appLogger.e('Register farmer failed', error: e, stackTrace: st);
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = _parseError(e);
        });
      }
      return;
    }

    if (mounted) setState(() => _isLoading = false);
  }

  String _parseError(Object e) {
    final msg = e.toString();
    if (msg.contains('400')) return 'Invalid details. Please check the form and try again.';
    if (msg.contains('409')) return 'A farmer with this phone number already exists.';
    if (msg.contains('SocketException') || msg.contains('connection')) return 'No internet connection.';
    return 'Registration failed. Please try again.';
  }

  void _nextStep() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() { _currentStep++; _errorMessage = null; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const steps = ['Personal Details', 'Location', 'Crop Portfolio'];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.close_rounded),
        ),
        title: const Text('Register Farmer'),
        centerTitle: true,
        actions: [
          if (_currentStep > 0)
            TextButton(
              onPressed: () => setState(() { _currentStep--; _errorMessage = null; }),
              child: const Text('Back'),
            ),
        ],
      ),
      body: Column(
        children: [
          // Progress
          LinearProgressIndicator(
            value: (_currentStep + 1) / 3,
            backgroundColor: AppColors.primaryContainer.withValues(alpha: 0.3),
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            minHeight: 3,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Text(
                  'Step ${_currentStep + 1} of 3',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurfaceVariant),
                ),
                const Spacer(),
                Text(
                  steps[_currentStep],
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
              ],
            ),
          ),

          Expanded(
            child: Form(
              key: _formKey,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: SlideTransition(
                    position: Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero).animate(anim),
                    child: child,
                  ),
                ),
                child: _buildStep(theme),
              ),
            ),
          ),

          // Error banner
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.errorLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, size: 16, color: AppColors.error),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(fontSize: 13, color: AppColors.error, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ).animate().shake(duration: 400.ms),
            ),

          // Bottom button
          Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, MediaQuery.of(context).padding.bottom + 16),
            child: _currentStep < 2
                ? AppButton(label: 'Continue', icon: Icons.arrow_forward_rounded, onPressed: _nextStep)
                : AppButton(
                    label: 'Register Farmer',
                    icon: Icons.person_add_rounded,
                    onPressed: _isLoading ? null : _submit,
                    isLoading: _isLoading,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(ThemeData theme) {
    return switch (_currentStep) {
      0 => _buildPersonalStep(theme),
      1 => _buildLocationStep(theme),
      _ => _buildCropStep(theme),
    };
  }

  // ── Step 1: Personal details ─────────────────────────────────────────────────

  Widget _buildPersonalStep(ThemeData theme) {
    return SingleChildScrollView(
      key: const ValueKey(0),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Personal Details', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700))
              .animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 4),
          Text('Enter the farmer\'s personal information.',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant))
              .animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  label: 'First Name',
                  hint: 'e.g. Kofi',
                  controller: _firstNameController,
                  prefixIcon: Icons.person_outline_rounded,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: (v) => v?.trim().isEmpty == true ? 'Required' : null,
                ).animate(delay: 100.ms).fadeIn(duration: 300.ms),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppTextField(
                  label: 'Last Name',
                  hint: 'e.g. Mensah',
                  controller: _lastNameController,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: (v) => v?.trim().isEmpty == true ? 'Required' : null,
                ).animate(delay: 130.ms).fadeIn(duration: 300.ms),
              ),
            ],
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Phone Number',
            hint: '+233 XX XXX XXXX',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            prefixIcon: Icons.phone_outlined,
            textInputAction: TextInputAction.next,
            validator: (v) => v?.trim().isEmpty == true ? 'Phone number required' : null,
          ).animate(delay: 160.ms).fadeIn(duration: 300.ms),
          const SizedBox(height: 14),
          AppTextField(
            label: 'National ID (Optional)',
            hint: 'GHA-XXXXXXXX-X',
            controller: _nationalIdController,
            prefixIcon: Icons.badge_outlined,
            textCapitalization: TextCapitalization.characters,
            textInputAction: TextInputAction.next,
          ).animate(delay: 190.ms).fadeIn(duration: 300.ms),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Email (Optional)',
            hint: 'farmer@example.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            textInputAction: TextInputAction.done,
          ).animate(delay: 220.ms).fadeIn(duration: 300.ms),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                const Icon(Icons.add_a_photo_outlined, size: 32, color: AppColors.primary),
                const SizedBox(height: 8),
                const Text('Capture Farmer Photo', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary)),
                const SizedBox(height: 4),
                Text('Take a photo for identification',
                    style: TextStyle(fontSize: 12, color: AppColors.primary.withValues(alpha: 0.7))),
              ],
            ),
          ).animate(delay: 250.ms).fadeIn(duration: 300.ms),
        ],
      ),
    );
  }

  // ── Step 2: Location ─────────────────────────────────────────────────────────

  Widget _buildLocationStep(ThemeData theme) {
    return SingleChildScrollView(
      key: const ValueKey(1),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Location Details', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700))
              .animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 4),
          Text('Where is the farmer located?',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant))
              .animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 24),
          AppTextField(
            label: 'District',
            hint: 'e.g. Ejisu-Juaben',
            controller: _districtController,
            prefixIcon: Icons.location_city_outlined,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            validator: (v) => v?.trim().isEmpty == true ? 'District required' : null,
          ).animate(delay: 100.ms).fadeIn(duration: 300.ms),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Community',
            hint: 'e.g. Adum',
            controller: _communityController,
            prefixIcon: Icons.holiday_village_outlined,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            validator: (v) => v?.trim().isEmpty == true ? 'Community required' : null,
          ).animate(delay: 150.ms).fadeIn(duration: 300.ms),
        ],
      ),
    );
  }

  // ── Step 3: Crops ────────────────────────────────────────────────────────────

  Widget _buildCropStep(ThemeData theme) {
    return SingleChildScrollView(
      key: const ValueKey(2),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Crop Portfolio', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700))
              .animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 4),
          Text('Select all crops the farmer cultivates.',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant))
              .animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 4),
          Text('Optional — you can skip this step.',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant, fontStyle: FontStyle.italic))
              .animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: AppConstants.cropTypes.asMap().entries.map((e) {
              final crop = e.value;
              final isSelected = _selectedCrops.contains(crop);
              return GestureDetector(
                onTap: () => setState(() => isSelected ? _selectedCrops.remove(crop) : _selectedCrops.add(crop)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : theme.brightness == Brightness.dark
                              ? const Color(0xFF2A3A2A)
                              : const Color(0xFFD4E4D4),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.grass_rounded, size: 16, color: isSelected ? Colors.white : AppColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        crop,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate(delay: Duration(milliseconds: 50 * e.key)).fadeIn(duration: 300.ms);
            }).toList(),
          ),
          const SizedBox(height: 20),
          if (_selectedCrops.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.success),
                  const SizedBox(width: 8),
                  Text(
                    '${_selectedCrops.length} crop${_selectedCrops.length > 1 ? 's' : ''} selected',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.success),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms),
        ],
      ),
    );
  }
}
