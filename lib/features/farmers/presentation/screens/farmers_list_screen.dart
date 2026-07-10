import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/core/theme/app_colors.dart';
import '../../../../shared/models/agent_farmer.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/offline_banner.dart';
import '../../../../shared/widgets/shimmer_loader.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../providers/farmers_provider.dart';

class FarmersListScreen extends ConsumerStatefulWidget {
  const FarmersListScreen({super.key});

  @override
  ConsumerState<FarmersListScreen> createState() => _FarmersListScreenState();
}

class _FarmersListScreenState extends ConsumerState<FarmersListScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(farmersFilterProvider.notifier).update((s) => s.copyWith(search: q, page: 1));
    });
  }

  Future<void> _refresh() async {
    ref.invalidate(farmersListProvider);
    try {
      await ref.read(farmersListProvider.future);
    } catch (_) {}
  }

  void _onStatusSelected(String? status) {
    final current = ref.read(farmersFilterProvider).status;
    // Tapping the same chip toggles it off
    final next = current == status ? null : status;
    ref.read(farmersFilterProvider.notifier).update((s) => s.copyWith(
          status: next,
          clearStatus: next == null,
          page: 1,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final filter = ref.watch(farmersFilterProvider);
    final farmersAsync = ref.watch(farmersListProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Farmers'),
        actions: [
          IconButton(
            onPressed: () => context.push('/farmers/register'),
            icon: const Icon(Icons.person_add_rounded),
            tooltip: 'Register Farmer',
          ),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/farmers/register'),
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Register'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // ── Search + filters ────────────────────────────────────────────────
          Container(
            color: theme.scaffoldBackgroundColor,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Column(
              children: [
                AppSearchField(
                  hint: 'Search by name, phone, or code...',
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  onClear: () {
                    _searchController.clear();
                    ref.read(farmersFilterProvider.notifier)
                        .update((s) => s.copyWith(search: '', page: 1));
                  },
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        label: 'All',
                        isSelected: filter.status == null,
                        onTap: () => _onStatusSelected(null),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Approved',
                        isSelected: filter.status == 'APPROVED',
                        onTap: () => _onStatusSelected('APPROVED'),
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Pending',
                        isSelected: filter.status == 'PENDING',
                        onTap: () => _onStatusSelected('PENDING'),
                        color: const Color(0xFFE65100),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Rejected',
                        isSelected: filter.status == 'REJECTED',
                        onTap: () => _onStatusSelected('REJECTED'),
                        color: AppColors.error,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Count row ───────────────────────────────────────────────────────
          farmersAsync.whenData((result) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    Text(
                      '${result.total} farmers',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.sort_rounded, size: 16, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      'A–Z',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )).valueOrNull ??
              const SizedBox.shrink(),

          // ── List ────────────────────────────────────────────────────────────
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              color: AppColors.primary,
              child: farmersAsync.when(
                loading: () => const ShimmerList(),
                error: (e, _) => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.6,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.cloud_off_rounded, size: 52, color: AppColors.primaryLight),
                            const SizedBox(height: 16),
                            const Text('Could not load farmers',
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                            const SizedBox(height: 8),
                            Text(e.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
                            const SizedBox(height: 20),
                            FilledButton.icon(
                              onPressed: _refresh,
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text('Retry'),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Pull down to refresh',
                              style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                data: (result) => result.farmers.isEmpty
                    ? SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.6,
                          child: AppEmptyState(
                            icon: Icons.people_outline_rounded,
                            title: 'No Farmers Found',
                            subtitle: filter.search.isNotEmpty
                                ? 'Try a different search term'
                                : filter.status != null
                                    ? 'No ${filter.status!.toLowerCase()} farmers yet'
                                    : 'Pull down to refresh or register your first farmer',
                            actionLabel: 'Register Farmer',
                            onAction: () => context.push('/farmers/register'),
                          ),
                        ),
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                        itemCount: result.farmers.length,
                        itemBuilder: (_, i) => _FarmerCard(
                          farmer: result.farmers[i],
                          isDark: isDark,
                          index: i,
                          onTap: () => context.push('/farmers/profile/${result.farmers[i].id}'),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Filter chip ──────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({required this.label, required this.isSelected, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: 0.12)
              : Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF1E2E20)
                  : const Color(0xFFF0F6F1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? activeColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? activeColor : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

// ─── Farmer card ──────────────────────────────────────────────────────────────

class _FarmerCard extends StatelessWidget {
  final AgentFarmer farmer;
  final bool isDark;
  final int index;
  final VoidCallback onTap;

  const _FarmerCard({
    required this.farmer,
    required this.isDark,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFE8F0E8),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: AppColors.cardGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      farmer.initials,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if (farmer.kycVerified)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? AppColors.cardDark : AppColors.cardLight,
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(Icons.check, size: 10, color: Colors.white),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          farmer.fullName,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      StatusBadge.fromFarmerStatus(farmer.status),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    farmer.farmerCode,
                    style: TextStyle(fontSize: 11, color: AppColors.primary.withValues(alpha: 0.8), fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 12, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          '${farmer.community.isNotEmpty ? '${farmer.community}, ' : ''}${farmer.district}',
                          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (farmer.cropTypes.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.grass_rounded, size: 12, color: AppColors.primary.withValues(alpha: 0.7)),
                        const SizedBox(width: 3),
                        Text(
                          farmer.cropTypes.take(3).join(', '),
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.primary.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: theme.colorScheme.onSurfaceVariant),
          ],
        ),
      )
          .animate(delay: Duration(milliseconds: 40 * index))
          .fadeIn(duration: 300.ms)
          .slideX(begin: 0.05, end: 0),
    );
  }
}
