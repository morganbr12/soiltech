import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../app/core/theme/app_colors.dart';
import '../../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../../shared/models/dummy_data.dart';
import '../../../../../shared/models/product.dart';
import '../../../../../shared/widgets/product_card.dart';
import '../../../../../shared/widgets/section_header.dart';
import '../../../../../shared/widgets/shimmer_loader.dart';
import '../../../cart/cart_provider.dart';
import '../providers/home_providers.dart';
import '../../../../../features/dashboard/presentation/providers/dashboard_provider.dart';

class CustomerHomeScreen extends ConsumerStatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  ConsumerState<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends ConsumerState<CustomerHomeScreen> {
  final _searchController = TextEditingController();
  int _bannerPage = 0;
  final _bannerController = PageController();
  final _searchFocus = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _bannerController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    final categoryId = ref.read(selectedCategoryIdProvider);
    ref.invalidate(customerProfileProvider);
    ref.invalidate(productCategoriesProvider);
    ref.invalidate(dealProductsProvider);
    ref.invalidate(featuredProductsProvider);
    ref.invalidate(recentProductsProvider);
    ref.invalidate(popularProductsProvider(categoryId));
    await Future.wait([
      ref.read(dealProductsProvider.future).catchError((_) => <Product>[]),
      ref.read(featuredProductsProvider.future).catchError((_) => <Product>[]),
      ref.read(recentProductsProvider.future).catchError((_) => <Product>[]),
      ref.read(popularProductsProvider(categoryId).future).catchError((_) => <Product>[]),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final authState = ref.watch(authProvider);
    final cachedImageUrl = authState.profileImageUrl;

    final profileAsync = ref.watch(customerProfileProvider);
    // Prefer the live profile name (from /customer/me) over the JWT-decoded one
    final firstName = profileAsync.valueOrNull?.fullName.split(' ').first
        ?? authState.fullName?.split(' ').first
        ?? 'there';
    final selectedCategoryId = ref.watch(selectedCategoryIdProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF5F7F5),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _refresh,
        child: CustomScrollView(
        slivers: [
          // ─── App Bar ──────────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).padding.top + kToolbarHeight + 124,
            floating: true,
            snap: true,
            pinned: false,
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF5F7F5),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.none,
              background: Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  MediaQuery.of(context).padding.top + kToolbarHeight + 8,
                  20,
                  12,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                  'Good morning, $firstName! 👋',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Notification bell
                          Builder(builder: (context) {
                            final unreadAsync = ref.watch(unreadNotificationCountProvider);
                            final unread = unreadAsync.valueOrNull ?? 0;
                            return GestureDetector(
                              onTap: () => context.push('/profile/notifications'),
                              child: Container(
                                width: 42,
                                height: 42,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.cardDark : Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
                                      blurRadius: 10, offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    const Center(child: Icon(Icons.notifications_outlined, size: 22, color: AppColors.primary)),
                                    if (unread > 0)
                                      Positioned(
                                        top: 5, right: 5,
                                        child: Container(
                                          width: 16, height: 16,
                                          decoration: const BoxDecoration(color: Color(0xFFE63946), shape: BoxShape.circle),
                                          child: Center(
                                            child: Text(
                                              unread > 9 ? '9+' : '$unread',
                                              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }),
                          // Cart button
                          GestureDetector(
                            onTap: () => context.push('/customer/cart'),
                            child: Builder(builder: (context) {
                              final cartCount = ref.watch(cartItemCountProvider);
                              return Container(
                                width: 42,
                                height: 42,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.cardDark : Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    const Center(
                                      child: Icon(Icons.shopping_basket_outlined, size: 22, color: AppColors.primary),
                                    ),
                                    if (cartCount > 0)
                                      Positioned(
                                        top: 5,
                                        right: 5,
                                        child: Container(
                                          width: 16,
                                          height: 16,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFE63946),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              cartCount > 9 ? '9+' : '$cartCount',
                                              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }),
                          ),
                          profileAsync.when(
                            data: (profile) => Stack(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundImage: profile.profileImageUrl != null
                                      ? CachedNetworkImageProvider(profile.profileImageUrl!)
                                      : null,
                                  backgroundColor: AppColors.primaryContainer,
                                  child: profile.profileImageUrl == null
                                      ? Text(
                                          (profile.fullName.isNotEmpty ? profile.fullName[0] : 'U').toUpperCase(),
                                          style: const TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        )
                                      : null,
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
                                      border: Border.all(
                                        color: isDark ? AppColors.backgroundDark : Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            loading: () => _buildAvatar(cachedImageUrl, firstName, isDark),
                            error: (_, _) => _buildAvatar(cachedImageUrl, firstName, isDark),
                          ),
                        ],
                      ).animate().fadeIn(duration: 400.ms),

                      const SizedBox(height: 14),

                      // Search bar
                      Container(
                        height: 46,
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
                            const SizedBox(width: 14),
                            const Icon(Icons.search_rounded, size: 20, color: AppColors.primaryLight),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                focusNode: _searchFocus,
                                onChanged: (v) => ref.read(searchQueryProvider.notifier).state = v,
                                style: const TextStyle(fontSize: 13),
                                decoration: InputDecoration(
                                  hintText: 'Search tomatoes, onions, pepper...',
                                  hintStyle: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                            if (ref.watch(searchQueryProvider).isNotEmpty)
                              GestureDetector(
                                onTap: () {
                                  _searchController.clear();
                                  ref.read(searchQueryProvider.notifier).state = '';
                                  _searchFocus.unfocus();
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Icon(Icons.close_rounded, size: 18, color: AppColors.primaryLight),
                                ),
                              )
                            else
                              Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.tune_rounded, size: 16, color: AppColors.primary),
                              ),
                          ],
                        ),
                      ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.05, end: 0),
                    ],
                  ),
                ),
              ),
            ),

          // ── Search results (replaces all sections when query is active) ────
          if (searchQuery.isNotEmpty)
            SliverToBoxAdapter(
              child: _SearchResultsSection(query: searchQuery),
            )
          else
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Categories ────────────────────────────────────────────────
                ref.watch(productCategoriesProvider).when(
                  data: (categories) => SizedBox(
                    height: 44,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        _CategoryChip(
                          label: 'All',
                          emoji: '🌾',
                          isSelected: selectedCategoryId == null,
                          onTap: () => ref.read(selectedCategoryIdProvider.notifier).state = null,
                        ),
                        ...categories.map((cat) => _CategoryChip(
                              label: cat.name,
                              emoji: _categoryEmoji(cat.name),
                              isSelected: selectedCategoryId == cat.id,
                              onTap: () => ref.read(selectedCategoryIdProvider.notifier).state = cat.id,
                            )),
                      ],
                    ),
                  ),
                  loading: () => SizedBox(
                    height: 44,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: 5,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (_, __) => const ShimmerBox(width: 80, height: 36, radius: 12),
                    ),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                ).animate(delay: 150.ms).fadeIn(),

                const SizedBox(height: 20),

                // ─── Promo Banner ─────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 172,
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
                              title: "Today's Deals",
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
                        children: List.generate(
                          3,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: _bannerPage == i ? 20 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _bannerPage == i
                                  ? AppColors.primary
                                  : AppColors.primaryLight.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.05, end: 0),

                const SizedBox(height: 28),

                // ─── Fresh Produce ────────────────────────────────────────────
                ref.watch(dealProductsProvider).when(
                  data: (products) => products.isEmpty
                      ? const SizedBox.shrink()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: SectionHeader(
                                title: 'Fresh Produce',
                                subtitle: 'Sourced directly from farms',
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
                                itemCount: products.length,
                                separatorBuilder: (_, _) => const SizedBox(width: 14),
                                itemBuilder: (context, i) {
                                  final p = products[i];
                                  return ProductCard(
                                    product: p,
                                    onTap: () => context.push('/product/${p.id}'),
                                    onAddToCart: () => _showAddToCartSnackBar(context, p),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 28),
                          ],
                        ),
                  loading: () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: ShimmerBox(width: 160, height: 20, radius: 8),
                      ),
                      const SizedBox(height: 14),
                      _HorizontalShimmerList(),
                      const SizedBox(height: 28),
                    ],
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                ),

                // ─── Popular Produce (category-filtered) ─────────────────────
                ref.watch(popularProductsProvider(selectedCategoryId)).when(
                  data: (products) => products.isEmpty
                      ? const SizedBox.shrink()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: SectionHeader(
                                title: selectedCategoryId == null
                                    ? 'All Available Produce'
                                    : 'Filtered Results',
                                subtitle: 'From local LBC agents',
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
                                itemCount: products.take(10).length,
                                separatorBuilder: (_, _) => const SizedBox(width: 14),
                                itemBuilder: (context, i) {
                                  final p = products[i];
                                  return ProductCard(
                                    product: p,
                                    onTap: () => context.push('/product/${p.id}'),
                                    onAddToCart: () => _showAddToCartSnackBar(context, p),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 28),
                          ],
                        ),
                  loading: () => _HorizontalShimmerList(),
                  error: (_, __) => const SizedBox.shrink(),
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

                // ─── Recently Added ───────────────────────────────────────────
                ref.watch(recentProductsProvider).when(
                  data: (products) => products.isEmpty
                      ? const SizedBox.shrink()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: SectionHeader(
                                title: 'Recently Added',
                                subtitle: 'New arrivals from farms',
                                actionLabel: 'See all',
                                onAction: () {},
                              ),
                            ).animate(delay: 400.ms).fadeIn(),
                            const SizedBox(height: 14),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: products.take(5).map((p) => Padding(
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
                          ],
                        ),
                  loading: () => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: List.generate(
                        3,
                        (_) => const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: ShimmerBox(width: double.infinity, height: 90, radius: 16),
                        ),
                      ),
                    ),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String? imageUrl, String firstName, bool isDark) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundImage: imageUrl != null ? CachedNetworkImageProvider(imageUrl) : null,
          backgroundColor: AppColors.primaryContainer,
          child: imageUrl == null
              ? Text(
                  firstName.isNotEmpty ? firstName[0].toUpperCase() : 'U',
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 16),
                )
              : null,
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
    );
  }

  String _categoryEmoji(String name) {
    final n = name.toLowerCase();
    if (n.contains('maize') || n.contains('corn')) return '🌽';
    if (n.contains('cassava')) return '🍠';
    if (n.contains('yam')) return '🍠';
    if (n.contains('rice')) return '🍚';
    if (n.contains('plantain') || n.contains('banana')) return '🍌';
    if (n.contains('tomato')) return '🍅';
    if (n.contains('pepper')) return '🌶️';
    if (n.contains('onion')) return '🧅';
    if (n.contains('cabbage')) return '🥬';
    if (n.contains('carrot')) return '🥕';
    if (n.contains('lettuce')) return '🥗';
    if (n.contains('garden egg') || n.contains('eggplant')) return '🍆';
    if (n.contains('okra')) return '🌿';
    if (n.contains('cocoa')) return '🍫';
    if (n.contains('fruit')) return '🍎';
    if (n.contains('vegetable') || n.contains('veggie')) return '🥦';
    return '🌾';
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
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 80),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// ─── Search results ───────────────────────────────────────────────────────────

