import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../app/core/theme/app_colors.dart';
import '../../../../../shared/models/app_models.dart';
import '../../../../../shared/models/dummy_data.dart';
import '../../../../../shared/widgets/product_card.dart';
import '../../../../../shared/widgets/section_header.dart';

class CustomerHomeScreen extends ConsumerStatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  ConsumerState<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends ConsumerState<CustomerHomeScreen> {
  final _searchController = TextEditingController();
  ProductCategory? _selectedCategory;
  int _bannerPage = 0;
  final _bannerController = PageController();

  @override
  void dispose() {
    _searchController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  List<Product> get _filteredProducts {
    if (_selectedCategory == null) return DummyData.products;
    return DummyData.productsByCategory(_selectedCategory!);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final customer = DummyData.dummyCustomer;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF5F7F5),
      body: CustomScrollView(
        slivers: [
          // ─── App Bar ──────────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 140,
            floating: true,
            snap: true,
            pinned: false,
            elevation: 0,
            backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF5F7F5),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.none,
              background: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      // Top row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_rounded, size: 14, color: AppColors.primary),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Accra, Greater Accra',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: theme.colorScheme.onSurfaceVariant,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.primary),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Good morning, ${customer.fullName.split(' ').first}! 👋',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundImage: CachedNetworkImageProvider(
                                  customer.profileImageUrl ?? 'https://i.pravatar.cc/80',
                                ),
                                backgroundColor: AppColors.primaryContainer,
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: AppColors.success,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: isDark ? AppColors.backgroundDark : Colors.white, width: 2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ).animate().fadeIn(duration: 400.ms),

                      const SizedBox(height: 14),

