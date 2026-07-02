import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../app/core/theme/app_colors.dart';
import '../../../../shared/models/dummy_data.dart';
import '../../../../shared/extensions/extensions.dart';
import '../../../../shared/widgets/metric_card.dart';
import '../../../../shared/widgets/offline_banner.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _scrollController = ScrollController();
  bool _isOffline = false;

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stats = DummyData.stats;
    final agent = DummyData.agent;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _refresh,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // App bar
            SliverAppBar(
              expandedHeight: 0,
              floating: true,
              snap: true,
              pinned: false,
              backgroundColor: theme.scaffoldBackgroundColor,
              elevation: 0,
              title: Row(
                children: [
                  Image.asset(
                    'assets/icons/logo.png',
                    width: 28,
                    height: 28,
                    errorBuilder: (_, __, ___) => Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.agriculture_rounded, color: Colors.white, size: 16),
                    ),
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
                  // Offline banner
                  OfflineBanner(isOffline: _isOffline),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero card
                        HeroMetricCard(
                          greeting: _greeting,
                          agentName: agent.name.split(' ').first,
                          subtitle: '${agent.agentCode} · ${DateFormat('EEEE, d MMM').format(DateTime.now())}',
                          pendingUploads: stats.pendingUploads,
                          offlineRecords: stats.offlineRecords,
                        ),
                        const SizedBox(height: 28),

                        // Today's stats section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Today's Overview",
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
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

                        GridView.count(
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
                              subValue: '+2 from yesterday',
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
                              value: '${stats.todayWeight.formatted} kg',
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
                        ),
                        const SizedBox(height: 28),

                        // Quick Actions
                        Text(
                          'Quick Actions',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 14),
                        _QuickActionsGrid(),
                        const SizedBox(height: 28),

                        // Weekly chart
                        Text(
                          'Weekly Collection (kg)',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 14),
                        _WeeklyChart(isDark: isDark),
                        const SizedBox(height: 28),

                        // Recent activities
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
                        _RecentActivitiesList(isDark: isDark),
                        const SizedBox(height: 28),

                        // Weather strip
                        _WeatherCard(isDark: isDark),
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

class _QuickActionsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final actions = [
      _QuickAction(
        icon: Icons.person_add_rounded,
        label: 'Register\nFarmer',
        color: AppColors.primary,
        onTap: () => context.push('/farmers/register'),
      ),
      _QuickAction(
        icon: Icons.agriculture_rounded,
        label: 'Record\nCollect',
        color: const Color(0xFF52B788),
        onTap: () => context.push('/produce/create'),
      ),
      _QuickAction(
        icon: Icons.terrain_rounded,
        label: 'Register\nFarm',
        color: AppColors.earth,
        onTap: () => context.push('/farmers/farms/register?farmerId='),
      ),
      _QuickAction(
        icon: Icons.local_shipping_rounded,
        label: 'Request\nPickup',
        color: AppColors.info,
        onTap: () => context.go('/logistics'),
      ),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: a.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(a.icon, color: a.color, size: 22),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    a.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                      height: 1.3,
                    ),
                  ),
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

class _WeeklyChart extends StatelessWidget {
  final bool isDark;
  const _WeeklyChart({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final data = DummyData.weeklyChartData;
    final maxKg = data.map((d) => d['kg'] as double).reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFE8F0E8),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: data.map((d) {
              final kg = d['kg'] as double;
              final frac = kg / maxKg;
              final isToday = d['day'] == DateFormat('EEE').format(DateTime.now());
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isToday)
                    Text(
                      '${(kg / 1000).toStringAsFixed(1)}t',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  const SizedBox(height: 4),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    width: 32,
                    height: 100 * frac,
                    decoration: BoxDecoration(
                      gradient: isToday
                          ? AppColors.cardGradient
                          : LinearGradient(
                              colors: [
                                AppColors.primary.withValues(alpha: 0.25),
                                AppColors.primary.withValues(alpha: 0.1),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    d['day'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                      color: isToday
                          ? AppColors.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
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
              _ChartLegendItem(
                label: 'This Week',
                value: DummyData.stats.weeklyWeight.formattedWithUnit,
                color: AppColors.primary,
              ),
              _ChartLegendItem(
                label: 'Month Total',
                value: '${(DummyData.stats.weeklyWeight * 3.8 / 1000).toStringAsFixed(1)} t',
                color: AppColors.secondary,
              ),
            ],
          ),
        ],
      ),
    ).animate(delay: 400.ms).fadeIn(duration: 500.ms);
  }
}

class _ChartLegendItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _ChartLegendItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
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

class _RecentActivitiesList extends StatelessWidget {
  final bool isDark;
  const _RecentActivitiesList({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activities = DummyData.recentActivities;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFE8F0E8),
          width: 1,
        ),
      ),
      child: Column(
        children: activities.asMap().entries.map((e) {
          final i = e.key;
          final act = e.value;
          final iconMap = {
            'agriculture': Icons.agriculture_rounded,
            'person_add': Icons.person_add_rounded,
            'local_shipping': Icons.local_shipping_rounded,
            'payments': Icons.payments_rounded,
            'terrain': Icons.terrain_rounded,
          };
          return Column(
            children: [
              if (i > 0)
                Divider(
                  height: 1,
                  color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFE8F0E8),
                  indent: 16,
                  endIndent: 16,
                ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    iconMap[act['icon']] ?? Icons.circle,
                    size: 20,
                    color: AppColors.primary,
                  ),
                ),
                title: Text(
                  act['action'] ?? '',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  act['detail'] ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: Text(
                  act['time'] ?? '',
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    ).animate(delay: 500.ms).fadeIn(duration: 500.ms);
  }
}

class _WeatherCard extends StatelessWidget {
  final bool isDark;
  const _WeatherCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1565C0).withValues(alpha: 0.85),
            const Color(0xFF0288D1).withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kumasi, Ashanti',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '28°C',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -1,
                  ),
                ),
                const Text(
                  'Partly Cloudy',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _WeatherPill(icon: Icons.water_drop_outlined, label: '75% Humidity'),
                    const SizedBox(width: 10),
                    _WeatherPill(icon: Icons.air_rounded, label: '12 km/h Wind'),
                  ],
                ),
              ],
            ),
          ),
          const Column(
            children: [
              Icon(Icons.wb_cloudy_rounded, size: 64, color: Colors.white54),
              SizedBox(height: 8),
              Text(
                'Good for\ncollection',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white60,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate(delay: 600.ms).fadeIn(duration: 500.ms);
  }
}

class _WeatherPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _WeatherPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white70),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
