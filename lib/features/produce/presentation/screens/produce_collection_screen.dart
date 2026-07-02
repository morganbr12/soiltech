import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/core/constants/app_constants.dart';
import '../../../../app/core/theme/app_colors.dart';
import '../../../../shared/models/dummy_data.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';

class ProduceCollectionScreen extends StatefulWidget {
  final String? farmerId;
  const ProduceCollectionScreen({super.key, this.farmerId});

  @override
  State<ProduceCollectionScreen> createState() => _ProduceCollectionScreenState();
}

class _ProduceCollectionScreenState extends State<ProduceCollectionScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isSavingDraft = false;
  int _photoCount = 0;

  String? _selectedFarmerId;
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
        title: const Text('Record Collection'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _isSavingDraft ? null : () => _submit(isDraft: true),
            child: _isSavingDraft
                ? const SizedBox(
                    width: 16,
                    height: 16,
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

              // Farmer selection
              _SectionTitle(title: 'Farmer & Farm', step: 1),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedFarmerId,
                decoration: InputDecoration(
                  labelText: 'Select Farmer',
                  prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
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
                items: DummyData.farmers.map((f) {
                  return DropdownMenuItem(
                    value: f.id,
                    child: Text('${f.name} (${f.community})',
                        style: const TextStyle(fontSize: 14)),
                  );
                }).toList(),
                onChanged: (v) => setState(() => _selectedFarmerId = v),
                validator: (v) => v == null ? 'Select a farmer' : null,
              ).animate(delay: 100.ms).fadeIn(duration: 300.ms),
              const SizedBox(height: 24),

              // Produce details
              _SectionTitle(title: 'Produce Details', step: 2),
              const SizedBox(height: 12),

              // Crop type
              DropdownButtonFormField<String>(
                value: _selectedCropType,
                decoration: InputDecoration(
                  labelText: 'Crop Type',
                  prefixIcon: const Icon(Icons.grass_rounded, size: 20),
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
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
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
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                ],
                validator: (v) {
                  if (v?.isEmpty == true) return 'Moisture required';
                  final val = double.tryParse(v!);
                  if (val == null || val < 0 || val > 100) return 'Enter 0-100';
                  return null;
                },
              ).animate(delay: 180.ms).fadeIn(duration: 300.ms),
              const SizedBox(height: 24),

              // Quality grade
              _SectionTitle(title: 'Quality Assessment', step: 3),
              const SizedBox(height: 12),
              Row(
                children: AppConstants.qualityGrades.map((grade) {
                  final isSelected = _selectedGrade == grade;
                  Color gradeColor = switch (grade) {
                    'Grade A' => AppColors.success,
                    'Grade B' => AppColors.info,
                    'Grade C' => AppColors.warning,
                    _ => AppColors.error,
                  };
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedGrade = grade),
                      child: Container(
                        margin: EdgeInsets.only(
                          right: grade == AppConstants.qualityGrades.last ? 0 : 8,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? gradeColor.withValues(alpha: 0.12)
                              : isDark
                                  ? AppColors.surfaceVariantDark
                                  : AppColors.surfaceVariantLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? gradeColor : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              grade.replaceAll('Grade ', ''),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: isSelected ? gradeColor : theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              grade.contains('Grade') ? grade.split(' ').first : grade,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? gradeColor
                                    : theme.colorScheme.onSurfaceVariant,
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

              // Photos
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
                        width: 80,
                        height: 80,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_outlined, color: AppColors.primary, size: 22),
                            const SizedBox(height: 4),
                            Text(
                              '$_photoCount/${AppConstants.maxUploadImages}',
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
                    ...List.generate(
                      _photoCount,
                      (i) => Container(
                        width: 80,
                        height: 80,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Icon(
                                Icons.image_rounded,
                                color: AppColors.primary.withValues(alpha: 0.4),
                                size: 32,
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => setState(() => _photoCount--),
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: AppColors.error,
                                    shape: BoxShape.circle,
                                  ),
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

              // Pricing
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
                      decoration: BoxDecoration(
                        gradient: AppColors.cardGradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Est. Value',
                            style: TextStyle(fontSize: 11, color: Colors.white70),
                          ),
                          Text(
                            'GHS ${_totalValue.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
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
                    border: Border.all(
                      color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFD4E4D4),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Collection Date',
                              style: TextStyle(fontSize: 11, color: AppColors.outlineLight),
                            ),
                            Text(
                              '${_collectionDate.day}/${_collectionDate.month}/${_collectionDate.year}',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_drop_down_rounded,
                          color: theme.colorScheme.onSurfaceVariant),
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

              // Submit
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

class _SectionTitle extends StatelessWidget {
  final String title;
  final int step;

  const _SectionTitle({required this.title, required this.step});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
          child: Center(
            child: Text(
              '$step',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
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
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Collection Preview',
                  style: TextStyle(fontSize: 12, color: Colors.white70, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  weight > 0 ? '${weight.toStringAsFixed(1)} kg' : 'Enter weight',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _PreviewPill(label: cropType),
                    const SizedBox(width: 6),
                    _PreviewPill(label: grade),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Est. Value',
                style: TextStyle(fontSize: 11, color: Colors.white60),
              ),
              Text(
                'GHS ${totalValue.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
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
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }
}
