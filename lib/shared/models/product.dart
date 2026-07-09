import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
abstract class Product with _$Product {
  const Product._();

  const factory Product({
    required String id,
    required String name,
    required String description,
    required String imageUrl,
    @Default([]) List<String> galleryImages,
    required double pricePerUnit,
    required String unit,
    required double availableQuantity,
    required String farmerId,
    required String farmerName,
    required String lbcName,
    required String location,
    required double distanceKm,
    required double rating,
    required int reviewCount,
    required ProductCategory category,
    required DateTime harvestDate,
    required String freshnessLabel,
    @Default(false) bool isFeatured,
    @Default(false) bool isOnDeal,
    double? originalPrice,
    @Default(true) bool isAvailable,
  }) = _Product;

  double get discountPercent {
    if (originalPrice == null || originalPrice! <= pricePerUnit) return 0;
    return ((originalPrice! - pricePerUnit) / originalPrice!) * 100;
  }

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}

@freezed
abstract class ProductReview with _$ProductReview {
  const factory ProductReview({
    required String id,
    required String reviewerName,
    String? reviewerAvatar,
    required double rating,
    required String comment,
    required DateTime date,
  }) = _ProductReview;

  factory ProductReview.fromJson(Map<String, dynamic> json) => _$ProductReviewFromJson(json);
}
