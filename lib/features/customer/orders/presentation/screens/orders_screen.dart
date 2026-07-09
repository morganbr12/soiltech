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

class _OrderCard extends ConsumerStatefulWidget {
  final CustomerOrder order;
  const _OrderCard({required this.order});

  @override
  ConsumerState<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends ConsumerState<_OrderCard> {
  bool _expanded = false;

  void _toggleExpand() => setState(() => _expanded = !_expanded);

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
          // ─── Header ─────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '#${o.id.length > 8 ? o.id.substring(0, 8).toUpperCase() : o.id.toUpperCase()}',
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: o.status.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    o.status.label,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: o.status.color),
                  ),
                ),
              ],
            ),
          ),

          // ─── Summary row ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.shopping_bag_outlined, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${o.itemCount ?? o.items.length} item${(o.itemCount ?? o.items.length) != 1 ? 's' : ''}',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        o.deliveryAddress,
                        style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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

          // ─── Expand toggle ──────────────────────────────────────────────────
          InkWell(
            onTap: _toggleExpand,
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

          if (_expanded) _OrderDetailSection(order: o),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0);
  }

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }
}

// ─── Order detail section — fetches items + timeline ─────────────────────────

class _OrderDetailSection extends ConsumerWidget {
  final CustomerOrder order;
  const _OrderDetailSection({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(orderDetailProvider(order.id));
    final theme = Theme.of(context);

    return detailAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)),
      ),
      error: (err, st) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Text('Could not load details',
            style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
      ),
      data: (detail) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Items ─────────────────────────────────────────────────────────
            if (detail.items.isNotEmpty) ...[
              _SectionLabel(label: 'Items Ordered'),
              const SizedBox(height: 8),
              ...detail.items.map((item) => _ItemRow(item: item, theme: theme)),
              const SizedBox(height: 12),
            ],

            // ── Timeline ──────────────────────────────────────────────────────
            _SectionLabel(label: 'Order Timeline'),
            const SizedBox(height: 8),
            if (detail.timeline.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('No updates yet',
                    style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
              )
            else
              ...detail.timeline.asMap().entries.map((e) {
                final i = e.key;
                final step = e.value;
                final isLast = i == detail.timeline.length - 1;
                final isCurrent = isLast;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 20, height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCurrent ? AppColors.primary : AppColors.primaryLight,
                          ),
                          child: const Icon(Icons.check_rounded, size: 11, color: Colors.white),
                        ),
                        if (!isLast) Container(width: 2, height: 36, color: AppColors.primaryLight),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(step.status.toUpperCase(),
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                                    color: isCurrent ? AppColors.primary : theme.colorScheme.onSurface)),
                            if (step.note.isNotEmpty)
                              Text(step.note,
                                  style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant)),
                            Text(_formatTime(step.createdAt),
                                style: const TextStyle(fontSize: 10, color: AppColors.primaryLight, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
          ],
        ),
      ).animate().fadeIn(duration: 250.ms),
    );
  }

  String _formatTime(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final h = d.hour.toString().padLeft(2, '0');
    final m = d.minute.toString().padLeft(2, '0');
    return '${d.day} ${months[d.month - 1]}, $h:$m';
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            letterSpacing: 0.5));
  }
}

class _ItemRow extends StatelessWidget {
  final OrderItem item;
  final ThemeData theme;
  const _ItemRow({required this.item, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.agriculture_rounded, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.productId, // replaced by name once API returns it
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                Text('Qty: ${item.quantity}  ·  GHS ${item.unitPrice.toStringAsFixed(2)} each',
                    style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          Text('GHS ${item.subtotal.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
        ],
      ),
    );
  }
}
