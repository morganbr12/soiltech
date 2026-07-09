import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../app/core/theme/app_colors.dart';
import '../../../../app/core/utils/app_logger.dart';
import '../../../../features/customer/data/products_repository.dart';
import '../../../../shared/extensions/extensions.dart';
import '../../../../shared/models/enums.dart';
import '../../../../shared/models/farmer_detail.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/shimmer_loader.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../../../shared/models/produce_entry.dart';
import '../providers/farmers_provider.dart';

class FarmerProfileScreen extends ConsumerStatefulWidget {
  final String farmerId;
  const FarmerProfileScreen({super.key, required this.farmerId});

  @override
  ConsumerState<FarmerProfileScreen> createState() => _FarmerProfileScreenState();
}

class _FarmerProfileScreenState extends ConsumerState<FarmerProfileScreen> {
  final Set<String> _locallyAddedCrops = {};

  @override
  Widget build(BuildContext context) {
    final farmerAsync = ref.watch(farmerDetailProvider(widget.farmerId));

    return farmerAsync.when(
      loading: () => const _LoadingScaffold(),
      error: (e, _) => _ErrorScaffold(
        error: e.toString(),
        onRetry: () => ref.invalidate(farmerDetailProvider(widget.farmerId)),
      ),
      data: (farmer) => _buildProfile(context, farmer),
    );
  }

