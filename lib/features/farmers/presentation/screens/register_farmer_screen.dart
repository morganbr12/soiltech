import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/core/constants/app_constants.dart';
import '../../../../app/core/theme/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';

class RegisterFarmerScreen extends StatefulWidget {
  const RegisterFarmerScreen({super.key});

  @override
  State<RegisterFarmerScreen> createState() => _RegisterFarmerScreenState();
}

class _RegisterFarmerScreenState extends State<RegisterFarmerScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _isLoading = false;

  // Personal details
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _idController = TextEditingController();
  final _emailController = TextEditingController();

  // Location
  String? _selectedRegion;
  final _districtController = TextEditingController();
  final _communityController = TextEditingController();

  // Crops
  final Set<String> _selectedCrops = {};

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _idController.dispose();
    _emailController.dispose();
    _districtController.dispose();
    _communityController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Farmer registered successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              onPressed: () => setState(() => _currentStep--),
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
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Text(
                  ['Personal Details', 'Location', 'Crop Portfolio'][_currentStep],
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
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
                    position: Tween<Offset>(
                      begin: const Offset(0.05, 0),
                      end: Offset.zero,
                    ).animate(anim),
                    child: child,
                  ),
                ),
                child: _buildStep(theme),
              ),
            ),
          ),

          // Bottom button
          Padding(
            padding: EdgeInsets.fromLTRB(
              20, 12, 20, MediaQuery.of(context).padding.bottom + 16,
            ),
            child: _currentStep < 2
                ? AppButton(
                    label: 'Continue',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        setState(() => _currentStep++);
                      }
                    },
                  )
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
    switch (_currentStep) {
      case 0:
        return _buildPersonalStep(theme);
      case 1:
        return _buildLocationStep(theme);
      default:
        return _buildCropStep(theme);
    }
  }

  Widget _buildPersonalStep(ThemeData theme) {
    return SingleChildScrollView(
      key: const ValueKey(0),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Details',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ).animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 4),
          Text(
            'Enter the farmer\'s personal information.',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ).animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 24),
          AppTextField(
            label: 'Full Name',
            hint: 'e.g. Kofi Mensah',
            controller: _nameController,
            prefixIcon: Icons.person_outline_rounded,
            textCapitalization: TextCapitalization.words,
            validator: (v) => v?.isEmpty == true ? 'Full name required' : null,
          ).animate(delay: 100.ms).fadeIn(duration: 300.ms),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Phone Number',
            hint: '+233 XX XXX XXXX',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            prefixIcon: Icons.phone_outlined,
            validator: (v) => v?.isEmpty == true ? 'Phone number required' : null,
          ).animate(delay: 150.ms).fadeIn(duration: 300.ms),
          const SizedBox(height: 14),
          AppTextField(
            label: 'National ID Number',
            hint: 'GHA-XXXXXXXX-X',
            controller: _idController,
            prefixIcon: Icons.badge_outlined,
            textCapitalization: TextCapitalization.characters,
            validator: (v) => v?.isEmpty == true ? 'National ID required' : null,
          ).animate(delay: 200.ms).fadeIn(duration: 300.ms),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Email (Optional)',
            hint: 'farmer@example.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
          ).animate(delay: 250.ms).fadeIn(duration: 300.ms),
          const SizedBox(height: 24),
          // Photo capture placeholder
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              children: [
                const Icon(Icons.add_a_photo_outlined, size: 32, color: AppColors.primary),
                const SizedBox(height: 8),
                const Text(
                  'Capture Farmer Photo',
                  style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary),
                ),
                const SizedBox(height: 4),
                Text(
                  'Take a photo for identification',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ).animate(delay: 300.ms).fadeIn(duration: 300.ms),
        ],
      ),
    );
  }

  Widget _buildLocationStep(ThemeData theme) {
    return SingleChildScrollView(
      key: const ValueKey(1),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location Details',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ).animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 4),
          Text(
            'Where is the farmer located?',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ).animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 24),

          // Region dropdown
          DropdownButtonFormField<String>(
            value: _selectedRegion,
            decoration: InputDecoration(
              labelText: 'Region',
              prefixIcon: const Icon(Icons.map_outlined, size: 20),
              filled: true,
              fillColor: theme.brightness == Brightness.dark
                  ? const Color(0xFF1E2E20)
                  : const Color(0xFFF0F6F1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: theme.brightness == Brightness.dark
                      ? const Color(0xFF2A3A2A)
                      : const Color(0xFFD4E4D4),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
            items: AppConstants.regions.map((r) {
              return DropdownMenuItem(value: r, child: Text(r, style: const TextStyle(fontSize: 14)));
            }).toList(),
            onChanged: (v) => setState(() => _selectedRegion = v),
            validator: (v) => v == null ? 'Please select a region' : null,
          ).animate(delay: 100.ms).fadeIn(duration: 300.ms),
          const SizedBox(height: 14),
          AppTextField(
            label: 'District',
            hint: 'e.g. Ejisu-Juaben',
            controller: _districtController,
            prefixIcon: Icons.location_city_outlined,
            textCapitalization: TextCapitalization.words,
            validator: (v) => v?.isEmpty == true ? 'District required' : null,
          ).animate(delay: 150.ms).fadeIn(duration: 300.ms),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Community / Village',
            hint: 'e.g. Ejisu',
            controller: _communityController,
            prefixIcon: Icons.home_outlined,
            textCapitalization: TextCapitalization.words,
            validator: (v) => v?.isEmpty == true ? 'Community required' : null,
          ).animate(delay: 200.ms).fadeIn(duration: 300.ms),
        ],
      ),
    );
  }

  Widget _buildCropStep(ThemeData theme) {
    return SingleChildScrollView(
      key: const ValueKey(2),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Crop Portfolio',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ).animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 4),
          Text(
            'Select all crops the farmer cultivates.',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ).animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 24),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: AppConstants.cropTypes.asMap().entries.map((e) {
              final crop = e.value;
              final isSelected = _selectedCrops.contains(crop);
              return GestureDetector(
                onTap: () => setState(() {
                  if (isSelected) {
                    _selectedCrops.remove(crop);
                  } else {
                    _selectedCrops.add(crop);
                  }
                }),
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
                      Icon(
                        Icons.grass_rounded,
                        size: 16,
                        color: isSelected ? Colors.white : AppColors.primary,
                      ),
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
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.success),
                  const SizedBox(width: 8),
                  Text(
                    '${_selectedCrops.length} crop${_selectedCrops.length > 1 ? 's' : ''} selected',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms),
        ],
      ),
    );
  }
}
