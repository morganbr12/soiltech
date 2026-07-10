import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../app/core/theme/app_colors.dart';
import '../../../../../shared/models/product.dart';
import '../../../../../shared/widgets/app_button.dart';
import '../../../../../shared/widgets/rating_widget.dart';
import '../../../../../shared/widgets/section_header.dart';
import '../../../../../shared/widgets/product_card.dart';
import '../../../../../shared/widgets/shimmer_loader.dart';
import '../../../cart/cart_provider.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import '../../../chats/data/chats_repository.dart';
import '../../../chats/presentation/screens/conversation_screen.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _galleryIndex = 0;
  double _quantity = 1.0;
  bool _isFavourited = false;
  String _orderPaymentType = 'CASH';

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productDetailProvider(widget.productId));

    return productAsync.when(
      loading: () => const _LoadingScaffold(),
      error: (e, _) => _ErrorScaffold(
        onRetry: () => ref.invalidate(productDetailProvider(widget.productId)),
      ),
      data: (p) => _buildBody(context, p),
    );
  }

  Widget _buildBody(BuildContext context, Product p) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final allImages = [p.imageUrl, ...p.galleryImages];
    final total = p.pricePerUnit * _quantity;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF5F7F5),
      body: CustomScrollView(
        slivers: [
          // ── Image gallery app bar ─────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: isDark ? AppColors.cardDark : Colors.white,
            leading: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), shape: BoxShape.circle),
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
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), shape: BoxShape.circle),
                  child: Icon(
                    _isFavourited ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: _isFavourited ? const Color(0xFFE63946) : Colors.grey,
                    size: 20,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => context.push('/customer/cart'),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 8, 12, 8),
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), shape: BoxShape.circle),
                  child: Builder(builder: (ctx) {
                    final count = ref.watch(cartItemCountProvider);
                    return Badge(
                      isLabelVisible: count > 0,
                      label: Text(count > 9 ? '9+' : '$count', style: const TextStyle(fontSize: 9)),
                      backgroundColor: AppColors.primary,
                      child: const Icon(Icons.shopping_cart_outlined, color: Colors.black87, size: 20),
                    );
                  }),
                ),
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
                      placeholder: (_, _) => Container(color: AppColors.primaryContainer),
                      errorWidget: (_, _, _) => Container(
                        color: AppColors.primaryContainer,
                        child: const Center(
                          child: Icon(Icons.agriculture_rounded, size: 80, color: AppColors.primaryLight),
                        ),
                      ),
                    ),
                  ),
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
                  if (p.isOnDeal)
                    Positioned(
                      top: 60,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: const Color(0xFFE63946), borderRadius: BorderRadius.circular(12)),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Main info card ──────────────────────────────────────────
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
                                    p.freshnessLabel.isNotEmpty ? p.freshnessLabel : p.name,
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  p.name,
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.5, height: 1.2),
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
                                  style: const TextStyle(fontSize: 13, color: Colors.grey, decoration: TextDecoration.lineThrough),
                                ),
                              Text(
                                'GHS ${p.pricePerUnit.toStringAsFixed(0)}',
                                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: -0.5),
                              ),
                              Text(
                                'per ${p.unit}',
                                style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      RatingWidget(rating: p.averageRating, reviewCount: p.reviewCount),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          _InfoPill(icon: Icons.inventory_2_outlined, label: '${p.stockQuantity} ${p.unit} left', color: AppColors.info),
                          _InfoPill(icon: Icons.location_on_outlined, label: p.location.split(',').first.trim(), color: AppColors.tertiary),
                          _InfoPill(icon: Icons.eco_outlined, label: p.freshnessLabel, color: AppColors.success),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0),

                // ── Freshness ───────────────────────────────────────────────
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
                        decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.15), shape: BoxShape.circle),
                        child: const Icon(Icons.eco_rounded, color: AppColors.success, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Freshness Guarantee', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.success)),
                            Text(
                              '${p.freshnessLabel}. Direct from farm to you.',
                              style: const TextStyle(fontSize: 12, color: AppColors.success),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate(delay: 50.ms).fadeIn(),

                // ── Description ─────────────────────────────────────────────
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
                      Text(p.description, style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant, height: 1.6)),
                    ],
                  ),
                ).animate(delay: 150.ms).fadeIn(),

                // ── Quantity selector ───────────────────────────────────────
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
                              child: Text(_quantity.toStringAsFixed(1), textAlign: TextAlign.center,
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
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

                // ── Reviews ─────────────────────────────────────────────────
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
                      RatingBar(rating: p.averageRating, reviewCount: p.reviewCount),
                      const Divider(height: 24),
                      ref.watch(productReviewsProvider(widget.productId)).when(
                        loading: () => Column(
                          children: List.generate(2, (_) =>
                            const Padding(padding: EdgeInsets.only(bottom: 14), child: ShimmerBox(width: double.infinity, height: 60, radius: 12)),
                          ),
                        ),
                        error: (_, _) => const SizedBox.shrink(),
                        data: (reviews) => reviews.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text('No reviews yet.', style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13)),
                              )
                            : Column(
                                children: reviews.take(5).map((rev) => Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: _ReviewTile(review: rev),
                                )).toList(),
                              ),
                      ),
                    ],
                  ),
                ).animate(delay: 250.ms).fadeIn(),

                // ── Related products ────────────────────────────────────────
                ref.watch(popularProductsProvider(null)).whenData((all) {
                  final related = all.where((r) => r.id != p.id).take(4).toList();
                  if (related.isEmpty) return const SizedBox.shrink();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                        child: SectionHeader(title: 'You May Also Like', actionLabel: 'See all', onAction: () {}),
                      ),
                      SizedBox(
                        height: 280,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: related.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 14),
                          itemBuilder: (_, i) => ProductCard(
                            product: related[i],
                            onTap: () => context.pushReplacement('/product/${related[i].id}'),
                          ),
                        ),
                      ),
                    ],
                  );
                }).valueOrNull ?? const SizedBox.shrink(),

                const SizedBox(height: 120),
              ],
            ),
          ),
        ],
      ),

      // ── Bottom action bar ───────────────────────────────────────────────
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08), blurRadius: 20, offset: const Offset(0, -4)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (p.produceListingId != null) ...[
              _ChatWithLbcButton(product: p),
              const SizedBox(height: 10),
            ],
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Add to Cart',
                    variant: AppButtonVariant.outline,
                    onPressed: () => _showAddToCartSnackBar(context, p),
                    icon: Icons.shopping_cart_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    label: 'Buy Now  GHS ${total.toStringAsFixed(0)}',
                    onPressed: () => _showPlaceOrderSheet(context, p),
                    icon: Icons.bolt_rounded,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPlaceOrderSheet(BuildContext context, Product p) {
    final addressCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? AppColors.cardDark : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: StatefulBuilder(
            builder: (ctx, setModalState) {
              final orderState = ref.watch(placeOrderProvider);
              final isLoading = orderState is AsyncLoading;
              final isDark = Theme.of(context).brightness == Brightness.dark;

              return Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 36, height: 4,
                        decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Place Order', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(
                      '${p.name} · ${_quantity.toStringAsFixed(1)} ${p.unit} · GHS ${(_quantity * p.pricePerUnit).toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: addressCtrl,
                      decoration: InputDecoration(
                        labelText: 'Delivery Address',
                        prefixIcon: const Icon(Icons.location_on_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      maxLines: 2,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter delivery address' : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: notesCtrl,
                      decoration: InputDecoration(
                        labelText: 'Notes (optional)',
                        prefixIcon: const Icon(Icons.notes_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Payment method
                    const Text('Payment method', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        for (final t in [('CASH', Icons.payments_outlined), ('MOMO', Icons.phone_android_rounded)])
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() => _orderPaymentType = t.$1);
                                setModalState(() {});
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                margin: EdgeInsets.only(right: t.$1 == 'CASH' ? 8 : 0),
                                padding: const EdgeInsets.symmetric(vertical: 11),
                                decoration: BoxDecoration(
                                  color: _orderPaymentType == t.$1
                                      ? AppColors.primaryContainer.withValues(alpha: 0.7)
                                      : (isDark ? const Color(0xFF1E2E20) : const Color(0xFFF0F6F1)),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: _orderPaymentType == t.$1 ? AppColors.primary : Colors.transparent,
                                    width: 1.5,
                                  ),
                                ),
                                child: Column(children: [
                                  Icon(t.$2, size: 20, color: _orderPaymentType == t.$1 ? AppColors.primary : Theme.of(context).colorScheme.onSurfaceVariant),
                                  const SizedBox(height: 3),
                                  Text(t.$1, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _orderPaymentType == t.$1 ? AppColors.primary : Theme.of(context).colorScheme.onSurfaceVariant)),
                                ]),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: isLoading
                            ? null
                            : () async {
                                if (!formKey.currentState!.validate()) return;
                                final success = await ref.read(placeOrderProvider.notifier).placeOrder(
                                  produce: p.name,
                                  quantityKg: _quantity,
                                  pricePerKg: p.pricePerUnit,
                                  paymentType: _orderPaymentType,
                                  farmerId: p.farmerId,
                                  agentId: p.agentId,
                                );
                                if (!context.mounted) return;
                                Navigator.of(ctx).pop();
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text('Order placed successfully!'),
                                      backgroundColor: AppColors.success,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                    ),
                                  );
                                } else {
                                  final err = ref.read(placeOrderProvider);
                                  final msg = err is AsyncError ? err.error.toString() : 'Order failed. Try again.';
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(msg),
                                      backgroundColor: AppColors.error,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                    ),
                                  );
                                }
                              },
                        icon: isLoading
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.check_rounded),
                        label: Text(isLoading ? 'Placing Order...' : 'Confirm Order'),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showAddToCartSnackBar(BuildContext context, Product p) {
    ref.read(cartProvider.notifier).add(p);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(child: Text('${p.name} added to cart')),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: () => context.push('/customer/cart'),
        ),
      ),
    );
  }

}

