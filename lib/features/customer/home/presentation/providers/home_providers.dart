import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../shared/models/customer_profile_data.dart';
import '../../../../../shared/models/product.dart';
import '../../../../../shared/models/product_category_model.dart';
import '../../../../customer/data/customer_profile_repository.dart';
import '../../../../customer/data/products_repository.dart';

final customerProfileProvider =
    FutureProvider.autoDispose<CustomerProfileData>((ref) {
  return ref.read(customerProfileRepositoryProvider).getProfile();
});

final productCategoriesProvider =
    FutureProvider.autoDispose<List<ProductCategoryModel>>((ref) {
  return ref.read(productsRepositoryProvider).getCategories();
});

final dealProductsProvider =
    FutureProvider.autoDispose<List<Product>>((ref) {
  return ref.read(productsRepositoryProvider).getDeals();
});

final featuredProductsProvider =
    FutureProvider.autoDispose<List<Product>>((ref) {
  return ref.read(productsRepositoryProvider).getFeatured();
});

final recentProductsProvider =
    FutureProvider.autoDispose<List<Product>>((ref) {
  return ref.read(productsRepositoryProvider).getRecent();
});

// null = All categories
final selectedCategoryIdProvider = StateProvider<String?>((ref) => null);

final popularProductsProvider =
    FutureProvider.autoDispose.family<List<Product>, String?>((ref, categoryId) {
  return ref
      .read(productsRepositoryProvider)
      .getProducts(categoryId: categoryId);
});
