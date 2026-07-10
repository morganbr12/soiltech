import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../app/core/theme/app_colors.dart';
import '../../../../../shared/models/customer_order.dart';
import '../../../../../shared/models/enums.dart';
import '../providers/orders_provider.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<CustomerOrder> _filter(List<CustomerOrder> all, int tabIndex) {
    switch (tabIndex) {
      case 0:
        return all.where((o) => o.status.isActive).toList();
      case 1:
        return all.where((o) => o.status == OrderStatus.pending).toList();
      case 2:
        return all.where((o) => o.status == OrderStatus.delivered).toList();
      case 3:
        return all.where((o) => o.status == OrderStatus.cancelled).toList();
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final ordersAsync = ref.watch(allOrdersProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF5F7F5),
      appBar: AppBar(
        title: const Text('My Orders', style: TextStyle(fontWeight: FontWeight.w700)),
        centerTitle: false,
        backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF5F7F5),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(allOrdersProvider),
            tooltip: 'Refresh',
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
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_off_rounded, size: 52, color: AppColors.primaryLight),
                const SizedBox(height: 16),
                const Text('Could not load orders', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 8),
                Text(e.toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () => ref.invalidate(allOrdersProvider),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (orders) => TabBarView(
          controller: _tabController,
          children: List.generate(4, (tabIndex) {
            final list = _filter(orders, tabIndex);
            return RefreshIndicator(
              onRefresh: () async => ref.invalidate(allOrdersProvider),
              child: list.isEmpty
                  ? CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: _EmptyTab(tabIndex: tabIndex),
                        ),
                      ],
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: list.length,
                      separatorBuilder: (_, idx) => const SizedBox(height: 14),
                      itemBuilder: (context, i) => _OrderCard(order: list[i]),
                    ),
            );
          }),
        ),
      ),
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────

class _EmptyTab extends StatelessWidget {
  final int tabIndex;
  const _EmptyTab({required this.tabIndex});

  static const _labels = ['active', 'pending', 'completed', 'cancelled'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.primaryLight),
          const SizedBox(height: 16),
          Text(
            'No ${_labels[tabIndex]} orders',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            'Your orders will appear here',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

// ─── Order card ───────────────────────────────────────────────────────────────

class _OrderCard extends StatefulWidget {
  final CustomerOrder order;
  const _OrderCard({required this.order});

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final o = widget.order;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        o.orderCode.isNotEmpty ? o.orderCode : '#${o.id.substring(0, 8).toUpperCase()}',
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _formatDate(o.createdAt),
                        style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _StatusChip(status: o.status),
                    const SizedBox(height: 4),
                    _PaymentChip(paymentStatus: o.paymentStatus),
                  ],
                ),
              ],
            ),
          ),

          // ── Produce summary ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.agriculture_rounded, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        o.produce,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${o.quantityKg.toStringAsFixed(1)} kg  ·  GHS ${o.pricePerKg.toStringAsFixed(2)}/kg',
                        style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                Text(
                  'GHS ${o.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.primary),
                ),
              ],
            ),
          ),

          const Divider(height: 1, indent: 16, endIndent: 16),

          // ── Expand toggle ─────────────────────────────────────────────────────
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  Text(
                    'Order Details',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ),

          if (_expanded) _OrderDetails(order: o),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0);
  }

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }
}

// ─── Expanded detail section ──────────────────────────────────────────────────

class _OrderDetails extends StatelessWidget {
  final CustomerOrder order;
  const _OrderDetails({required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final o = order;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DetailRow(
            icon: Icons.location_on_outlined,
            label: 'Region',
            value: o.region.isNotEmpty ? o.region : '—',
            theme: theme,
          ),
          if (o.assignedAgent != null)
            _DetailRow(
              icon: Icons.support_agent_rounded,
              label: 'Assigned Agent',
              value: o.assignedAgent!,
              theme: theme,
            ),
          if (o.assignedDriver != null)
            _DetailRow(
              icon: Icons.local_shipping_outlined,
              label: 'Driver',
              value: o.assignedDriver!,
              theme: theme,
            ),
          if (o.orderDate != null)
            _DetailRow(
              icon: Icons.calendar_today_outlined,
              label: 'Order Date',
              value: _fmt(o.orderDate!),
              theme: theme,
            ),
          if (o.deliveryDate != null)
            _DetailRow(
              icon: Icons.event_available_rounded,
              label: 'Delivery Date',
              value: _fmt(o.deliveryDate!),
              theme: theme,
            ),
        ],
      ),
    ).animate().fadeIn(duration: 200.ms);
  }

  String _fmt(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ThemeData theme;

  const _DetailRow({required this.icon, required this.label, required this.value, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.primaryLight),
          const SizedBox(width: 8),
          Text('$label: ', style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Status chips ─────────────────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  final OrderStatus status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(status.label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: status.color)),
    );
  }
}

class _PaymentChip extends StatelessWidget {
  final String paymentStatus;
  const _PaymentChip({required this.paymentStatus});

  @override
  Widget build(BuildContext context) {
    final isPaid = paymentStatus.toUpperCase() == 'PAID';
    final color = isPaid ? AppColors.success : const Color(0xFFF4A261);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(paymentStatus, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
    );
  }
}
