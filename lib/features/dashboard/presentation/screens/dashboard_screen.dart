import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../app/core/theme/app_colors.dart';
import '../../../../shared/models/agent_activity.dart';
import '../../../../shared/models/agent_dashboard.dart';
import '../../../../shared/models/agent_profile.dart';
import '../../../../shared/widgets/metric_card.dart';
import '../../../../shared/widgets/offline_banner.dart';
import '../providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final _scrollController = ScrollController();
  final bool _isOffline = false;

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  Future<void> _refresh() async {
    ref.invalidate(agentDashboardProvider);
    ref.invalidate(agentProfileProvider);
    ref.invalidate(recentActivitiesProvider);
    ref.invalidate(unreadNotificationCountProvider);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dashAsync = ref.watch(agentDashboardProvider);
    final profileAsync = ref.watch(agentProfileProvider);
    final activitiesAsync = ref.watch(recentActivitiesProvider);
    final unreadAsync = ref.watch(unreadNotificationCountProvider);

    final unreadCount = unreadAsync.valueOrNull ?? 0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _refresh,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: 0,
              floating: true,
              snap: true,
              pinned: false,
              backgroundColor: theme.scaffoldBackgroundColor,
              elevation: 0,
              title: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.agriculture_rounded, color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 10),
                  const Text('SoilTech', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () => context.push('/profile/notifications'),
                  icon: Stack(
                    children: [
                      const Icon(Icons.notifications_outlined, size: 24),
                      if (unreadCount > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF4A261),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
              ],
            ),

            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OfflineBanner(isOffline: _isOffline),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Hero card ─────────────────────────────────────────
                        profileAsync.when(
                          loading: () => _HeroSkeleton(isDark: isDark),
                          error: (_, _) => _HeroSkeleton(isDark: isDark),
                          data: (profile) => dashAsync.when(
                            loading: () => _HeroCard(
                              greeting: _greeting,
                              profile: profile,
                              pendingUploads: 0,
                              offlineRecords: 0,
                              isDark: isDark,
                            ),
                            error: (_, _) => _HeroCard(
                              greeting: _greeting,
                              profile: profile,
                              pendingUploads: 0,
                              offlineRecords: 0,
                              isDark: isDark,
                            ),
                            data: (stats) => _HeroCard(
                              greeting: _greeting,
                              profile: profile,
                              pendingUploads: stats.pendingUploads,
                              offlineRecords: stats.offlineRecords,
                              isDark: isDark,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // ── Today's Overview ──────────────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Today's Overview",
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              DateFormat('hh:mm a').format(DateTime.now()),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        dashAsync.when(
                          loading: () => _StatsGridSkeleton(isDark: isDark),
                          error: (e, _) => _ErrorRetry(
                            message: 'Could not load stats',
                            onRetry: () => ref.invalidate(agentDashboardProvider),
                          ),
                          data: (stats) => _StatsGrid(stats: stats),
                        ),
                        const SizedBox(height: 28),

                        // ── Quick Actions ─────────────────────────────────────
                        Text(
                          'Quick Actions',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 14),
                        _QuickActionsGrid(),
                        const SizedBox(height: 28),

                        // ── Weekly Chart ──────────────────────────────────────
                        Text(
                          'Weekly Collection (kg)',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 14),
                        dashAsync.when(
                          loading: () => _ChartSkeleton(isDark: isDark),
                          error: (_, _) => _ChartSkeleton(isDark: isDark),
                          data: (stats) => _WeeklyChart(
                            data: stats.weeklyBreakdown,
                            weeklyWeight: stats.weeklyWeight,
                            monthlyRevenue: stats.monthlyRevenue,
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(height: 28),

                        // ── Recent Activities ─────────────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recent Activities',
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            TextButton(
                              onPressed: () => context.go('/produce'),
                              child: const Text('See all'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        activitiesAsync.when(
                          loading: () => _ActivitiesSkeleton(isDark: isDark),
                          error: (_, _) => _ActivitiesSkeleton(isDark: isDark),
                          data: (activities) => _RecentActivitiesList(
                            activities: activities,
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Hero card ────────────────────────────────────────────────────────────────

class _HeroCard extends StatelessWidget {
  final String greeting;
  final AgentProfile profile;
  final int pendingUploads;
  final int offlineRecords;
  final bool isDark;

  const _HeroCard({
    required this.greeting,
    required this.profile,
    required this.pendingUploads,
    required this.offlineRecords,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return HeroMetricCard(
      greeting: greeting,
      agentName: profile.name.split(' ').first,
      subtitle: '${profile.agentCode} · ${DateFormat('EEEE, d MMM').format(DateTime.now())}',
      pendingUploads: pendingUploads,
      offlineRecords: offlineRecords,
    );
  }
}

class _HeroSkeleton extends StatelessWidget {
  final bool isDark;
  const _HeroSkeleton({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white54, strokeWidth: 2),
      ),
    );
  }
}

// ─── Stats grid ───────────────────────────────────────────────────────────────

class _StatsGrid extends StatelessWidget {
  final AgentDashboard stats;
  const _StatsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.25,
      children: [
        MetricCard(
          label: "Today's Collections",
          value: '${stats.todayCollections}',
          subValue: 'Today',
          icon: Icons.agriculture_rounded,
          color: AppColors.primary,
          isGradient: true,
        ),
        MetricCard(
          label: "Today's Farmers",
          value: '${stats.todayFarmers}',
          subValue: 'Active visits',
          icon: Icons.people_rounded,
          color: AppColors.secondary,
        ),
        MetricCard(
          label: 'Weight Collected',
          value: '${stats.todayWeight.toStringAsFixed(0)} kg',
          subValue: 'Today',
          icon: Icons.scale_rounded,
          color: AppColors.earth,
        ),
        MetricCard(
          label: 'Active Pickups',
          value: '${stats.activePickups}',
          subValue: 'In progress',
          icon: Icons.local_shipping_rounded,
          color: AppColors.info,
        ),
      ],
    );
  }
}

class _StatsGridSkeleton extends StatelessWidget {
  final bool isDark;
  const _StatsGridSkeleton({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.25,
      children: List.generate(
        4,
        (_) => Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

// ─── Quick actions ────────────────────────────────────────────────────────────

class _QuickActionsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final actions = [
      _QuickAction(icon: Icons.person_add_rounded, label: 'Register\nFarmer', color: AppColors.primary, onTap: () => context.push('/farmers/register')),
      _QuickAction(icon: Icons.agriculture_rounded, label: 'Record\nCollect', color: const Color(0xFF52B788), onTap: () => context.push('/produce/create')),
      _QuickAction(icon: Icons.terrain_rounded, label: 'Register\nFarm', color: AppColors.earth, onTap: () => context.push('/farmers/farms/register?farmerId=')),
    ];

    return Row(
      children: actions.map((a) {
        return Expanded(
          child: GestureDetector(
            onTap: a.onTap,
            child: Container(
              margin: EdgeInsets.only(right: a == actions.last ? 0 : 10),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFE8F0E8)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(color: a.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                    child: Icon(a.icon, color: a.color, size: 22),
                  ),
                  const SizedBox(height: 8),
                  Text(a.label, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface, height: 1.3)),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.color, required this.onTap});
}

// ─── Weekly chart ─────────────────────────────────────────────────────────────

class _WeeklyChart extends StatelessWidget {
  final List<WeeklyEntry> data;
  final double weeklyWeight;
  final double monthlyRevenue;
  final bool isDark;

  const _WeeklyChart({
    required this.data,
    required this.weeklyWeight,
    required this.monthlyRevenue,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxKg = data.map((e) => e.kg).fold(0.0, (a, b) => a > b ? a : b);
    final safeMax = maxKg == 0 ? 1.0 : maxKg;
    final today = DateFormat('EEE').format(DateTime.now());

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFE8F0E8)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: data.map((entry) {
              final frac = entry.kg / safeMax;
              final isToday = entry.day == today;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isToday)
                    Text(
                      '${(entry.kg / 1000).toStringAsFixed(1)}t',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                  const SizedBox(height: 4),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    width: 32,
                    height: (100 * frac).clamp(4.0, 100.0),
                    decoration: BoxDecoration(
                      gradient: isToday
                          ? AppColors.cardGradient
                          : LinearGradient(
                              colors: [AppColors.primary.withValues(alpha: 0.25), AppColors.primary.withValues(alpha: 0.1)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    entry.day,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                      color: isToday ? AppColors.primary : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Divider(color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFE8F0E8)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ChartLegend(label: 'This Week', value: '${(weeklyWeight / 1000).toStringAsFixed(1)} t', color: AppColors.primary),
              _ChartLegend(label: 'Month Revenue', value: 'GHS ${monthlyRevenue.toStringAsFixed(0)}', color: AppColors.secondary),
            ],
          ),
        ],
      ),
    ).animate(delay: 400.ms).fadeIn(duration: 500.ms);
  }
}

class _ChartLegend extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _ChartLegend({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant)),
            Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          ],
        ),
      ],
    );
  }
}

class _ChartSkeleton extends StatelessWidget {
  final bool isDark;
  const _ChartSkeleton({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

// ─── Recent activities ────────────────────────────────────────────────────────

class _RecentActivitiesList extends StatelessWidget {
  final List<AgentActivity> activities;
  final bool isDark;

  const _RecentActivitiesList({required this.activities, required this.isDark});

  static const _iconMap = {
    'collection': Icons.agriculture_rounded,
    'farmer_registered': Icons.person_add_rounded,
    'pickup': Icons.local_shipping_rounded,
    'payment': Icons.payments_rounded,
    'farm_registered': Icons.terrain_rounded,
  };

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return DateFormat('d MMM').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (activities.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFE8F0E8)),
        ),
        child: Center(
          child: Text('No recent activities', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFE8F0E8)),
      ),
      child: Column(
        children: activities.asMap().entries.map((e) {
          final i = e.key;
          final act = e.value;
          return Column(
            children: [
              if (i > 0) Divider(height: 1, color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFE8F0E8), indent: 16, endIndent: 16),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: AppColors.primaryContainer.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(12)),
                  child: Icon(_iconMap[act.type] ?? Icons.circle, size: 20, color: AppColors.primary),
                ),
                title: Text(act.action, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                subtitle: Text(act.detail, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
                trailing: Text(_timeAgo(act.timestamp), style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500)),
              ),
            ],
          );
        }).toList(),
      ),
    ).animate(delay: 500.ms).fadeIn(duration: 500.ms);
  }
}

class _ActivitiesSkeleton extends StatelessWidget {
  final bool isDark;
  const _ActivitiesSkeleton({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

// ─── Generic error / retry ────────────────────────────────────────────────────

class _ErrorRetry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorRetry({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_off_rounded, color: AppColors.error, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(message, style: const TextStyle(fontSize: 13, color: AppColors.error))),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