  void _showCropDetailSheet(BuildContext context, String farmerId, String cropType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CropDetailSheet(farmerId: farmerId, cropType: cropType),
    );
  }

  void _showAddCropSheet(BuildContext context, FarmerDetail farmer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddCropBottomSheet(
        farmer: farmer,
        onSuccess: (String cropName) {
          ref.invalidate(farmerDetailProvider(widget.farmerId));
          setState(() => _locallyAddedCrops.add(cropName));
        },
      ),
    );
  }

  Widget _buildProfile(BuildContext context, FarmerDetail farmer) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Hero app bar ───────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3), shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(gradient: AppColors.heroGradient),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 48),
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 84,
                            height: 84,
                            decoration: BoxDecoration(
                              gradient: AppColors.cardGradient,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 12, offset: const Offset(0, 4))],
                            ),
                            child: Center(
                              child: Text(farmer.initials, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
                            ),
                          ),
                          if (farmer.kycVerified)
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(color: AppColors.success, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                              child: const Icon(Icons.check, size: 13, color: Colors.white),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(farmer.fullName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.3)),
                      const SizedBox(height: 2),
                      Text(farmer.farmerCode, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.75), fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),
                      StatusBadge.fromFarmerStatus(farmer.status),
                      if (farmer.status == FarmerStatus.rejected && farmer.rejectionReason != null) ...[
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'Reason: ${farmer.rejectionReason}',
                            style: const TextStyle(fontSize: 11, color: Colors.white70),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ── Stats row ────────────────────────────────────────────
                  Row(
                    children: [
                      _StatCard(label: 'Farms', value: '${farmer.farmsCount}', icon: Icons.terrain_rounded),
                      const SizedBox(width: 10),
                      _StatCard(label: 'Farm Size', value: farmer.totalFarmSize.acres, icon: Icons.straighten_rounded),
                      const SizedBox(width: 10),
                      _StatCard(label: 'Earnings', value: 'GHS ${farmer.totalEarnings.formatted}', icon: Icons.payments_rounded),
                    ],
                  ).animate().fadeIn(duration: 400.ms),
                  const SizedBox(height: 16),

                  // ── Wallet balance ───────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 28),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Wallet Balance', style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.8))),
                            Text(farmer.walletBalance.currency, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                  ).animate(delay: 80.ms).fadeIn(duration: 400.ms),
                  const SizedBox(height: 16),

                  // ── Personal information ─────────────────────────────────
                  _SectionCard(
                    title: 'Personal Information',
                    isDark: isDark,
                    child: Column(
                      children: [
                        _InfoRow(icon: Icons.phone_outlined, label: 'Phone', value: farmer.phone),
                        if (farmer.email != null)
                          _InfoRow(icon: Icons.email_outlined, label: 'Email', value: farmer.email!),
                        if (farmer.nationalId != null)
                          _InfoRow(icon: Icons.badge_outlined, label: 'National ID', value: farmer.nationalId!),
                        _InfoRow(
                          icon: Icons.verified_user_rounded,
                          label: 'KYC Status',
                          value: farmer.kycVerified ? 'Verified' : 'Not Verified',
                          valueColor: farmer.kycVerified ? AppColors.success : AppColors.error,
                        ),
                        _InfoRow(icon: Icons.calendar_today_outlined, label: 'Member Since', value: farmer.joinedDate.displayDate, isLast: true),
                      ],
                    ),
                  ).animate(delay: 120.ms).fadeIn(duration: 400.ms),
                  const SizedBox(height: 12),

                  // ── Location ─────────────────────────────────────────────
                  _SectionCard(
                    title: 'Location',
                    isDark: isDark,
                    child: Column(
                      children: [
                        _InfoRow(icon: Icons.map_outlined, label: 'Region', value: farmer.region),
                        _InfoRow(icon: Icons.location_city_outlined, label: 'District', value: farmer.district),
                        if (farmer.lat != null && farmer.lng != null)
                          _InfoRow(
                            icon: Icons.my_location_rounded,
                            label: 'GPS',
                            value: '${farmer.lat!.toStringAsFixed(5)}, ${farmer.lng!.toStringAsFixed(5)}',
                            isLast: true,
                          )
                        else
                          _InfoRow(
                            icon: Icons.location_off_outlined,
                            label: 'GPS',
                            value: 'Not recorded',
                            valueColor: theme.colorScheme.onSurfaceVariant,
                            isLast: true,
                          ),
                      ],
                    ),
                  ).animate(delay: 160.ms).fadeIn(duration: 400.ms),
                  const SizedBox(height: 12),

                  // ── Crop portfolio ───────────────────────────────────────
                  _SectionCard(
                    title: 'Crop Portfolio',
                    isDark: isDark,
                    action: TextButton.icon(
                      onPressed: () => _showAddCropSheet(context, farmer),
                      icon: const Icon(Icons.add_rounded, size: 16),
                      label: const Text('Add Crop'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                    child: () {
                      final allCrops = {...farmer.cropTypes, ..._locallyAddedCrops}.toList();
                      return allCrops.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline, size: 16, color: theme.colorScheme.onSurfaceVariant),
                                const SizedBox(width: 8),
                                Text('No crops listed yet', style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant)),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: allCrops.map((crop) {
                                return GestureDetector(
                                  onTap: () => _showCropDetailSheet(context, farmer.id, crop),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryContainer.withValues(alpha: 0.4),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.grass_rounded, size: 14, color: AppColors.primary),
                                        const SizedBox(width: 6),
                                        Text(crop.titleCase, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
                                        const SizedBox(width: 4),
                                        const Icon(Icons.chevron_right_rounded, size: 14, color: AppColors.primary),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                    }(),
                  ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
                  const SizedBox(height: 12),

                  // ── Agent / LBC info ─────────────────────────────────────
                  _SectionCard(
                    title: 'Agent & LBC',
                    isDark: isDark,
                    child: Column(
                      children: [
                        _InfoRow(icon: Icons.person_pin_rounded, label: 'Registered By', value: farmer.agentName),
                        _InfoRow(icon: Icons.business_rounded, label: 'LBC', value: farmer.lbcName, isLast: true),
                      ],
                    ),
                  ).animate(delay: 240.ms).fadeIn(duration: 400.ms),
                  const SizedBox(height: 20),

                  // ── Action buttons ───────────────────────────────────────
                  AppButton(
                    label: 'Record Collection',
                    icon: Icons.agriculture_rounded,
                    onPressed: () => context.push('/produce/create?farmerId=${farmer.id}'),
                  ).animate(delay: 280.ms).fadeIn(duration: 400.ms),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Register Farm',
                          variant: AppButtonVariant.outline,
                          icon: Icons.terrain_rounded,
                          onPressed: () => context.push('/farmers/farms/register?farmerId=${farmer.id}'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppButton(
                          label: 'View Payments',
                          variant: AppButtonVariant.outline,
                          icon: Icons.payments_rounded,
                          onPressed: () => context.push('/profile/payments'),
                        ),
                      ),
                    ],
                  ).animate(delay: 320.ms).fadeIn(duration: 400.ms),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Loading skeleton ─────────────────────────────────────────────────────────

class _LoadingScaffold extends StatelessWidget {
  const _LoadingScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: List.generate(4, (i) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: ShimmerBox(width: double.infinity, height: i == 0 ? 200 : 120, radius: 20),
          )),
        ),
      ),
    );
  }
}

