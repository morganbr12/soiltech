import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/core/theme/app_colors.dart';
import '../../../../shared/extensions/extensions.dart';
import '../../../../shared/models/produce_entry.dart';
import '../../../../shared/widgets/shimmer_loader.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../providers/produce_provider.dart';

class ProduceListScreen extends ConsumerStatefulWidget {
  const ProduceListScreen({super.key});

  @override
  ConsumerState<ProduceListScreen> createState() => _ProduceListScreenState();
}

class _ProduceListScreenState extends ConsumerState<ProduceListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const _tabs = [
    (label: 'All', status: null),
    (label: 'Pending', status: ProduceStatus.pending),
    (label: 'Approved', status: ProduceStatus.approved),
    (label: 'Rejected', status: ProduceStatus.rejected),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this)
      ..addListener(() {
        if (!_tabController.indexIsChanging) return;
        ref.read(produceStatusFilterProvider.notifier).state =
            _tabs[_tabController.index].status;
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    ref.invalidate(produceListProvider);
    try { await ref.read(produceListProvider.future); } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final recordsAsync = ref.watch(produceListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produce Collections'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: AppColors.primary,
          unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          tabs: _tabs.map((t) => Tab(text: t.label)).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/produce/create'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Collection'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: recordsAsync.when(
        loading: () => _LoadingList(isDark: isDark),
        error: (e, _) => _ErrorView(onRetry: _refresh),
        data: (records) => TabBarView(
          controller: _tabController,
          children: _tabs.map((t) {
            final filtered = t.status == null
                ? records
                : records.where((r) => r.status == t.status).toList();
            return _ProduceTab(records: filtered, isDark: isDark, onRefresh: _refresh);
          }).toList(),
        ),
      ),
    );
  }
}

// ─── Tab body ─────────────────────────────────────────────────────────────────

class _ProduceTab extends StatelessWidget {
  final List<ProduceEntry> records;
  final bool isDark;
  final Future<void> Function() onRefresh;
  const _ProduceTab({required this.records, required this.isDark, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return RefreshIndicator(
        color: AppColors.primary,
        onRefresh: onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.agriculture_outlined, size: 56, color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4)),
                    const SizedBox(height: 12),
                    const Text('No produce records', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text('Records you collect will appear here.', style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    const SizedBox(height: 20),
                    TextButton.icon(
                      onPressed: () => context.push('/produce/create'),
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('New Collection'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    final totalKg = records.fold<double>(0, (s, r) => s + r.quantityKg);
    final totalValue = records.fold<double>(0, (s, r) => s + r.totalAmount);

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: onRefresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(gradient: AppColors.cardGradient, borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  _SummaryItem(label: 'Records', value: '${records.length}', icon: Icons.receipt_long_outlined),
                  Container(width: 1, height: 32, color: Colors.white30, margin: const EdgeInsets.symmetric(horizontal: 16)),
                  _SummaryItem(label: 'Total (kg)', value: totalKg.formatted, icon: Icons.scale_rounded),
                  Container(width: 1, height: 32, color: Colors.white30, margin: const EdgeInsets.symmetric(horizontal: 16)),
                  _SummaryItem(label: 'Total Value', value: 'GHS ${(totalValue / 1000).toStringAsFixed(1)}K', icon: Icons.payments_outlined),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            sliver: SliverList.builder(
              itemCount: records.length,
              itemBuilder: (_, i) => _ProduceCard(record: records[i], isDark: isDark, index: i),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Produce card ─────────────────────────────────────────────────────────────

class _ProduceCard extends StatelessWidget {
  final ProduceEntry record;
  final bool isDark;
  final int index;
  const _ProduceCard({required this.record, required this.isDark, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => context.push('/produce/detail', extra: record),
      child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFE8F0E8)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: record.photos.isNotEmpty
                    ? Image.network(
                        record.photos.first,
                        width: 52, height: 52, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _CropIcon(),
                      )
                    : _CropIcon(),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(record.cropType, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                    Row(
                      children: [
                        if (record.cropVariety != null) ...[
                          Text(record.cropVariety!, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
                          Text(' · ', style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
                        ],
                        Text(
                          record.collectedAt?.timeAgo ?? record.createdAt.timeAgo,
                          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              StatusBadge.fromProduceStatus(record.status),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Stats row
          Row(
            children: [
              _RecordStat(label: 'Quantity', value: '${record.quantityKg.formatted} kg'),
              _RecordStat(label: 'Price/kg', value: 'GHS ${record.pricePerKg.formatted}'),
              _RecordStat(label: 'Total', value: record.totalAmount.currency),
              if (record.grade != null)
                Expanded(child: Align(alignment: Alignment.centerRight, child: GradeChip(grade: record.grade!))),
            ],
          ),

          if (record.notes != null && record.notes!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(record.notes!, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],

          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (record.photos.isNotEmpty)
                Row(children: [
                  const Icon(Icons.photo_library_outlined, size: 13, color: AppColors.primaryLight),
                  const SizedBox(width: 4),
                  Text('${record.photos.length} photo${record.photos.length > 1 ? 's' : ''}',
                      style: const TextStyle(fontSize: 11, color: AppColors.primaryLight, fontWeight: FontWeight.w500)),
                ])
              else
                const SizedBox.shrink(),
              StatusBadge.fromSyncStatus(record.syncStatus),
            ],
          ),
        ],
      ),
      ).animate(delay: Duration(milliseconds: 50 * index)).fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0),
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _SummaryItem({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: [
        Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.white70)),
      ]),
    );
  }
}

class _RecordStat extends StatelessWidget {
  final String label;
  final String value;
  const _RecordStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _CropIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52, height: 52,
      color: AppColors.primaryContainer.withValues(alpha: 0.4),
      child: const Icon(Icons.agriculture_rounded, color: AppColors.primary, size: 24),
    );
  }
}

class _LoadingList extends StatelessWidget {
  final bool isDark;
  const _LoadingList({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, __) => ShimmerBox(width: double.infinity, height: 110, radius: 20),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.6,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_rounded, size: 48, color: AppColors.primaryLight),
              const SizedBox(height: 12),
              const Text('Could not load records', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
