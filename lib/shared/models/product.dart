import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
abstract class Product with _$Product {
  const Product._();

  const factory Product({
    required String id,
    required String name,
    @Default('') String description,
    required String imageUrl,
    @Default([]) List<String> galleryImages,
    required double pricePerUnit,
    required String unit,
    required int stockQuantity,
    required String categoryId,
    String? produceListingId,
    String? farmerId,
    String? agentId,
    required String farmerName,
    @Default('') String agentName,
    @Default('') String location,
    @Default('') String freshnessLabel,
    @Default(0.0) double averageRating,
    @Default(0) int reviewCount,
    @Default(false) bool isFeatured,
    @Default(false) bool isOnDeal,
    @Default(true) bool isAvailable,
    double? originalPrice,
    DateTime? createdAt,
    DateTime? updatedAt,
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
