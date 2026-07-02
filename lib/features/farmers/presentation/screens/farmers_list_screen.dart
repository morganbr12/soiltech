import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/core/theme/app_colors.dart';
import '../../../../shared/models/app_models.dart';
import '../../../../shared/models/dummy_data.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/offline_banner.dart';
import '../../../../shared/widgets/shimmer_loader.dart';
import '../../../../shared/widgets/status_badge.dart';

class FarmersListScreen extends StatefulWidget {
  const FarmersListScreen({super.key});

  @override
  State<FarmersListScreen> createState() => _FarmersListScreenState();
}

class _FarmersListScreenState extends State<FarmersListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  FarmerStatus? _statusFilter;
  bool _isLoading = true;

  List<FarmerModel> get _filtered {
    var list = DummyData.farmers;
    if (_searchQuery.isNotEmpty) {
      list = list.where((f) =>
          f.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          f.phone.contains(_searchQuery) ||
          f.community.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    if (_statusFilter != null) {
      list = list.where((f) => f.status == _statusFilter).toList();
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
          // Search + filters
          Container(
            color: theme.scaffoldBackgroundColor,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Column(
              children: [
                AppSearchField(
                  hint: 'Search by name, phone, or community...',
                  controller: _searchController,
                  onChanged: (q) => setState(() => _searchQuery = q),
                  onClear: () => setState(() => _searchQuery = ''),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        label: 'All',
                        isSelected: _statusFilter == null,
                        onTap: () => setState(() => _statusFilter = null),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Active',
                        isSelected: _statusFilter == FarmerStatus.active,
                        onTap: () => setState(
                          () => _statusFilter = _statusFilter == FarmerStatus.active
                              ? null
                              : FarmerStatus.active,
                        ),
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Inactive',
                        isSelected: _statusFilter == FarmerStatus.inactive,
                        onTap: () => setState(
                          () => _statusFilter = _statusFilter == FarmerStatus.inactive
                              ? null
                              : FarmerStatus.inactive,
                        ),
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Count & sort
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text(
                  '${_filtered.length} farmers',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Icon(Icons.sort_rounded, size: 16, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(
                  'Name A–Z',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: _isLoading
                ? const ShimmerList()
                : _filtered.isEmpty
                    ? AppEmptyState(
                        icon: Icons.people_outline_rounded,
                        title: 'No Farmers Found',
                        subtitle: _searchQuery.isNotEmpty
                            ? 'Try a different search term'
                            : 'Register your first farmer',
                        actionLabel: 'Register Farmer',
                        onAction: () => context.push('/farmers/register'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                        itemCount: _filtered.length,
                        itemBuilder: (_, i) {
                          final farmer = _filtered[i];
                          return _FarmerCard(
                            farmer: farmer,
                            isDark: isDark,
                            index: i,
                            onTap: () => context.push('/farmers/profile/${farmer.id}'),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

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

class _FarmerCard extends StatelessWidget {
  final FarmerModel farmer;
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
            width: 1,
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
                      farmer.name.split(' ').map((n) => n[0]).take(2).join(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if (farmer.syncStatus != SyncStatus.synced)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: farmer.syncStatus == SyncStatus.pending
                            ? AppColors.warning
                            : AppColors.error,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? AppColors.cardDark : AppColors.cardLight,
                          width: 1.5,
                        ),
                      ),
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
                          farmer.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      StatusBadge.fromFarmerStatus(farmer.status),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 12,
                          color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          '${farmer.community}, ${farmer.district}',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _InfoPill(
                        icon: Icons.terrain_outlined,
                        label: '${farmer.totalFarms} farms',
                      ),
                      const SizedBox(width: 8),
                      _InfoPill(
                        icon: Icons.grass_rounded,
                        label: farmer.crops.take(2).join(', '),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Arrow
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      )
          .animate(delay: Duration(milliseconds: 50 * index))
          .fadeIn(duration: 300.ms)
          .slideX(begin: 0.05, end: 0),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.primary.withValues(alpha: 0.7)),
        const SizedBox(width: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.primary.withValues(alpha: 0.8),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
