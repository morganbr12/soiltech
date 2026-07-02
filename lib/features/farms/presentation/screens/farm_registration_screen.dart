import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/core/constants/app_constants.dart';
import '../../../../app/core/theme/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';

class FarmRegistrationScreen extends StatefulWidget {
  final String farmerId;
  const FarmRegistrationScreen({super.key, required this.farmerId});

  @override
  State<FarmRegistrationScreen> createState() => _FarmRegistrationScreenState();
}

class _FarmRegistrationScreenState extends State<FarmRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isCapturingGps = false;
  String? _gpsCoords;

  final _nameController = TextEditingController();
  final _sizeController = TextEditingController();
  String? _selectedRegion;
  final _districtController = TextEditingController();
  final _communityController = TextEditingController();
  String? _selectedHarvestPeriod;
  final Set<String> _selectedCrops = {};
  int _photoCount = 0;

  final List<String> _harvestPeriods = [
    'January - March',
    'April - June',
    'July - September',
    'October - December',
    'Bi-Annual (Mar & Sep)',
    'Year-Round',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _sizeController.dispose();
    _districtController.dispose();
    _communityController.dispose();
    super.dispose();
  }

  Future<void> _captureGps() async {
    setState(() => _isCapturingGps = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isCapturingGps = false;
        _gpsCoords = '6.7157° N, 1.4753° W';
      });
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Farm registered successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop();
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
          icon: const Icon(Icons.close_rounded),
        ),
        title: const Text('Register Farm'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppColors.cardGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.terrain_rounded, color: Colors.white, size: 28),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Farm Details',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Fill in the farm information below',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 24),

              // Basic info
              Text(
                'Basic Information',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ).animate(delay: 100.ms).fadeIn(duration: 300.ms),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Farm Name',
                hint: 'e.g. Mensah Family Farm',
                controller: _nameController,
                prefixIcon: Icons.terrain_outlined,
                textCapitalization: TextCapitalization.words,
                validator: (v) => v?.isEmpty == true ? 'Farm name required' : null,
              ).animate(delay: 120.ms).fadeIn(duration: 300.ms),
              const SizedBox(height: 14),
              AppTextField(
                label: 'Farm Size (acres)',
                hint: 'e.g. 5.5',
                controller: _sizeController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                prefixIcon: Icons.straighten_rounded,
                validator: (v) {
                  if (v?.isEmpty == true) return 'Farm size required';
                  if (double.tryParse(v!) == null) return 'Enter a valid number';
                  return null;
                },
              ).animate(delay: 140.ms).fadeIn(duration: 300.ms),
              const SizedBox(height: 24),

              // GPS Location
              Text(
                'GPS Location',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ).animate(delay: 160.ms).fadeIn(duration: 300.ms),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _gpsCoords != null
                        ? AppColors.success.withValues(alpha: 0.5)
                        : isDark
                            ? const Color(0xFF2A3A2A)
                            : const Color(0xFFE8F0E8),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: _gpsCoords != null
                                ? AppColors.successLight
                                : AppColors.primaryContainer.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _gpsCoords != null
                                ? Icons.location_on_rounded
                                : Icons.location_searching_rounded,
                            color: _gpsCoords != null ? AppColors.success : AppColors.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _gpsCoords ?? 'GPS not captured',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _gpsCoords != null
                                      ? AppColors.success
                                      : theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              if (_gpsCoords != null)
                                const Text(
                                  'Coordinates captured successfully',
                                  style: TextStyle(fontSize: 11, color: AppColors.success),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _isCapturingGps ? null : _captureGps,
                        icon: _isCapturingGps
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              )
                            : Icon(
                                _gpsCoords != null
                                    ? Icons.refresh_rounded
                                    : Icons.my_location_rounded,
                                size: 18,
                              ),
                        label: Text(_isCapturingGps
                            ? 'Getting Location...'
                            : _gpsCoords != null
                                ? 'Recapture GPS'
                                : 'Capture GPS Location'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate(delay: 180.ms).fadeIn(duration: 300.ms),
              const SizedBox(height: 24),

              // Location
              Text(
                'Location',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ).animate(delay: 200.ms).fadeIn(duration: 300.ms),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedRegion,
                decoration: InputDecoration(
                  labelText: 'Region',
                  prefixIcon: const Icon(Icons.map_outlined, size: 20),
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
                      width: 1,
                    ),
                  ),
                ),
                items: AppConstants.regions.map((r) {
                  return DropdownMenuItem(value: r, child: Text(r, style: const TextStyle(fontSize: 14)));
                }).toList(),
                onChanged: (v) => setState(() => _selectedRegion = v),
                validator: (v) => v == null ? 'Select a region' : null,
              ).animate(delay: 220.ms).fadeIn(duration: 300.ms),
              const SizedBox(height: 14),
              AppTextField(
                label: 'District',
                controller: _districtController,
                prefixIcon: Icons.location_city_outlined,
                textCapitalization: TextCapitalization.words,
                validator: (v) => v?.isEmpty == true ? 'District required' : null,
              ).animate(delay: 240.ms).fadeIn(duration: 300.ms),
              const SizedBox(height: 14),
              AppTextField(
                label: 'Community',
                controller: _communityController,
                prefixIcon: Icons.home_outlined,
                textCapitalization: TextCapitalization.words,
                validator: (v) => v?.isEmpty == true ? 'Community required' : null,
              ).animate(delay: 260.ms).fadeIn(duration: 300.ms),
              const SizedBox(height: 24),

              // Crops
              Text(
                'Crop Types',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ).animate(delay: 280.ms).fadeIn(duration: 300.ms),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppConstants.cropTypes.map((crop) {
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
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : isDark
                                ? const Color(0xFF1E2E20)
                                : const Color(0xFFF0F6F1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.transparent,
                        ),
                      ),
                      child: Text(
                        crop,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ).animate(delay: 300.ms).fadeIn(duration: 300.ms),
              const SizedBox(height: 24),

              // Harvest period
              Text(
                'Harvest Period',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ).animate(delay: 320.ms).fadeIn(duration: 300.ms),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedHarvestPeriod,
                decoration: InputDecoration(
                  labelText: 'Harvest Period',
                  prefixIcon: const Icon(Icons.calendar_month_outlined, size: 20),
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
                      width: 1,
                    ),
                  ),
                ),
                items: _harvestPeriods.map((p) {
                  return DropdownMenuItem(value: p, child: Text(p, style: const TextStyle(fontSize: 14)));
                }).toList(),
                onChanged: (v) => setState(() => _selectedHarvestPeriod = v),
              ).animate(delay: 340.ms).fadeIn(duration: 300.ms),
              const SizedBox(height: 24),

              // Photos
              Text(
                'Farm Photos',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ).animate(delay: 360.ms).fadeIn(duration: 300.ms),
              const SizedBox(height: 12),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _photoCount = (_photoCount + 1).clamp(0, 5)),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_a_photo_outlined, color: AppColors.primary, size: 24),
                          const SizedBox(height: 4),
                          Text(
                            'Add Photo',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ...List.generate(
                    _photoCount.clamp(0, 4),
                    (i) => Container(
                      width: 80,
                      height: 80,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.image_rounded,
                        color: AppColors.primary.withValues(alpha: 0.5),
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ).animate(delay: 380.ms).fadeIn(duration: 300.ms),
              const SizedBox(height: 32),

              AppButton(
                label: 'Register Farm',
                icon: Icons.terrain_rounded,
                onPressed: _isLoading ? null : _submit,
                isLoading: _isLoading,
              ).animate(delay: 400.ms).fadeIn(duration: 300.ms),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
