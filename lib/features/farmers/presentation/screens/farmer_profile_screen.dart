import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/core/theme/app_colors.dart';
import '../../../../shared/extensions/extensions.dart';
import '../../../../shared/models/enums.dart';
import '../../../../shared/models/farmer_detail.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/shimmer_loader.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../providers/farmers_provider.dart';

class FarmerProfileScreen extends ConsumerWidget {
  final String farmerId;
  const FarmerProfileScreen({super.key, required this.farmerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final farmerAsync = ref.watch(farmerDetailProvider(farmerId));

    return farmerAsync.when(
      loading: () => const _LoadingScaffold(),
      error: (e, _) => _ErrorScaffold(error: e.toString(), onRetry: () => ref.invalidate(farmerDetailProvider(farmerId))),
      data: (farmer) => _ProfileBody(farmer: farmer, farmerId: farmerId),
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
          children: List.generate(
            4,
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: ShimmerBox(width: double.infinity, height: i == 0 ? 200 : 120, radius: 20),
            ),
          ),
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
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded), onPressed: () => context.pop()),
      ),
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

// ─── Full profile body ────────────────────────────────────────────────────────

class _ProfileBody extends StatelessWidget {
  final FarmerDetail farmer;
  final String farmerId;

  const _ProfileBody({required this.farmer, required this.farmerId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Hero app bar ────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 240,
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
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(gradient: AppColors.heroGradient),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 48),
                      // Avatar with KYC badge
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
                                farmer.initials,
                                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white),
                              ),
                            ),
                          ),
                          if (farmer.kycVerified)
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(Icons.check, size: 13, color: Colors.white),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        farmer.fullName,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.3),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        farmer.farmerCode,
                        style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.75), fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      StatusBadge.fromFarmerStatus(farmer.status),
                      // Rejection reason
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
                  // ── Stats row ──────────────────────────────────────────────
                  Row(
                    children: [
                      _StatCard(
                        label: 'Farms',
                        value: '${farmer.farmsCount}',
                        icon: Icons.terrain_rounded,
                      ),
                      const SizedBox(width: 10),
                      _StatCard(
                        label: 'Farm Size',
                        value: farmer.totalFarmSize.acres,
                        icon: Icons.straighten_rounded,
                      ),
                      const SizedBox(width: 10),
                      _StatCard(
                        label: 'Earnings',
                        value: 'GHS ${farmer.totalEarnings.formatted}',
                        icon: Icons.payments_rounded,
                      ),
                    ],
                  ).animate().fadeIn(duration: 400.ms),
                  const SizedBox(height: 16),

                  // ── Wallet balance banner ──────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 28),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Wallet Balance',
                              style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.8)),
                            ),
                            Text(
                              farmer.walletBalance.currency,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).animate(delay: 80.ms).fadeIn(duration: 400.ms),
                  const SizedBox(height: 16),

                  // ── Personal information ───────────────────────────────────
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
                        _InfoRow(
                          icon: Icons.calendar_today_outlined,
                          label: 'Member Since',
                          value: farmer.joinedDate.displayDate,
                          isLast: true,
                        ),
                      ],
                    ),
                  ).animate(delay: 120.ms).fadeIn(duration: 400.ms),
                  const SizedBox(height: 12),

                  // ── Location ───────────────────────────────────────────────
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
                            valueColor: Theme.of(context).colorScheme.onSurfaceVariant,
                            isLast: true,
                          ),
                      ],
                    ),
                  ).animate(delay: 160.ms).fadeIn(duration: 400.ms),
                  const SizedBox(height: 12),

                  // ── Crop portfolio ─────────────────────────────────────────
                  if (farmer.cropTypes.isNotEmpty)
                    _SectionCard(
                      title: 'Crop Portfolio',
                      isDark: isDark,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: farmer.cropTypes.map((crop) {
                            return Container(
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
                                  Text(
                                    crop.titleCase,
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
                  if (farmer.cropTypes.isNotEmpty) const SizedBox(height: 12),

                  // ── Agent / LBC info ───────────────────────────────────────
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

                  // ── Action buttons ─────────────────────────────────────────
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
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              label,
              style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
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

  const _SectionCard({required this.title, required this.child, required this.isDark});

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
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
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

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
    this.valueColor,
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
              style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            Flexible(
              child: Text(
                value,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: valueColor),
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
            color: theme.brightness == Brightness.dark ? const Color(0xFF2A3A2A) : const Color(0xFFF0F4F0),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