                      // Search bar
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 46,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.cardDark : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
                                blurRadius: 12,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search_rounded, size: 20, color: AppColors.primaryLight),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Search tomatoes, onions, pepper...',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.tune_rounded, size: 16, color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                      ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.05, end: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Categories ────────────────────────────────────────────────
                SizedBox(
                  height: 44,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _CategoryChip(
                        label: 'All',
                        emoji: '🌾',
                        isSelected: _selectedCategory == null,
                        onTap: () => setState(() => _selectedCategory = null),
                      ),
                      ...ProductCategory.values.map((cat) => _CategoryChip(
                            label: cat.label,
                            emoji: cat.emoji,
                            isSelected: _selectedCategory == cat,
                            onTap: () => setState(() => _selectedCategory = cat),
                          )),
                    ],
                  ),
                ).animate(delay: 150.ms).fadeIn(),

                const SizedBox(height: 20),

                // ─── Promo Banner ─────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 160,
                        child: PageView(
                          controller: _bannerController,
                          onPageChanged: (i) => setState(() => _bannerPage = i),
                          children: const [
                            _PromoBanner(
                              title: 'Farm to Table',
                              subtitle: 'Fresh produce delivered\nwithin 4 hours',
                              buttonLabel: 'Order Now',
                              gradient: LinearGradient(
                                colors: [Color(0xFF1B4332), Color(0xFF40916C)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              emoji: '🥬',
                            ),
                            _PromoBanner(
                              title: 'Today\'s Deals',
                              subtitle: 'Up to 30% off on\nselected produce',
                              buttonLabel: 'See Deals',
                              gradient: LinearGradient(
                                colors: [Color(0xFF6B2F7A), Color(0xFFE91E96)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              emoji: '🎉',
                            ),
                            _PromoBanner(
                              title: 'Seasonal Harvest',
                              subtitle: 'Best prices on\nseasonal vegetables',
                              buttonLabel: 'Explore',
                              gradient: LinearGradient(
                                colors: [Color(0xFFE07B39), Color(0xFFF4A261)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              emoji: '🍅',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: _bannerPage == i ? 20 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _bannerPage == i ? AppColors.primary : AppColors.primaryLight.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        )),
                      ),
                    ],
                  ),
                ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.05, end: 0),

                const SizedBox(height: 28),

                // ─── Today's Deals ────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SectionHeader(
                    title: "Today's Deals 🔥",
                    subtitle: 'Limited time offers',
                    actionLabel: 'See all',
                    onAction: () {},
                  ),
                ).animate(delay: 250.ms).fadeIn(),

                const SizedBox(height: 14),

                SizedBox(
                  height: 280,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: DummyData.dealsProducts.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 14),
                    itemBuilder: (context, i) {
                      final p = DummyData.dealsProducts[i];
                      return ProductCard(
                        product: p,
                        onTap: () => context.push('/product/${p.id}'),
                        onAddToCart: () => _showAddToCartSnackBar(context, p),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 28),

                // ─── Popular Produce ─────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SectionHeader(
                    title: 'Popular Produce',
                    subtitle: 'Most ordered this week',
                    actionLabel: 'See all',
                    onAction: () {},
                  ),
                ).animate(delay: 300.ms).fadeIn(),

                const SizedBox(height: 14),

                SizedBox(
                  height: 280,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _filteredProducts.take(6).length,
                    separatorBuilder: (_, __) => const SizedBox(width: 14),
                    itemBuilder: (context, i) {
                      final p = _filteredProducts[i];
                      return ProductCard(
                        product: p,
                        onTap: () => context.push('/product/${p.id}'),
                        onAddToCart: () => _showAddToCartSnackBar(context, p),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 28),

                // ─── Featured Farmers ─────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SectionHeader(
                    title: 'Featured Farmers',
                    subtitle: 'Top-rated sellers near you',
                    actionLabel: 'See all',
                    onAction: () {},
                  ),
                ).animate(delay: 350.ms).fadeIn(),

                const SizedBox(height: 14),

                SizedBox(
                  height: 170,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: DummyData.farmers.take(5).map((f) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 14),
                        child: FeaturedFarmerCard(
                          name: f.name,
                          location: f.community,
                          avatarUrl: f.avatarUrl,
                          productCount: f.crops.length,
                          rating: 4.5,
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 28),

                // ─── Recommended For You ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SectionHeader(
                    title: 'Recommended For You',
                    subtitle: 'Based on your orders',
                    actionLabel: 'See all',
                    onAction: () {},
                  ),
                ).animate(delay: 400.ms).fadeIn(),

                const SizedBox(height: 14),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: DummyData.featuredProducts.map((p) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ProductCard(
                        product: p,
                        horizontal: true,
                        onTap: () => context.push('/product/${p.id}'),
                        onAddToCart: () => _showAddToCartSnackBar(context, p),
                      ),
                    )).toList(),
                  ),
                ),

                const SizedBox(height: 28),

                // ─── Recently Added ───────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SectionHeader(
                    title: 'Recently Added',
                    subtitle: 'New arrivals from farms',
                    actionLabel: 'See all',
                    onAction: () {},
                  ),
                ).animate(delay: 450.ms).fadeIn(),

                const SizedBox(height: 14),

                SizedBox(
                  height: 280,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: DummyData.products.reversed.take(6).length,
                    separatorBuilder: (_, __) => const SizedBox(width: 14),
                    itemBuilder: (context, i) {
                      final p = DummyData.products.reversed.toList()[i];
                      return ProductCard(
                        product: p,
                        onTap: () => context.push('/product/${p.id}'),
                        onAddToCart: () => _showAddToCartSnackBar(context, p),
                      );
                    },
                  ),
                ),

                // Bottom padding for floating nav
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddToCartSnackBar(BuildContext context, Product p) {
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
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 80),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

class _CategoryChip extends StatelessWidget {
  final String label;
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.emoji,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.cardDark : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : (isDark ? const Color(0xFF2A3A2A) : const Color(0xFFE0EAE0)),
            width: 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? Colors.white : theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonLabel;
  final LinearGradient gradient;
  final String emoji;

  const _PromoBanner({
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.gradient,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned(
            right: -20,
            bottom: -20,
            child: Text(emoji, style: const TextStyle(fontSize: 100)),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    buttonLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