class _SearchResultsSection extends ConsumerWidget {
  final String query;
  const _SearchResultsSection({required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(searchResultsProvider(query));
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      child: resultsAsync.when(
        loading: () => Column(
          children: List.generate(
            4,
            (_) => const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: ShimmerBox(width: double.infinity, height: 90, radius: 16),
            ),
          ),
        ),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Text('Search failed: $e', style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13)),
          ),
        ),
        data: (products) => products.isEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Column(
                  children: [
                    const Icon(Icons.search_off_rounded, size: 52, color: AppColors.primaryLight),
                    const SizedBox(height: 16),
                    Text('No results for "$query"',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    const SizedBox(height: 6),
                    Text('Try a different keyword',
                        style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${products.length} result${products.length != 1 ? 's' : ''} for "$query"',
                    style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 14),
                  ...products.map((p) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ProductCard(
                      product: p,
                      horizontal: true,
                      onTap: () => GoRouter.of(context).push('/product/${p.id}'),
                      onAddToCart: () {
                        ref.read(cartProvider.notifier).add(p);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${p.name} added to cart'),
                            backgroundColor: AppColors.primary,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            margin: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  )),
                ],
              ),
      ),
    );
  }
}

// ─── Shimmer placeholder for horizontal product lists ──────────────────────

class _HorizontalShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 4,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (_, __) => const ShimmerBox(width: 180, height: 280, radius: 20),
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
            color: isSelected
                ? AppColors.primary
                : (isDark ? const Color(0xFF2A3A2A) : const Color(0xFFE0EAE0)),
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
          Positioned(
            right: -20,
            bottom: -20,
            child: Text(emoji, style: const TextStyle(fontSize: 100)),
          ),
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