// ─── Error scaffold ───────────────────────────────────────────────────────────

class _ErrorScaffold extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  const _ErrorScaffold({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded), onPressed: () => context.pop())),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person_off_rounded, size: 56, color: AppColors.primaryLight),
              const SizedBox(height: 16),
              const Text('Could not load farmer', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              const SizedBox(height: 8),
              Text(error, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: AppColors.primaryLight)),
              const SizedBox(height: 24),
              AppButton(label: 'Retry', icon: Icons.refresh_rounded, onPressed: onRetry),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Stat card ────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _StatCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFE8F0E8)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(label, style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// ─── Section card ─────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final bool isDark;
  final Widget? action;

  const _SectionCard({required this.title, required this.child, required this.isDark, this.action});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFE8F0E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 8, 12),
            child: Row(
              children: [
                Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                const Spacer(),
                if (action != null) action!,
              ],
            ),
          ),
          Divider(height: 1, color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFE8F0E8)),
          Padding(padding: const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }
}

// ─── Info row ─────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;
  final Color? valueColor;

  const _InfoRow({required this.icon, required this.label, required this.value, this.isLast = false, this.valueColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppColors.primary.withValues(alpha: 0.7)),
            const SizedBox(width: 10),
            Text(label, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500)),
            const Spacer(),
            Flexible(
              child: Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: valueColor), textAlign: TextAlign.end, maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
        if (!isLast) ...[
          const SizedBox(height: 12),
          Divider(height: 1, color: theme.brightness == Brightness.dark ? const Color(0xFF2A3A2A) : const Color(0xFFF0F4F0)),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

// ─── Add Crop bottom sheet ────────────────────────────────────────────────────

class _AddCropBottomSheet extends ConsumerStatefulWidget {
  final FarmerDetail farmer;
  final void Function(String cropName) onSuccess;

  const _AddCropBottomSheet({required this.farmer, required this.onSuccess});

  @override
  ConsumerState<_AddCropBottomSheet> createState() => _AddCropBottomSheetState();
}

class _AddCropBottomSheetState extends ConsumerState<_AddCropBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  // Form state
  String? _selectedCropType;
  final _varietyController = TextEditingController();
  final _gradeController = TextEditingController();
  final _priceController = TextEditingController();
  final _qtyController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _collectedAt;
  List<XFile> _selectedImages = [];

  static const _cropOptions = ['Maize', 'Cassava', 'Yam', 'Rice', 'Plantain', 'Tomato', 'Pepper'];

  @override
  void dispose() {
    _varietyController.dispose();
    _gradeController.dispose();
    _priceController.dispose();
    _qtyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final picked = await ImagePicker().pickMultiImage(imageQuality: 80, limit: 5);
    if (picked.isNotEmpty) {
      setState(() {
        // Merge avoiding duplicates by path, cap at 5 total
        final paths = _selectedImages.map((x) => x.path).toSet();
        for (final img in picked) {
          if (!paths.contains(img.path) && _selectedImages.length < 5) {
            _selectedImages.add(img);
            paths.add(img.path);
          }
        }
      });
    }
  }

  Future<void> _pickCollectedAt() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _collectedAt ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 90)),
      lastDate: DateTime.now(),
      helpText: 'Select Collection Date',
    );
    if (picked != null) setState(() => _collectedAt = picked);
  }

  Future<void> _submit() async {
    if (_selectedCropType == null) {
      setState(() => _errorMessage = 'Please select a crop type');
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() { _isLoading = true; _errorMessage = null; });

    try {
      await ref.read(productsRepositoryProvider).createProduceRecord(
        farmerId: widget.farmer.id,
        cropType: _selectedCropType!,
        quantityKg: double.parse(_qtyController.text.trim()),
        pricePerKg: double.parse(_priceController.text.trim()),
        cropVariety: _varietyController.text.trim().isNotEmpty ? _varietyController.text.trim() : null,
        grade: _gradeController.text.trim().isNotEmpty ? _gradeController.text.trim() : null,
        notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
        collectedAt: _collectedAt,
        photos: _selectedImages,
      );

      if (mounted) {
        widget.onSuccess(_selectedCropType!);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$_selectedCropType listed on marketplace!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        );
      }
    } catch (e, st) {
      appLogger.e('Create produce record failed', error: e, stackTrace: st);
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
    if (msg.contains('400')) return 'Invalid data. Check the form and try again.';
    if (msg.contains('403')) return 'You are not authorised to list crops for this farmer.';
    if (msg.contains('SocketException') || msg.contains('connection')) return 'No internet connection.';
    return 'Failed to list crop. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.of(context).viewInsets.bottom + 24),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Container(width: 36, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
                ),
              ),

              // Header
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.grass_rounded, color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Add Crop to Marketplace', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                        Text(
                          widget.farmer.fullName,
                          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Crop type dropdown
              Text('Crop Type', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCropType,
                hint: const Text('Select a crop'),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1E2E20) : const Color(0xFFF0F6F1),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFD4E4D4)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                  prefixIcon: const Icon(Icons.grass_rounded, color: AppColors.primary, size: 20),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                ),
                items: _cropOptions.map((crop) => DropdownMenuItem(
                  value: crop,
                  child: Text(crop, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                )).toList(),
                onChanged: (crop) {
                  if (crop == null) return;
                  setState(() { _selectedCropType = crop; _errorMessage = null; });
                },
                validator: (_) => _selectedCropType == null ? 'Please select a crop' : null,
              ),
              const SizedBox(height: 14),

              // Variety + Grade row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Variety (Optional)',
                      hint: 'e.g. Obaatanpa',
                      controller: _varietyController,
                      prefixIcon: Icons.eco_outlined,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppTextField(
                      label: 'Grade (Optional)',
                      hint: 'e.g. Grade A',
                      controller: _gradeController,
                      prefixIcon: Icons.star_outline_rounded,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Qty (kg) + Price per kg row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Quantity (kg)',
                      hint: '0.000',
                      controller: _qtyController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      prefixIcon: Icons.scale_outlined,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v?.trim().isEmpty == true) return 'Required';
                        final n = double.tryParse(v!.trim());
                        if (n == null || n < 0.001) return 'Min 0.001';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppTextField(
                      label: 'Price / kg (GHS)',
                      hint: '0.00',
                      controller: _priceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      prefixIcon: Icons.attach_money_rounded,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v?.trim().isEmpty == true) return 'Required';
                        final n = double.tryParse(v!.trim());
                        if (n == null || n < 0.01) return 'Min 0.01';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Collection date picker
              GestureDetector(
                onTap: _pickCollectedAt,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E2E20) : const Color(0xFFF0F6F1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFD4E4D4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.primary),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Collection Date (Optional)', style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500)),
                          Text(
                            _collectedAt?.displayDate ?? 'Tap to select',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _collectedAt == null ? theme.colorScheme.onSurfaceVariant : null),
                          ),
                        ],
                      ),
                      const Spacer(),
                      if (_collectedAt != null)
                        GestureDetector(
                          onTap: () => setState(() => _collectedAt = null),
                          child: const Icon(Icons.close_rounded, size: 18, color: AppColors.primaryLight),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Notes
              AppTextField(
                label: 'Notes (Optional)',
                hint: 'e.g. Dry and clean, ready for pickup',
                controller: _notesController,
                prefixIcon: Icons.notes_outlined,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
                maxLines: 2,
              ),
              const SizedBox(height: 18),

              // Crop images
              Row(
                children: [
                  Text('Crop Photos', style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(width: 6),
                  Text('(up to 5)', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 96,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    // Add photo button
                    if (_selectedImages.length < 5)
                      GestureDetector(
                        onTap: _pickImages,
                        child: Container(
                          width: 86,
                          height: 86,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E2E20) : const Color(0xFFF0F6F1),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              width: 1.5,
                              strokeAlign: BorderSide.strokeAlignInside,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate_outlined, color: AppColors.primary, size: 26),
                              const SizedBox(height: 4),
                              Text('Add', style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    // Thumbnails
                    ..._selectedImages.asMap().entries.map((entry) {
                      final i = entry.key;
                      final img = entry.value;
                      return Stack(
                        children: [
                          Container(
                            width: 86,
                            height: 86,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              image: DecorationImage(
                                image: FileImage(File(img.path)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 14,
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedImages.removeAt(i)),
                              child: Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.65),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close_rounded, size: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Error
              if (_errorMessage != null)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 14),
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
                      Expanded(child: Text(_errorMessage!, style: const TextStyle(fontSize: 13, color: AppColors.error, fontWeight: FontWeight.w500))),
                    ],
                  ),
                ).animate().shake(duration: 400.ms),

              AppButton(
                label: 'List on Marketplace',
                icon: Icons.storefront_rounded,
                onPressed: _isLoading ? null : _submit,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Crop Detail Sheet ────────────────────────────────────────────────────────

class _CropDetailSheet extends ConsumerWidget {
  final String farmerId;
  final String cropType;
  const _CropDetailSheet({required this.farmerId, required this.cropType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final recordsAsync = ref.watch(farmerCropRecordsProvider((farmerId, cropType)));

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Container(width: 36, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.grass_rounded, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cropType.titleCase, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                    Text('Produce Records', style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
                const Spacer(),
                recordsAsync.maybeWhen(
                  data: (records) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.primaryContainer.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(10)),
                    child: Text('${records.length}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  ),
                  orElse: () => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Body
          Flexible(
            child: recordsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2)),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 40, color: AppColors.primaryLight),
                    const SizedBox(height: 12),
                    Text('Could not load records', style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurfaceVariant)),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: () => ref.invalidate(farmerCropRecordsProvider((farmerId, cropType))),
                      icon: const Icon(Icons.refresh_rounded, size: 16),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (records) => records.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.inbox_outlined, size: 48, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
                          const SizedBox(height: 12),
                          Text('No records yet for $cropType', style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurfaceVariant)),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                      shrinkWrap: true,
                      itemCount: records.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) => _ProduceRecordCard(record: records[i], isDark: isDark),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProduceRecordCard extends StatelessWidget {
  final ProduceEntry record;
  final bool isDark;
  const _ProduceRecordCard({required this.record, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayDate = record.collectedAt ?? record.createdAt;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2E20) : const Color(0xFFF6FBF7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFE0EDE0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 13, color: AppColors.primaryLight),
              const SizedBox(width: 5),
              Text(displayDate.displayDate, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500)),
              const Spacer(),
              StatusBadge.fromProduceStatus(record.status),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _MiniStat(label: 'Quantity', value: '${record.quantityKg.formatted} kg', icon: Icons.scale_outlined),
              const SizedBox(width: 12),
              _MiniStat(label: 'Price/kg', value: record.pricePerKg.currency, icon: Icons.attach_money_rounded),
              const SizedBox(width: 12),
              _MiniStat(label: 'Total', value: record.totalAmount.currency, icon: Icons.payments_outlined),
            ],
          ),
          if (record.grade != null && record.grade!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star_outline_rounded, size: 13, color: AppColors.primaryLight),
                const SizedBox(width: 5),
                Text(record.grade!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
              ],
            ),
          ],
          if (record.notes != null && record.notes!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(record.notes!, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant), maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
          if (record.photos.isNotEmpty) ...[
            const SizedBox(height: 10),
            SizedBox(
              height: 60,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: record.photos.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) => ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(record.photos[i], width: 60, height: 60, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(width: 60, height: 60, color: AppColors.primaryContainer,
                      child: const Icon(Icons.image_not_supported_outlined, size: 20, color: AppColors.primaryLight)),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _MiniStat({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: AppColors.primaryLight),
            const SizedBox(width: 3),
            Text(label, style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ],
        ),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
      ],
    );
  }
}
