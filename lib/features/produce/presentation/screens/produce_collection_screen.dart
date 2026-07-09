import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/core/constants/app_constants.dart';
import '../../../../app/core/theme/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../farmers/presentation/providers/farmers_provider.dart';

class ProduceCollectionScreen extends ConsumerStatefulWidget {
  final String? farmerId;
  const ProduceCollectionScreen({super.key, this.farmerId});

  @override
  ConsumerState<ProduceCollectionScreen> createState() => _ProduceCollectionScreenState();
}

class _ProduceCollectionScreenState extends ConsumerState<ProduceCollectionScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isSavingDraft = false;
  int _photoCount = 0;

  String? _selectedFarmerId;
  String? _selectedFarmId;
  String? _selectedCropType;
  String? _selectedGrade;
  final _weightController = TextEditingController();
  final _bagsController = TextEditingController();
  final _moistureController = TextEditingController();
  final _notesController = TextEditingController();
  final _priceController = TextEditingController(text: '16.50');
  DateTime _collectionDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.farmerId != null) _selectedFarmerId = widget.farmerId;
  }

  @override
  void dispose() {
    _weightController.dispose();
    _bagsController.dispose();
    _moistureController.dispose();
    _notesController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  double get _totalValue {
    final weight = double.tryParse(_weightController.text) ?? 0;
    final price = double.tryParse(_priceController.text) ?? 0;
    return weight * price;
  }

  void _onFarmerChanged(String? farmerId) {
    setState(() {
      _selectedFarmerId = farmerId;
      _selectedFarmId = null; // reset farm when farmer changes
    });
  }

  Future<void> _submit({bool isDraft = false}) async {
    if (!isDraft && !(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      if (isDraft) {
        _isSavingDraft = true;
      } else {
        _isLoading = true;
      }
    });
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isLoading = false;
        _isSavingDraft = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isDraft ? 'Draft saved!' : 'Collection submitted successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop();
    }
  }

  InputDecoration _dropdownDecoration(String label, IconData icon, bool isDark) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      filled: true,
      fillColor: isDark ? const Color(0xFF1E2E20) : const Color(0xFFF0F6F1),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFD4E4D4), width: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final farmersAsync = ref.watch(allFarmersProvider);
    final farmsAsync = _selectedFarmerId != null
        ? ref.watch(farmerFarmsProvider(_selectedFarmerId!))
        : null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.close_rounded),
        ),
        title: const Text('Record Collection'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _isSavingDraft ? null : () => _submit(isDraft: true),
            child: _isSavingDraft
                ? const SizedBox(
                    width: 16, height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                  )
                : const Text('Save Draft'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Preview card
              _ValuePreviewCard(
                weight: double.tryParse(_weightController.text) ?? 0,
                totalValue: _totalValue,
                cropType: _selectedCropType ?? '–',
                grade: _selectedGrade ?? '–',
                isDark: isDark,
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 24),

              // ── Step 1: Farmer & Farm ───────────────────────────────────────
              _SectionTitle(title: 'Farmer & Farm', step: 1),
              const SizedBox(height: 12),

              // Farmer dropdown
              farmersAsync.when(
                loading: () => _DropdownSkeleton(isDark: isDark, label: 'Select Farmer'),
                error: (e, _) => _DropdownError(
                  label: 'Select Farmer',
                  error: e.toString(),
                  onRetry: () => ref.invalidate(allFarmersProvider),
                  isDark: isDark,
                ),
                data: (farmers) => DropdownButtonFormField<String>(
                  value: _selectedFarmerId,
                  decoration: _dropdownDecoration('Select Farmer', Icons.person_outline_rounded, isDark),
                  isExpanded: true,
                  items: farmers.map((f) => DropdownMenuItem(
                    value: f.id,
                    child: Text(
                      '${f.fullName}${f.region.isNotEmpty ? ' · ${f.region}' : ''}',
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )).toList(),
                  onChanged: _onFarmerChanged,
                  validator: (v) => v == null ? 'Select a farmer' : null,
                ),
              ).animate(delay: 100.ms).fadeIn(duration: 300.ms),
              const SizedBox(height: 14),

              // Farm dropdown — shows after farmer is selected
              if (_selectedFarmerId != null) ...[
                farmsAsync!.when(
                  loading: () => _DropdownSkeleton(isDark: isDark, label: 'Select Farm'),
                  error: (e, _) => _DropdownError(
                    label: 'Select Farm',
                    error: e.toString(),
                    onRetry: () => ref.invalidate(farmerFarmsProvider(_selectedFarmerId!)),
                    isDark: isDark,
                  ),
                  data: (farms) => farms.isEmpty
                      ? Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E2E20) : const Color(0xFFF0F6F1),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFD4E4D4),
                            ),
                          ),
                          child: Row(children: [
                            const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.primaryLight),
                            const SizedBox(width: 10),
                            Text('No farms registered for this farmer',
                                style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant)),
                          ]),
                        )
                      : DropdownButtonFormField<String>(
                          value: _selectedFarmId,
                          decoration: _dropdownDecoration('Select Farm', Icons.landscape_outlined, isDark),
                          isExpanded: true,
                          items: farms.map((farm) => DropdownMenuItem(
                            value: farm.id,
                            child: Text(
                              '${farm.name} · ${farm.community}',
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )).toList(),
                          onChanged: (v) => setState(() => _selectedFarmId = v),
                        ),
                ).animate(delay: 80.ms).fadeIn(duration: 300.ms).slideY(begin: -0.03, end: 0),
                const SizedBox(height: 10),
              ],
              const SizedBox(height: 14),

              // ── Step 2: Produce Details ─────────────────────────────────────
              _SectionTitle(title: 'Produce Details', step: 2),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: _selectedCropType,
                decoration: _dropdownDecoration('Crop Type', Icons.grass_rounded, isDark),
                items: AppConstants.cropTypes.map((c) {
                  return DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 14)));
                }).toList(),
                onChanged: (v) => setState(() => _selectedCropType = v),
                validator: (v) => v == null ? 'Select crop type' : null,
              ).animate(delay: 120.ms).fadeIn(duration: 300.ms),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Weight (kg)',
                      hint: '0.0',
                      controller: _weightController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      prefixIcon: Icons.scale_rounded,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                      onChanged: (_) => setState(() {}),
                      validator: (v) {
                        if (v?.isEmpty == true) return 'Weight required';
                        if (double.tryParse(v!) == null) return 'Invalid';
                        return null;
                      },
                    ).animate(delay: 140.ms).fadeIn(duration: 300.ms),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextField(
                      label: 'No. of Bags',
                      hint: '0',
                      controller: _bagsController,
                      keyboardType: TextInputType.number,
                      prefixIcon: Icons.inventory_2_outlined,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (v) {
                        if (v?.isEmpty == true) return 'Bags required';
                        return null;
                      },
                    ).animate(delay: 160.ms).fadeIn(duration: 300.ms),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: 'Moisture Content (%)',
                hint: '0.0',
                controller: _moistureController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                prefixIcon: Icons.water_drop_outlined,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}'))],
                validator: (v) {
                  if (v?.isEmpty == true) return 'Moisture required';
                  final val = double.tryParse(v!);
                  if (val == null || val < 0 || val > 100) return 'Enter 0-100';
                  return null;
                },
              ).animate(delay: 180.ms).fadeIn(duration: 300.ms),
              const SizedBox(height: 24),

              // ── Step 3: Quality ─────────────────────────────────────────────
              _SectionTitle(title: 'Quality Assessment', step: 3),
              const SizedBox(height: 12),
              Row(
                children: AppConstants.qualityGrades.map((grade) {
                  final isSelected = _selectedGrade == grade;
                  final gradeColor = switch (grade) {
                    'Grade A' => AppColors.success,
                    'Grade B' => AppColors.info,
                    'Grade C' => AppColors.warning,
                    _ => AppColors.error,
                  };
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedGrade = grade),
                      child: Container(
                        margin: EdgeInsets.only(right: grade == AppConstants.qualityGrades.last ? 0 : 8),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? gradeColor.withValues(alpha: 0.12)
                              : isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isSelected ? gradeColor : Colors.transparent, width: 2),
                        ),
                        child: Column(
                          children: [
                            Text(
                              grade.replaceAll('Grade ', ''),
                              style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w800,
                                color: isSelected ? gradeColor : theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              grade.contains('Grade') ? grade.split(' ').first : grade,
                              style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w500,
                                color: isSelected ? gradeColor : theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ).animate(delay: 200.ms).fadeIn(duration: 300.ms),
              const SizedBox(height: 24),

              // ── Step 4: Photos ──────────────────────────────────────────────
              _SectionTitle(title: 'Produce Photos', step: 4),
              const SizedBox(height: 12),
              SizedBox(
                height: 88,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() {
                        if (_photoCount < AppConstants.maxUploadImages) _photoCount++;
                      }),
                      child: Container(
                        width: 80, height: 80,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_outlined, color: AppColors.primary, size: 22),
                            const SizedBox(height: 4),
                            Text(
                              '$_photoCount/${AppConstants.maxUploadImages}',
                              style: TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ...List.generate(
                      _photoCount,
                      (i) => Container(
                        width: 80, height: 80,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Stack(
                          children: [
                            Center(child: Icon(Icons.image_rounded, color: AppColors.primary.withValues(alpha: 0.4), size: 32)),
                            Positioned(
                              top: 4, right: 4,
                              child: GestureDetector(
                                onTap: () => setState(() => _photoCount--),
                                child: Container(
                                  width: 20, height: 20,
                                  decoration: BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                                  child: const Icon(Icons.close, size: 12, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate(delay: 220.ms).fadeIn(duration: 300.ms),
              const SizedBox(height: 24),

              // ── Step 5: Pricing ─────────────────────────────────────────────
              _SectionTitle(title: 'Pricing', step: 5),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Price per kg (GHS)',
                      controller: _priceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      prefixIcon: Icons.attach_money_rounded,
                      onChanged: (_) => setState(() {}),
                    ).animate(delay: 240.ms).fadeIn(duration: 300.ms),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(gradient: AppColors.cardGradient, borderRadius: BorderRadius.circular(14)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Est. Value', style: TextStyle(fontSize: 11, color: Colors.white70)),
                          Text(
                            'GHS ${_totalValue.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                        ],
                      ),
                    ).animate(delay: 260.ms).fadeIn(duration: 300.ms),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Collection date
              GestureDetector(
                onTap: () async {
                  final d = await showDatePicker(
                    context: context,
                    initialDate: _collectionDate,
                    firstDate: DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now(),
                    builder: (ctx, child) => Theme(
                      data: Theme.of(ctx).copyWith(
                        colorScheme: Theme.of(ctx).colorScheme.copyWith(primary: AppColors.primary),
                      ),
                      child: child!,
                    ),
                  );
                  if (d != null) setState(() => _collectionDate = d);
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E2E20) : const Color(0xFFF0F6F1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFD4E4D4), width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Collection Date', style: TextStyle(fontSize: 11, color: AppColors.outlineLight)),
                            Text(
                              '${_collectionDate.day}/${_collectionDate.month}/${_collectionDate.year}',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_drop_down_rounded, color: theme.colorScheme.onSurfaceVariant),
                    ],
                  ),
                ),
              ).animate(delay: 280.ms).fadeIn(duration: 300.ms),
              const SizedBox(height: 14),

              AppTextField(
                label: 'Notes (Optional)',
                hint: 'Any additional observations...',
                controller: _notesController,
                maxLines: 3,
                prefixIcon: Icons.notes_rounded,
              ).animate(delay: 300.ms).fadeIn(duration: 300.ms),
              const SizedBox(height: 32),

              AppButton(
                label: 'Submit Collection',
                icon: Icons.check_circle_rounded,
                onPressed: _isLoading ? null : () => _submit(isDraft: false),
                isLoading: _isLoading,
              ).animate(delay: 320.ms).fadeIn(duration: 300.ms),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Helper widgets ───────────────────────────────────────────────────────────

class _DropdownSkeleton extends StatelessWidget {
  final bool isDark;
  final String label;
  const _DropdownSkeleton({required this.isDark, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2E20) : const Color(0xFFF0F6F1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFD4E4D4)),
      ),
      child: Row(children: [
        const SizedBox(width: 12),
        const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)),
        const SizedBox(width: 12),
        Text('Loading $label…', style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ]),
    );
  }
}

class _DropdownError extends StatelessWidget {
  final bool isDark;
  final String label;
  final String error;
  final VoidCallback onRetry;
  const _DropdownError({required this.isDark, required this.label, required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(children: [
        const Icon(Icons.error_outline_rounded, size: 18, color: AppColors.error),
        const SizedBox(width: 8),
        Expanded(child: Text('Could not load $label', style: const TextStyle(fontSize: 13))),
        TextButton(onPressed: onRetry, child: const Text('Retry')),
      ]),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final int step;
  const _SectionTitle({required this.title, required this.step});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 22, height: 22,
          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
          child: Center(child: Text('$step', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white))),
        ),
        const SizedBox(width: 8),
        Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _ValuePreviewCard extends StatelessWidget {
  final double weight;
  final double totalValue;
  final String cropType;
  final String grade;
  final bool isDark;

  const _ValuePreviewCard({
    required this.weight,
    required this.totalValue,
    required this.cropType,
    required this.grade,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Collection Preview', style: TextStyle(fontSize: 12, color: Colors.white70, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(
                  weight > 0 ? '${weight.toStringAsFixed(1)} kg' : 'Enter weight',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.5),
                ),
                const SizedBox(height: 8),
                Row(children: [
                  _PreviewPill(label: cropType),
                  const SizedBox(width: 6),
                  _PreviewPill(label: grade),
                ]),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Est. Value', style: TextStyle(fontSize: 11, color: Colors.white60)),
              Text(
                'GHS ${totalValue.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviewPill extends StatelessWidget {
  final String label;
  const _PreviewPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
    );
  }
}
