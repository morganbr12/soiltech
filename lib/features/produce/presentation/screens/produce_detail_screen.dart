import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/core/theme/app_colors.dart';
import '../../../../shared/extensions/extensions.dart';
import '../../../../shared/models/enums.dart';
import '../../../../shared/models/produce_entry.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/status_badge.dart';

class ProduceDetailScreen extends StatefulWidget {
  final ProduceEntry record;
  const ProduceDetailScreen({super.key, required this.record});

  @override
  State<ProduceDetailScreen> createState() => _ProduceDetailScreenState();
}

class _ProduceDetailScreenState extends State<ProduceDetailScreen> {
  int _galleryIndex = 0;

  ProduceEntry get r => widget.record;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── App bar ──────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: r.photos.isNotEmpty ? 260 : 0,
            pinned: true,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3), shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
              ),
            ),
            title: r.photos.isEmpty ? Text(r.cropType) : null,
            flexibleSpace: r.photos.isNotEmpty
                ? FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        PageView.builder(
                          itemCount: r.photos.length,
                          onPageChanged: (i) => setState(() => _galleryIndex = i),
                          itemBuilder: (_, i) => Image.network(
                            r.photos[i],
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.primaryContainer,
                              child: const Icon(Icons.image_not_supported_outlined, size: 40, color: AppColors.primaryLight),
                            ),
                          ),
                        ),
                        // Page dots
                        if (r.photos.length > 1)
                          Positioned(
                            bottom: 12,
                            left: 0, right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(r.photos.length, (i) => AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: i == _galleryIndex ? 16 : 6,
                                height: 6,
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                decoration: BoxDecoration(
                                  color: i == _galleryIndex ? Colors.white : Colors.white54,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              )),
                            ),
                          ),
                      ],
                    ),
                  )
                : null,
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Title row ────────────────────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.cropType, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
                            if (r.cropVariety != null)
                              Text(r.cropVariety!, style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurfaceVariant)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      StatusBadge.fromProduceStatus(r.status),
                    ],
                  ).animate().fadeIn(duration: 350.ms),
                  const SizedBox(height: 16),

                  // ── Value card ───────────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.payments_rounded, color: Colors.white, size: 28),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total Value', style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.8))),
                            Text(r.totalAmount.currency, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white)),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('GHS ${r.pricePerKg.formatted}/kg', style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.85), fontWeight: FontWeight.w600)),
                            Text('${r.quantityKg.formatted} kg', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                  ).animate(delay: 60.ms).fadeIn(duration: 350.ms),
                  const SizedBox(height: 16),

                  // ── Stats row ────────────────────────────────────────────
                  Row(
                    children: [
                      _StatCard(label: 'Quantity', value: '${r.quantityKg.formatted} kg', icon: Icons.scale_outlined, isDark: isDark),
                      const SizedBox(width: 10),
                      _StatCard(label: 'Price / kg', value: r.pricePerKg.currency, icon: Icons.attach_money_rounded, isDark: isDark),
                      const SizedBox(width: 10),
                      if (r.grade != null)
                        _StatCard(label: 'Grade', value: r.grade!, icon: Icons.star_outline_rounded, isDark: isDark)
                      else
                        _StatCard(label: 'Sync', value: r.syncStatus.name.titleCase, icon: Icons.sync_rounded, isDark: isDark),
                    ],
                  ).animate(delay: 100.ms).fadeIn(duration: 350.ms),
                  const SizedBox(height: 16),

                  // ── Collection details ───────────────────────────────────
                  _SectionCard(
                    title: 'Collection Details',
                    isDark: isDark,
                    child: Column(
                      children: [
                        _InfoRow(icon: Icons.grass_rounded, label: 'Crop Type', value: r.cropType),
                        if (r.cropVariety != null)
                          _InfoRow(icon: Icons.eco_outlined, label: 'Variety', value: r.cropVariety!),
                        if (r.grade != null)
                          _InfoRow(icon: Icons.star_outline_rounded, label: 'Grade', value: r.grade!),
                        _InfoRow(
                          icon: Icons.calendar_today_outlined,
                          label: 'Collected',
                          value: r.collectedAt?.displayDate ?? 'Not recorded',
                          valueColor: r.collectedAt == null ? theme.colorScheme.onSurfaceVariant : null,
                        ),
                        _InfoRow(icon: Icons.access_time_outlined, label: 'Recorded', value: r.createdAt.displayDate),
                        _InfoRow(
                          icon: Icons.sync_rounded,
                          label: 'Sync Status',
                          value: r.syncStatus.name.titleCase,
                          valueColor: r.syncStatus == SyncStatus.synced ? AppColors.success
                              : r.syncStatus == SyncStatus.failed ? AppColors.error
                              : null,
                          isLast: true,
                        ),
                      ],
                    ),
                  ).animate(delay: 140.ms).fadeIn(duration: 350.ms),
                  const SizedBox(height: 12),

                  // ── Notes ────────────────────────────────────────────────
                  if (r.notes != null && r.notes!.isNotEmpty) ...[
                    _SectionCard(
                      title: 'Notes',
                      isDark: isDark,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.notes_outlined, size: 16, color: AppColors.primaryLight),
                          const SizedBox(width: 10),
                          Expanded(child: Text(r.notes!, style: const TextStyle(fontSize: 13, height: 1.5))),
                        ],
                      ),
                    ).animate(delay: 180.ms).fadeIn(duration: 350.ms),
                    const SizedBox(height: 12),
                  ],

                  // ── Photos ───────────────────────────────────────────────
                  if (r.photos.isNotEmpty) ...[
                    _SectionCard(
                      title: 'Photos (${r.photos.length})',
                      isDark: isDark,
                      child: SizedBox(
                        height: 90,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: r.photos.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 10),
                          itemBuilder: (_, i) => GestureDetector(
                            onTap: () => setState(() => _galleryIndex = i),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                r.photos[i],
                                width: 90, height: 90, fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 90, height: 90, color: AppColors.primaryContainer,
                                  child: const Icon(Icons.image_not_supported_outlined, color: AppColors.primaryLight),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ).animate(delay: 220.ms).fadeIn(duration: 350.ms),
                    const SizedBox(height: 12),
                  ],

                  // ── IDs ──────────────────────────────────────────────────
                  _SectionCard(
                    title: 'Reference',
                    isDark: isDark,
                    child: Column(
                      children: [
                        _InfoRow(icon: Icons.fingerprint_rounded, label: 'Record ID', value: r.id.substring(0, 8).toUpperCase()),
                        _InfoRow(icon: Icons.person_outline_rounded, label: 'Farmer ID', value: r.farmerId.substring(0, 8).toUpperCase(), isLast: r.farmId == null),
                        if (r.farmId != null)
                          _InfoRow(icon: Icons.terrain_outlined, label: 'Farm ID', value: r.farmId!.substring(0, 8).toUpperCase(), isLast: true),
                      ],
                    ),
                  ).animate(delay: 260.ms).fadeIn(duration: 350.ms),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isDark;
  const _StatCard({required this.label, required this.value, required this.icon, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFE8F0E8)),
        ),
        child: Column(children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(label, style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final bool isDark;
  const _SectionCard({required this.title, required this.child, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFE8F0E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          ),
          Divider(height: 1, color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFE8F0E8)),
          Padding(padding: const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;
  final Color? valueColor;
  const _InfoRow({required this.icon, required this.label, required this.value, this.isLast = false, this.valueColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(children: [
      Row(children: [
        Icon(icon, size: 16, color: AppColors.primary.withValues(alpha: 0.7)),
        const SizedBox(width: 10),
        Text(label, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500)),
        const Spacer(),
        Flexible(child: Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: valueColor), textAlign: TextAlign.end, maxLines: 1, overflow: TextOverflow.ellipsis)),
      ]),
      if (!isLast) ...[
        const SizedBox(height: 12),
        Divider(height: 1, color: theme.brightness == Brightness.dark ? const Color(0xFF2A3A2A) : const Color(0xFFF0F4F0)),
        const SizedBox(height: 12),
      ],
    ]);
  }
}
