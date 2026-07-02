import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/core/theme/app_colors.dart';
import '../../../../shared/extensions/extensions.dart';
import '../../../../shared/models/dummy_data.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/status_badge.dart';

class FarmerProfileScreen extends StatelessWidget {
  final String farmerId;
  const FarmerProfileScreen({super.key, required this.farmerId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final farmer = DummyData.farmers.firstWhere(
      (f) => f.id == farmerId,
      orElse: () => DummyData.farmers.first,
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero app bar
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => context.push('/farmers/profile/${farmer.id}/edit'),
                icon: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit_rounded, color: Colors.white, size: 18),
                ),
              ),
              const SizedBox(width: 4),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(gradient: AppColors.heroGradient),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      // Avatar
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: AppColors.cardGradient,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            farmer.name.split(' ').map((n) => n[0]).take(2).join(),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        farmer.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        farmer.community,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 10),
                      StatusBadge.fromFarmerStatus(farmer.status),
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
                  // Stats row
                  Row(
                    children: [
                      _StatCard(
                        label: 'Total Farms',
                        value: '${farmer.totalFarms}',
                        icon: Icons.terrain_rounded,
                      ),
                      const SizedBox(width: 10),
                      _StatCard(
                        label: 'Acreage',
                        value: farmer.totalAcreage.acres,
                        icon: Icons.straighten_rounded,
                      ),
                      const SizedBox(width: 10),
                      _StatCard(
                        label: 'Total Sold',
                        value: '${(farmer.totalCollected / 1000).toStringAsFixed(1)}t',
                        icon: Icons.scale_rounded,
                      ),
                    ],
                  ).animate().fadeIn(duration: 400.ms),
                  const SizedBox(height: 16),

                  // Personal Info
                  _SectionCard(
                    title: 'Personal Information',
                    isDark: isDark,
                    child: Column(
                      children: [
                        _InfoRow(
                          icon: Icons.badge_outlined,
                          label: 'National ID',
                          value: farmer.nationalId,
                        ),
                        _InfoRow(
                          icon: Icons.phone_outlined,
                          label: 'Phone',
                          value: farmer.phone,
                        ),
                        _InfoRow(
                          icon: Icons.location_on_outlined,
                          label: 'Community',
                          value: farmer.community,
                        ),
                        _InfoRow(
                          icon: Icons.map_outlined,
                          label: 'District',
                          value: farmer.district,
                        ),
                        _InfoRow(
                          icon: Icons.place_outlined,
                          label: 'Region',
                          value: farmer.region,
                        ),
                        _InfoRow(
                          icon: Icons.calendar_today_outlined,
                          label: 'Registered',
                          value: farmer.registeredDate.displayDate,
                          isLast: true,
                        ),
                      ],
                    ),
                  ).animate(delay: 100.ms).fadeIn(duration: 400.ms),
                  const SizedBox(height: 12),

                  // Crops
                  _SectionCard(
                    title: 'Crop Portfolio',
                    isDark: isDark,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: farmer.crops.map((crop) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.grass_rounded, size: 14, color: AppColors.primary),
                                const SizedBox(width: 6),
                                Text(
                                  crop,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
                  const SizedBox(height: 12),

                  // Financial summary
                  _SectionCard(
                    title: 'Financial Summary',
                    isDark: isDark,
                    child: Column(
                      children: [
                        _InfoRow(
                          icon: Icons.scale_rounded,
                          label: 'Total Produce Sold',
                          value: farmer.totalCollected.formattedWithUnit,
                        ),
                        _InfoRow(
                          icon: Icons.payments_rounded,
                          label: 'Estimated Value',
                          value: (farmer.totalCollected * 16.5).currency,
                          isLast: true,
                        ),
                      ],
                    ),
                  ).animate(delay: 300.ms).fadeIn(duration: 400.ms),
                  const SizedBox(height: 20),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Record Collection',
                          icon: Icons.agriculture_rounded,
                          onPressed: () => context.push('/produce/create?farmerId=${farmer.id}'),
                        ),
                      ),
                    ],
                  ).animate(delay: 400.ms).fadeIn(duration: 400.ms),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Register Farm',
                          variant: AppButtonVariant.outline,
                          icon: Icons.terrain_rounded,
                          onPressed: () =>
                              context.push('/farmers/farms/register?farmerId=${farmer.id}'),
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
                  ).animate(delay: 450.ms).fadeIn(duration: 400.ms),
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
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFE8F0E8),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final bool isDark;

  const _SectionCard({required this.title, required this.child, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFE8F0E8),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFE8F0E8),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppColors.primary.withValues(alpha: 0.7)),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Flexible(
              child: Text(
                value,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                textAlign: TextAlign.end,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        if (!isLast) ...[
          const SizedBox(height: 12),
          Divider(
            height: 1,
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF2A3A2A)
                : const Color(0xFFF0F4F0),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
