import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/core/theme/app_colors.dart';
import '../../../../shared/extensions/extensions.dart';
import '../../../../shared/models/app_models.dart';
import '../../../../shared/models/dummy_data.dart';
import '../../../../shared/widgets/offline_banner.dart';
import '../../../../shared/widgets/status_badge.dart';

class ProduceListScreen extends StatefulWidget {
  const ProduceListScreen({super.key});

  @override
  State<ProduceListScreen> createState() => _ProduceListScreenState();
}

class _ProduceListScreenState extends State<ProduceListScreen>
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

  List<ProduceRecord> _filterByStatus(CollectionStatus? status) {
    final records = DummyData.produceRecords;
    if (status == null) return records;
    return records.where((r) => r.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Draft'),
            Tab(text: 'Submitted'),
            Tab(text: 'Approved'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/produce/create'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Collection'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ProduceTab(records: _filterByStatus(null), isDark: isDark),
          _ProduceTab(records: _filterByStatus(CollectionStatus.draft), isDark: isDark),
          _ProduceTab(records: _filterByStatus(CollectionStatus.submitted), isDark: isDark),
          _ProduceTab(records: _filterByStatus(CollectionStatus.approved), isDark: isDark),
        ],
      ),
    );
  }
}

class _ProduceTab extends StatelessWidget {
  final List<ProduceRecord> records;
  final bool isDark;

  const _ProduceTab({required this.records, required this.isDark});

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return AppEmptyState(
        icon: Icons.agriculture_outlined,
        title: 'No Records',
        subtitle: 'No produce records in this category yet.',
        actionLabel: 'New Collection',
        onAction: () => context.push('/produce/create'),
      );
    }

    // Summary row at top
    final totalWeight = records.fold<double>(0, (s, r) => s + r.weightKg);
    final totalValue = records.fold<double>(0, (s, r) => s + r.totalValue);

    return Column(
      children: [
        // Summary strip
        Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: AppColors.cardGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              _SummaryItem(
                label: 'Records',
                value: '${records.length}',
                icon: Icons.receipt_long_outlined,
              ),
              Container(width: 1, height: 32, color: Colors.white30, margin: const EdgeInsets.symmetric(horizontal: 16)),
              _SummaryItem(
                label: 'Total Weight',
                value: '${(totalWeight / 1000).toStringAsFixed(2)} t',
                icon: Icons.scale_rounded,
              ),
              Container(width: 1, height: 32, color: Colors.white30, margin: const EdgeInsets.symmetric(horizontal: 16)),
              _SummaryItem(
                label: 'Total Value',
                value: 'GHS ${(totalValue / 1000).toStringAsFixed(1)}K',
                icon: Icons.payments_outlined,
              ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            itemCount: records.length,
            itemBuilder: (_, i) => _ProduceCard(
              record: records[i],
              isDark: isDark,
              index: i,
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _SummaryItem({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _ProduceCard extends StatelessWidget {
  final ProduceRecord record;
  final bool isDark;
  final int index;

  const _ProduceCard({required this.record, required this.isDark, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.agriculture_rounded, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.farmerName,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '${record.cropType} · ${record.collectionDate.timeAgo}',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge.fromCollectionStatus(record.status),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              _RecordStat(label: 'Weight', value: record.weightKg.formattedWithUnit),
              _RecordStat(label: 'Bags', value: '${record.quantityBags} bags'),
              _RecordStat(label: 'Moisture', value: record.moisturePercent.percent),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GradeChip(grade: record.qualityGrade),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                record.totalValue.currency,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              StatusBadge.fromSyncStatus(record.syncStatus),
            ],
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: 50 * index))
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.05, end: 0);
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
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
