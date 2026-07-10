// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String? ?? '',
  imageUrl: json['imageUrl'] as String,
  galleryImages:
      (json['galleryImages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  pricePerUnit: (json['pricePerUnit'] as num).toDouble(),
  unit: json['unit'] as String,
  stockQuantity: (json['stockQuantity'] as num).toInt(),
  categoryId: json['categoryId'] as String,
  produceListingId: json['produceListingId'] as String?,
  farmerId: json['farmerId'] as String?,
  agentId: json['agentId'] as String?,
  farmerName: json['farmerName'] as String,
  agentName: json['agentName'] as String? ?? '',
  location: json['location'] as String? ?? '',
  freshnessLabel: json['freshnessLabel'] as String? ?? '',
  averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
  reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
  isFeatured: json['isFeatured'] as bool? ?? false,
  isOnDeal: json['isOnDeal'] as bool? ?? false,
  isAvailable: json['isAvailable'] as bool? ?? true,
  originalPrice: (json['originalPrice'] as num?)?.toDouble(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'imageUrl': instance.imageUrl,
  'galleryImages': instance.galleryImages,
  'pricePerUnit': instance.pricePerUnit,
  'unit': instance.unit,
  'stockQuantity': instance.stockQuantity,
  'categoryId': instance.categoryId,
  'produceListingId': instance.produceListingId,
  'farmerId': instance.farmerId,
  'agentId': instance.agentId,
  'farmerName': instance.farmerName,
  'agentName': instance.agentName,
  'location': instance.location,
  'freshnessLabel': instance.freshnessLabel,
  'averageRating': instance.averageRating,
  'reviewCount': instance.reviewCount,
  'isFeatured': instance.isFeatured,
  'isOnDeal': instance.isOnDeal,
  'isAvailable': instance.isAvailable,
  'originalPrice': instance.originalPrice,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

_ProductReview _$ProductReviewFromJson(Map<String, dynamic> json) =>
    _ProductReview(
      id: json['id'] as String,
      reviewerName: json['reviewerName'] as String,
      reviewerAvatar: json['reviewerAvatar'] as String?,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$ProductReviewToJson(_ProductReview instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reviewerName': instance.reviewerName,
      'reviewerAvatar': instance.reviewerAvatar,
      'rating': instance.rating,
      'comment': instance.comment,
      'date': instance.date.toIso8601String(),
    };
