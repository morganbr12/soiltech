import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../../app/core/theme/app_colors.dart';
import '../../../../../shared/models/app_models.dart';
import '../../../../../shared/models/dummy_data.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/rating_widget.dart';
import '../../../../../shared/widgets/section_header.dart';
import '../../../../../shared/widgets/product_card.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Product? _product;
  int _galleryIndex = 0;
  double _quantity = 1.0;
  bool _isFavourited = false;
  bool _addingToCart = false;

  @override
  void initState() {
    super.initState();
    _product = DummyData.products.where((p) => p.id == widget.productId).firstOrNull;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_product == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Product not found')),
      );
    }

    final p = _product!;
    final allImages = [p.imageUrl, ...p.galleryImages];
    final total = p.pricePerUnit * _quantity;
    final related = DummyData.products.where((r) => r.category == p.category && r.id != p.id).take(4).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF5F7F5),
      body: CustomScrollView(
        slivers: [
          // ─── Image Gallery App Bar ────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: isDark ? AppColors.cardDark : Colors.white,
            leading: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () => setState(() => _isFavourited = !_isFavourited),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isFavourited ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: _isFavourited ? const Color(0xFFE63946) : Colors.grey,
                    size: 20,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 8, 12, 8),
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.share_outlined, color: Colors.black87, size: 20),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  PageView.builder(
                    itemCount: allImages.length,
                    onPageChanged: (i) => setState(() => _galleryIndex = i),
                    itemBuilder: (_, i) => CachedNetworkImage(
                      imageUrl: allImages[i],
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: AppColors.primaryContainer),
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.primaryContainer,
                        child: Center(
                          child: Text(p.category.emoji, style: const TextStyle(fontSize: 80)),
                        ),
                      ),
                    ),
                  ),
                  // Page indicator
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_galleryIndex + 1}/${allImages.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  // Deal badge
                  if (p.isOnDeal)
                    Positioned(
                      top: 60,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE63946),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${p.discountPercent.toStringAsFixed(0)}% OFF TODAY',
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.backgroundDark : const Color(0xFFF5F7F5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Main Info Card ─────────────────────────────────────────
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryContainer,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${p.category.emoji} ${p.category.label}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    p.name,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.5,
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (p.originalPrice != null)
                                  Text(
                                    'GHS ${p.originalPrice!.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                Text(
                                  'GHS ${p.pricePerUnit.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                Text(
                                  'per ${p.unit}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        RatingWidget(rating: p.rating, reviewCount: p.reviewCount),

                        const SizedBox(height: 16),

                        // Stats row
                        Row(
                          children: [
                            _InfoPill(
                              icon: Icons.inventory_2_outlined,
                              label: '${p.availableQuantity.toStringAsFixed(0)} ${p.unit} left',
                              color: AppColors.info,
                            ),
                            const SizedBox(width: 8),
                            _InfoPill(
                              icon: Icons.location_on_outlined,
                              label: '${p.distanceKm.toStringAsFixed(1)} km away',
                              color: AppColors.tertiary,
                            ),
                            const SizedBox(width: 8),
                            _InfoPill(
                              icon: Icons.eco_outlined,
                              label: p.freshnessLabel,
                              color: AppColors.success,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0),

                  // ─── Freshness & Harvest ───────────────────────────────────
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.successLight,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.eco_rounded, color: AppColors.success, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Freshness Guarantee',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: AppColors.success,
                                ),
                              ),
                              Text(
                                'Harvested on ${_formatDate(p.harvestDate)}. Direct from farm to you.',
                                style: const TextStyle(fontSize: 12, color: AppColors.success),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate(delay: 50.ms).fadeIn(),

                  // ─── Seller Info ───────────────────────────────────────────
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColors.primaryContainer,
                          child: Text(
                            p.farmerName[0],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.farmerName,
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${p.lbcName} · ${p.location}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            minimumSize: Size.zero,
                          ),
                          child: const Text('Chat', style: TextStyle(fontSize: 12, color: AppColors.primary)),
                        ),
                      ],
                    ),
                  ).animate(delay: 100.ms).fadeIn(),

                  // ─── Description ───────────────────────────────────────────
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('About this Product', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                        const SizedBox(height: 8),
                        Text(
                          p.description,
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ).animate(delay: 150.ms).fadeIn(),

                  // ─── Quantity Selector ─────────────────────────────────────
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Quantity (${_quantity.toStringAsFixed(1)} ${p.unit})', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                              Text(
                                '${_quantity.toStringAsFixed(1)} ${p.unit} × GHS ${p.pricePerUnit} = GHS ${total.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: theme.colorScheme.outlineVariant),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: _quantity > 0.5 ? () => setState(() => _quantity -= 0.5) : null,
                                icon: const Icon(Icons.remove_rounded, size: 18),
                                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                              ),
                              SizedBox(
                                width: 40,
                                child: Text(
                                  _quantity.toStringAsFixed(1),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                                ),
                              ),
                              IconButton(
                                onPressed: () => setState(() => _quantity += 0.5),
                                icon: const Icon(Icons.add_rounded, size: 18, color: AppColors.primary),
                                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate(delay: 200.ms).fadeIn(),

                  // ─── Reviews ───────────────────────────────────────────────
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(
                          title: 'Reviews',
                          actionLabel: 'All ${p.reviewCount}',
                          onAction: () {},
                        ),
                        const SizedBox(height: 14),
                        RatingBar(rating: p.rating, reviewCount: p.reviewCount),
                        const Divider(height: 24),
                        ...DummyData.sampleReviews.map((rev) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _ReviewTile(review: rev),
                        )),
                      ],
                    ),
                  ).animate(delay: 250.ms).fadeIn(),

                  // ─── Related Products ──────────────────────────────────────
                  if (related.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                      child: SectionHeader(
                        title: 'Related Products',
                        actionLabel: 'See all',
                        onAction: () {},
                      ),
                    ),
                    SizedBox(
                      height: 280,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: related.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
                        itemBuilder: (_, i) => ProductCard(
                          product: related[i],
                          onTap: () => context.pushReplacement('/product/${related[i].id}'),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),

      // ─── Bottom Action Bar ──────────────────────────────────────────────────
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: AppButton(
                label: 'Add to Cart',
                variant: AppButtonVariant.outline,
                onPressed: _addingToCart ? null : () => _showAddToCartSnackBar(context, p),
                icon: Icons.shopping_cart_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppButton(
                label: 'Buy Now  GHS ${total.toStringAsFixed(0)}',
                onPressed: () {},
                icon: Icons.bolt_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddToCartSnackBar(BuildContext context, Product p) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${p.name} (${_quantity.toStringAsFixed(1)} ${p.unit}) added to cart'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  String _formatDate(DateTime d) => '${d.day} ${_monthName(d.month)} ${d.year}';

  String _monthName(int m) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[m - 1];
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoPill({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final ProductReview review;
  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundImage: review.reviewerAvatar != null
              ? CachedNetworkImageProvider(review.reviewerAvatar!)
              : null,
          backgroundColor: AppColors.primaryContainer,
          child: review.reviewerAvatar == null
              ? Text(review.reviewerName[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700))
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(review.reviewerName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const Spacer(),
                  RatingWidget(rating: review.rating, compact: true, starSize: 12),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                review.comment,
                style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
