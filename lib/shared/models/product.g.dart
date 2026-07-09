// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  imageUrl: json['imageUrl'] as String,
  galleryImages:
      (json['galleryImages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  pricePerUnit: (json['pricePerUnit'] as num).toDouble(),
  unit: json['unit'] as String,
  availableQuantity: (json['availableQuantity'] as num).toDouble(),
  farmerId: json['farmerId'] as String,
  farmerName: json['farmerName'] as String,
  lbcName: json['lbcName'] as String,
  location: json['location'] as String,
  distanceKm: (json['distanceKm'] as num).toDouble(),
  rating: (json['rating'] as num).toDouble(),
  reviewCount: (json['reviewCount'] as num).toInt(),
  category: $enumDecode(_$ProductCategoryEnumMap, json['category']),
  harvestDate: DateTime.parse(json['harvestDate'] as String),
  freshnessLabel: json['freshnessLabel'] as String,
  isFeatured: json['isFeatured'] as bool? ?? false,
  isOnDeal: json['isOnDeal'] as bool? ?? false,
  originalPrice: (json['originalPrice'] as num?)?.toDouble(),
  isAvailable: json['isAvailable'] as bool? ?? true,
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'imageUrl': instance.imageUrl,
  'galleryImages': instance.galleryImages,
  'pricePerUnit': instance.pricePerUnit,
  'unit': instance.unit,
  'availableQuantity': instance.availableQuantity,
  'farmerId': instance.farmerId,
  'farmerName': instance.farmerName,
  'lbcName': instance.lbcName,
  'location': instance.location,
  'distanceKm': instance.distanceKm,
  'rating': instance.rating,
  'reviewCount': instance.reviewCount,
  'category': _$ProductCategoryEnumMap[instance.category]!,
  'harvestDate': instance.harvestDate.toIso8601String(),
  'freshnessLabel': instance.freshnessLabel,
  'isFeatured': instance.isFeatured,
  'isOnDeal': instance.isOnDeal,
  'originalPrice': instance.originalPrice,
  'isAvailable': instance.isAvailable,
};

const _$ProductCategoryEnumMap = {
  ProductCategory.tomatoes: 'tomatoes',
  ProductCategory.pepper: 'pepper',
  ProductCategory.onion: 'onion',
  ProductCategory.cabbage: 'cabbage',
  ProductCategory.carrot: 'carrot',
  ProductCategory.lettuce: 'lettuce',
  ProductCategory.gardenEggs: 'gardenEggs',
  ProductCategory.okra: 'okra',
  ProductCategory.other: 'other',
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