// ─── Loading skeleton ─────────────────────────────────────────────────────────

class _LoadingScaffold extends StatelessWidget {
  const _LoadingScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(color: AppColors.primaryContainer),
            ),
            leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: null),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: List.generate(4, (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: ShimmerBox(width: double.infinity, height: i == 0 ? 140 : 80, radius: 18),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Error scaffold ───────────────────────────────────────────────────────────

class _ErrorScaffold extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorScaffold({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop())),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.inventory_2_outlined, size: 56, color: AppColors.primaryLight),
              const SizedBox(height: 16),
              const Text('Could not load product', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              const SizedBox(height: 24),
              AppButton(label: 'Retry', icon: Icons.refresh_rounded, onPressed: onRetry),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Info pill ────────────────────────────────────────────────────────────────

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoPill({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
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

// ─── Review tile ──────────────────────────────────────────────────────────────

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
          backgroundImage: review.reviewerAvatar != null ? CachedNetworkImageProvider(review.reviewerAvatar!) : null,
          backgroundColor: AppColors.primaryContainer,
          child: review.reviewerAvatar == null
              ? Text(review.reviewerName.isNotEmpty ? review.reviewerName[0] : '?',
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700))
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
              Text(review.comment, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Chat with LBC button ─────────────────────────────────────────────────────

class _ChatWithLbcButton extends ConsumerStatefulWidget {
  final Product product;
  const _ChatWithLbcButton({required this.product});

  @override
  ConsumerState<_ChatWithLbcButton> createState() => _ChatWithLbcButtonState();
}

class _ChatWithLbcButtonState extends ConsumerState<_ChatWithLbcButton> {
  bool _loading = false;

  Future<void> _openChat() async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      final repo = ref.read(chatsRepositoryProvider);
      final thread = await repo.startChat(
        produceListingId: widget.product.produceListingId!,
        message: 'Hi, I am interested in ${widget.product.name}.',
      );
      ref.invalidate(chatListProvider);
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ConversationScreen(thread: thread)),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open chat: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _openChat,
        icon: _loading
            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
            : const Icon(Icons.chat_bubble_outline_rounded, size: 18),
        label: Text(_loading ? 'Opening chat…' : 'Chat with LBC'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ),
    );
  }
}
