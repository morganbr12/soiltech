import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/core/theme/app_colors.dart';
import '../../data/logistics_repository.dart';

class LogisticsScreen extends ConsumerStatefulWidget {
  const LogisticsScreen({super.key});

  @override
  ConsumerState<LogisticsScreen> createState() => _LogisticsScreenState();
}

class _LogisticsScreenState extends ConsumerState<LogisticsScreen>
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
    final isDark = theme.brightness == Brightness.dark;
    final requestsAsync = ref.watch(pickupRequestsProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF5F7F5),
      appBar: AppBar(
        title: const Text('Field Operations', style: TextStyle(fontWeight: FontWeight.w700)),
        centerTitle: false,
        backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF5F7F5),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(pickupRequestsProvider),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
          indicatorColor: AppColors.primary,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Pending'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: requestsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => _ErrorState(
          error: e.toString(),
          onRetry: () => ref.invalidate(pickupRequestsProvider),
        ),
        data: (all) {
          final active = all.where((r) => r.isAssigned || r.isInTransit).toList();
          final pending = all.where((r) => r.isPending).toList();
          final completed = all.where((r) => r.isCompleted).toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _RequestList(
                requests: active,
                emptyIcon: Icons.local_shipping_outlined,
                emptyTitle: 'No active pickups',
                emptySubtitle: 'Assigned pickups will appear here.',
                onRefresh: () async => ref.invalidate(pickupRequestsProvider),
              ),
              _RequestList(
                requests: pending,
                emptyIcon: Icons.hourglass_empty_rounded,
                emptyTitle: 'No pending requests',
                emptySubtitle: 'Create a pickup request from a produce record.',
                onRefresh: () async => ref.invalidate(pickupRequestsProvider),
              ),
              _RequestList(
                requests: completed,
                emptyIcon: Icons.check_circle_outline_rounded,
                emptyTitle: 'No completed pickups',
                emptySubtitle: 'Completed pickups will appear here.',
                onRefresh: () async => ref.invalidate(pickupRequestsProvider),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─── List tab ─────────────────────────────────────────────────────────────────

class _RequestList extends StatelessWidget {
  final List<AgentPickupRequest> requests;
  final IconData emptyIcon;
  final String emptyTitle;
  final String emptySubtitle;
  final Future<void> Function() onRefresh;

  const _RequestList({
    required this.requests,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.primary,
      child: requests.isEmpty
          ? CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyState(icon: emptyIcon, title: emptyTitle, subtitle: emptySubtitle),
                ),
              ],
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: requests.length,
              separatorBuilder: (_, idx) => const SizedBox(height: 14),
              itemBuilder: (_, i) => _PickupCard(request: requests[i], index: i),
            ),
    );
  }
}

// ─── Pickup card ──────────────────────────────────────────────────────────────

class _PickupCard extends ConsumerStatefulWidget {
  final AgentPickupRequest request;
  final int index;
  const _PickupCard({required this.request, required this.index});

  @override
  ConsumerState<_PickupCard> createState() => _PickupCardState();
}

class _PickupCardState extends ConsumerState<_PickupCard> {
  bool _confirming = false;

  @override
  Widget build(BuildContext context) {
    final r = widget.request;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.05), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(gradient: AppColors.cardGradient, borderRadius: BorderRadius.circular(13)),
                  child: const Icon(Icons.local_shipping_rounded, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r.farmerName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                      if (r.cropType != null)
                        Text(r.cropType!, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
                _StatusChip(status: r.status),
              ],
            ),
          ),

          // ── Route ────────────────────────────────────────────────────────────
          if (r.pickupLocation != null || r.deliveryLocation != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                      Container(width: 2, height: 28, color: AppColors.primary.withValues(alpha: 0.3)),
                      Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 2))),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.pickupLocation ?? 'Farm location', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        Text('Pickup', style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant)),
                        const SizedBox(height: 12),
                        Text(r.deliveryLocation ?? '—', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        Text('Delivery', style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          if (r.scheduledDate != null) ...[
            const Divider(height: 1, indent: 16, endIndent: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.primaryLight),
                  const SizedBox(width: 6),
                  Text('Scheduled: ${r.scheduledDate}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
                ],
              ),
            ),
          ],

          // ── Driver info ──────────────────────────────────────────────────────
          if (r.hasDriver) ...[
            const Divider(height: 1, indent: 16, endIndent: 16),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.primaryContainer,
                    child: Text(
                      (r.driverName ?? 'D').substring(0, 1).toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary, fontSize: 15),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.driverName!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        if (r.vehicleNumber != null)
                          Text(r.vehicleNumber!, style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  if (r.driverPhone != null)
                    IconButton(
                      icon: const Icon(Icons.phone_rounded, size: 20, color: AppColors.primary),
                      style: IconButton.styleFrom(backgroundColor: AppColors.primaryContainer.withValues(alpha: 0.4), padding: const EdgeInsets.all(8)),
                      onPressed: () {},
                    ),
                ],
              ),
            ),
          ],

          // ── Confirm collected button (driver dispatched, waiting at field) ───
          if (r.isAssigned && r.hasDriver) ...[
            const Divider(height: 1, indent: 16, endIndent: 16),
            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _confirming ? null : () => _confirmCollected(r.id),
                  icon: _confirming
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.check_circle_rounded, size: 18),
                  label: Text(_confirming ? 'Confirming…' : 'Produce Collected'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.success,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    ).animate(delay: Duration(milliseconds: 60 * widget.index)).fadeIn(duration: 300.ms).slideY(begin: 0.04, end: 0);
  }

  Future<void> _confirmCollected(String pickupId) async {
    setState(() => _confirming = true);
    try {
      await ref.read(logisticsRepositoryProvider).updatePickupStatus(pickupId, 'completed');
      ref.invalidate(pickupRequestsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
              SizedBox(width: 10),
              Text('Produce collected confirmed'),
            ]),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 80),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _confirming = false);
    }
  }
}

// ─── Status chip ──────────────────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      'pending' => ('Pending', const Color(0xFFF4A261)),
      'assigned' || 'dispatched' => ('Assigned', AppColors.info),
      'in_transit' || 'inTransit' => ('In Transit', AppColors.primary),
      'completed' || 'delivered' => ('Completed', AppColors.success),
      _ => (status, AppColors.primaryLight),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _EmptyState({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: AppColors.primaryLight.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(subtitle, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant), textAlign: TextAlign.center),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}

// ─── Error state ──────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  const _ErrorState({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 52, color: AppColors.primaryLight),
            const SizedBox(height: 16),
            const Text('Could not load pickup requests', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(error, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant), textAlign: TextAlign.center),
            const SizedBox(height: 20),
            FilledButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh_rounded), label: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
