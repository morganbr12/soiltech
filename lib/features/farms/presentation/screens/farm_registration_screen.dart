import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/core/constants/app_constants.dart';
import '../../../../app/core/theme/app_colors.dart';
import '../../../../app/core/utils/app_logger.dart';
import '../../../../features/farmers/presentation/providers/farmers_provider.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../data/farms_repository.dart';

class FarmRegistrationScreen extends ConsumerStatefulWidget {
  final String farmerId;
  const FarmRegistrationScreen({super.key, required this.farmerId});

  @override
  ConsumerState<FarmRegistrationScreen> createState() => _FarmRegistrationScreenState();
}

class _FarmRegistrationScreenState extends ConsumerState<FarmRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  // Fields
  final _nameController = TextEditingController();
  final _sizeController = TextEditingController();
  final _locationController = TextEditingController();
  String? _selectedCropType;

  // GPS
  bool _isCapturingGps = false;
  double? _latitude;
  double? _longitude;
  String? _gpsError;

  // Photos
  final List<XFile> _photos = [];
  final _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _sizeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // ── GPS ────────────────────────────────────────────────────────────────────

  Future<void> _captureGps() async {
    setState(() { _isCapturingGps = true; _gpsError = null; });
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('Location services are disabled');

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) throw Exception('Location permission denied');
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permission permanently denied — enable it in Settings');
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      setState(() { _latitude = pos.latitude; _longitude = pos.longitude; });
    } catch (e) {
      appLogger.w('GPS capture failed: $e');
      setState(() => _gpsError = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isCapturingGps = false);
    }
  }

  void _clearGps() => setState(() { _latitude = null; _longitude = null; _gpsError = null; });

  // ── Photos ─────────────────────────────────────────────────────────────────

  Future<void> _pickPhotos() async {
    final images = await _picker.pickMultiImage(imageQuality: 80);
    if (images.isNotEmpty) {
      setState(() => _photos.addAll(images));
    }
  }

  void _removePhoto(int index) => setState(() => _photos.removeAt(index));

  // ── Submit ─────────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedCropType == null) {
      setState(() => _errorMessage = 'Please select a crop type');
      return;
    }
    setState(() { _isLoading = true; _errorMessage = null; });

    try {
      await ref.read(farmsRepositoryProvider).registerFarm(
        farmerId: widget.farmerId,
        name: _nameController.text.trim(),
        sizeHectares: double.parse(_sizeController.text.trim()),
        cropType: _selectedCropType!,
        location: _locationController.text.trim(),
        latitude: _latitude,
        longitude: _longitude,
        photos: _photos,
      );

      // Refresh the farmer profile so farmsCount updates
      ref.invalidate(farmerDetailProvider(widget.farmerId));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_nameController.text.trim()} registered successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e, st) {
      appLogger.e('Register farm failed', error: e, stackTrace: st);
      if (mounted) setState(() { _isLoading = false; _errorMessage = _parseError(e); });
      return;
    }

    if (mounted) setState(() => _isLoading = false);
  }

  String _parseError(Object e) {
    final msg = e.toString();
    if (msg.contains('400')) return 'Invalid data. Check the form and try again.';
    if (msg.contains('404')) return 'Farmer not found.';
    if (msg.contains('SocketException') || msg.contains('connection')) return 'No internet connection.';
    return 'Registration failed. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hasGps = _latitude != null && _longitude != null;

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
              // Header banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppColors.cardGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.terrain_rounded, color: Colors.white, size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Farm Details', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                          Text('Fill in the farm information below', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 24),

              // ── Basic info ────────────────────────────────────────────────
              _SectionLabel('Basic Information').animate(delay: 80.ms).fadeIn(),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Farm Name',
                hint: 'e.g. Mensah Family Farm',
                controller: _nameController,
                prefixIcon: Icons.terrain_outlined,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: (v) => v?.trim().isEmpty == true ? 'Farm name required' : null,
              ).animate(delay: 100.ms).fadeIn(),
              const SizedBox(height: 14),
              AppTextField(
                label: 'Farm Size (hectares)',
                hint: 'e.g. 2.5',
                controller: _sizeController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                prefixIcon: Icons.straighten_rounded,
                textInputAction: TextInputAction.next,
                validator: (v) {
                  if (v?.trim().isEmpty == true) return 'Farm size required';
                  if (double.tryParse(v!.trim()) == null) return 'Enter a valid number';
                  return null;
                },
              ).animate(delay: 120.ms).fadeIn(),
              const SizedBox(height: 14),
              AppTextField(
                label: 'Location',
                hint: 'e.g. Ashanti, Kumasi',
                controller: _locationController,
                prefixIcon: Icons.place_outlined,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                validator: (v) => v?.trim().isEmpty == true ? 'Location required' : null,
              ).animate(delay: 140.ms).fadeIn(),
              const SizedBox(height: 24),

              // ── Crop type (single) ────────────────────────────────────────
              _SectionLabel('Crop Type').animate(delay: 160.ms).fadeIn(),
              const SizedBox(height: 4),
              Text(
                'Select the primary crop for this farm',
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ).animate(delay: 170.ms).fadeIn(),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: AppConstants.cropTypes.asMap().entries.map((e) {
                  final crop = e.value;
                  final isSelected = _selectedCropType == crop;
                  return GestureDetector(
                    onTap: () => setState(() { _selectedCropType = crop; _errorMessage = null; }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : isDark
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
                  ).animate(delay: Duration(milliseconds: 180 + 40 * e.key)).fadeIn();
                }).toList(),
              ),
              const SizedBox(height: 24),

              // ── GPS location ──────────────────────────────────────────────
              _SectionLabel('GPS Coordinates (Optional)').animate(delay: 320.ms).fadeIn(),
              const SizedBox(height: 12),
              _GpsCard(
                isDark: isDark,
                hasGps: hasGps,
                isCapturing: _isCapturingGps,
                latitude: _latitude,
                longitude: _longitude,
                error: _gpsError,
                onCapture: _captureGps,
                onClear: _clearGps,
              ).animate(delay: 340.ms).fadeIn(),
              const SizedBox(height: 24),

              // ── Farm photos ───────────────────────────────────────────────
              Row(
                children: [
                  _SectionLabel('Farm Photos (Optional)'),
                  const Spacer(),
                  if (_photos.isNotEmpty)
                    Text(
                      '${_photos.length} selected',
                      style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600),
                    ),
                ],
              ).animate(delay: 360.ms).fadeIn(),
              const SizedBox(height: 12),
              _PhotoGrid(
                photos: _photos,
                onAdd: _pickPhotos,
                onRemove: _removePhoto,
                isDark: isDark,
              ).animate(delay: 380.ms).fadeIn(),
              const SizedBox(height: 28),

              // ── Error ─────────────────────────────────────────────────────
              if (_errorMessage != null)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
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

              AppButton(
                label: 'Register Farm',
                icon: Icons.terrain_rounded,
                onPressed: _isLoading ? null : _submit,
                isLoading: _isLoading,
              ).animate(delay: 400.ms).fadeIn(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── GPS card ─────────────────────────────────────────────────────────────────

class _GpsCard extends StatelessWidget {
  final bool isDark;
  final bool hasGps;
  final bool isCapturing;
  final double? latitude;
  final double? longitude;
  final String? error;
  final VoidCallback onCapture;
  final VoidCallback onClear;

  const _GpsCard({
    required this.isDark,
    required this.hasGps,
    required this.isCapturing,
    required this.latitude,
    required this.longitude,
    required this.error,
    required this.onCapture,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasGps
              ? AppColors.success.withValues(alpha: 0.5)
              : error != null
                  ? AppColors.error.withValues(alpha: 0.4)
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
                  color: hasGps
                      ? AppColors.successLight
                      : error != null
                          ? AppColors.errorLight
                          : AppColors.primaryContainer.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  hasGps ? Icons.location_on_rounded : error != null ? Icons.location_off_rounded : Icons.location_searching_rounded,
                  color: hasGps ? AppColors.success : error != null ? AppColors.error : AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasGps) ...[
                      Text(
                        '${latitude!.toStringAsFixed(5)}, ${longitude!.toStringAsFixed(5)}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.success),
                      ),
                      const Text('Coordinates captured', style: TextStyle(fontSize: 11, color: AppColors.success)),
                    ] else if (error != null) ...[
                      Text(error!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.error)),
                    ] else ...[
                      Text(
                        'GPS not captured',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                      Text(
                        'Optional — improves farm mapping',
                        style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ],
                ),
              ),
              if (hasGps)
                IconButton(
                  onPressed: onClear,
                  icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.error),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: isCapturing ? null : onCapture,
              icon: isCapturing
                  ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
                  : Icon(hasGps ? Icons.refresh_rounded : Icons.my_location_rounded, size: 18),
              label: Text(isCapturing ? 'Getting Location…' : hasGps ? 'Recapture GPS' : 'Capture GPS Location'),
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
    );
  }
}

// ─── Photo grid ───────────────────────────────────────────────────────────────

class _PhotoGrid extends StatelessWidget {
  final List<XFile> photos;
  final VoidCallback onAdd;
  final void Function(int) onRemove;
  final bool isDark;

  const _PhotoGrid({
    required this.photos,
    required this.onAdd,
    required this.onRemove,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        // Thumbnails
        ...photos.asMap().entries.map((e) {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(e.value.path),
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => onRemove(e.key),
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                    child: const Icon(Icons.close_rounded, size: 14, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        }),

        // Add button
        GestureDetector(
          onTap: onAdd,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.4),
                style: BorderStyle.solid,
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_a_photo_outlined, color: AppColors.primary, size: 22),
                SizedBox(height: 4),
                Text('Add Photo', style: TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Section label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}
