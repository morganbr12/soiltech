import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/core/theme/app_colors.dart';
import '../../../../shared/extensions/extensions.dart';
import '../../../../shared/models/app_models.dart';
import '../../../../shared/models/dummy_data.dart';
import '../../../../shared/widgets/offline_banner.dart';
import '../../../../shared/widgets/status_badge.dart';

class LogisticsScreen extends StatefulWidget {
  const LogisticsScreen({super.key});

  @override
  State<LogisticsScreen> createState() => _LogisticsScreenState();
}

class _LogisticsScreenState extends State<LogisticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final allRequests = DummyData.pickupRequests;
    final active = allRequests.where((r) =>
        r.status == LogisticsStatus.inTransit || r.status == LogisticsStatus.assigned).toList();
    final pending = allRequests.where((r) => r.status == LogisticsStatus.pending).toList();
    final completed = allRequests.where((r) => r.status == LogisticsStatus.delivered).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logistics'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          tabs: [
            Tab(text: 'Active (${active.length})'),
            Tab(text: 'Pending (${pending.length})'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _RequestTab(requests: active, emptyIcon: Icons.local_shipping_outlined, emptyTitle: 'No Active Pickups'),
          _RequestTab(requests: pending, emptyIcon: Icons.hourglass_empty_rounded, emptyTitle: 'No Pending Requests'),
          _RequestTab(requests: completed, emptyIcon: Icons.check_circle_outline_rounded, emptyTitle: 'No Completed Deliveries'),
        ],
      ),
    );
  }
}

class _RequestTab extends StatelessWidget {
  final List<PickupRequest> requests;
  final IconData emptyIcon;
  final String emptyTitle;

  const _RequestTab({
    required this.requests,
    required this.emptyIcon,
    required this.emptyTitle,
  });

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return AppEmptyState(
        icon: emptyIcon,
        title: emptyTitle,
        subtitle: 'Pickup requests will appear here.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: requests.length,
      itemBuilder: (_, i) => _PickupCard(request: requests[i], index: i),
    );
  }
}

class _PickupCard extends StatelessWidget {
  final PickupRequest request;
  final int index;

  const _PickupCard({required this.request, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        gradient: AppColors.cardGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.local_shipping_rounded, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request.farmerName,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            '${request.cropType} · ${request.weightKg.toStringAsFixed(0)} kg',
                            style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    StatusBadge.fromLogisticsStatus(request.status),
                  ],
                ),
                const SizedBox(height: 16),

                // Route visualization
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          width: 2,
                          height: 32,
                          color: AppColors.primary.withValues(alpha: 0.3),
                        ),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primary, width: 2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request.pickupLocation,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Pickup',
                            style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            request.deliveryLocation,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Delivery',
                            style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Driver info (if assigned)
          if (request.driverName != null) ...[
            Divider(
              height: 1,
              color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFE8F0E8),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        request.driverName!.split(' ').map((n) => n[0]).take(2).join(),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.driverName!,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        if (request.vehicleNumber != null)
                          Text(
                            request.vehicleNumber!,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (request.status == LogisticsStatus.inTransit)
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.phone_rounded, size: 20, color: AppColors.primary),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primaryContainer.withValues(alpha: 0.3),
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // ETA
          if (request.estimatedPickup != null && request.status != LogisticsStatus.delivered) ...[
            Divider(
              height: 1,
              color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFE8F0E8),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Icon(Icons.access_time_rounded, size: 14, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    request.status == LogisticsStatus.inTransit
                        ? 'ETA: ${request.estimatedPickup!.timeAgo.replaceAll(' ago', '')}'
                        : 'Est. pickup: ${request.estimatedPickup!.displayTime}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    request.requestDate.timeAgo,
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Live tracking button (active only)
          if (request.status == LogisticsStatus.inTransit) ...[
            Divider(
              height: 1,
              color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFE8F0E8),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.map_rounded, size: 16),
                  label: const Text('Track Live'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: 80 * index))
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.05, end: 0);
  }
}
