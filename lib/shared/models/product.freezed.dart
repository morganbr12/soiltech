// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Product {

 String get id; String get name; String get description; String get imageUrl; List<String> get galleryImages; double get pricePerUnit; String get unit; int get stockQuantity; String get categoryId; String? get produceListingId; String get farmerName; String get location; String get freshnessLabel; double get averageRating; int get reviewCount; bool get isFeatured; bool get isOnDeal; bool get isAvailable; double? get originalPrice; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other.galleryImages, galleryImages)&&(identical(other.pricePerUnit, pricePerUnit) || other.pricePerUnit == pricePerUnit)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.stockQuantity, stockQuantity) || other.stockQuantity == stockQuantity)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.produceListingId, produceListingId) || other.produceListingId == produceListingId)&&(identical(other.farmerName, farmerName) || other.farmerName == farmerName)&&(identical(other.location, location) || other.location == location)&&(identical(other.freshnessLabel, freshnessLabel) || other.freshnessLabel == freshnessLabel)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&(identical(other.isOnDeal, isOnDeal) || other.isOnDeal == isOnDeal)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,description,imageUrl,const DeepCollectionEquality().hash(galleryImages),pricePerUnit,unit,stockQuantity,categoryId,produceListingId,farmerName,location,freshnessLabel,averageRating,reviewCount,isFeatured,isOnDeal,isAvailable,originalPrice,createdAt,updatedAt]);

@override
String toString() {
  return 'Product(id: $id, name: $name, description: $description, imageUrl: $imageUrl, galleryImages: $galleryImages, pricePerUnit: $pricePerUnit, unit: $unit, stockQuantity: $stockQuantity, categoryId: $categoryId, produceListingId: $produceListingId, farmerName: $farmerName, location: $location, freshnessLabel: $freshnessLabel, averageRating: $averageRating, reviewCount: $reviewCount, isFeatured: $isFeatured, isOnDeal: $isOnDeal, isAvailable: $isAvailable, originalPrice: $originalPrice, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, String imageUrl, List<String> galleryImages, double pricePerUnit, String unit, int stockQuantity, String categoryId, String? produceListingId, String farmerName, String location, String freshnessLabel, double averageRating, int reviewCount, bool isFeatured, bool isOnDeal, bool isAvailable, double? originalPrice, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? imageUrl = null,Object? galleryImages = null,Object? pricePerUnit = null,Object? unit = null,Object? stockQuantity = null,Object? categoryId = null,Object? produceListingId = freezed,Object? farmerName = null,Object? location = null,Object? freshnessLabel = null,Object? averageRating = null,Object? reviewCount = null,Object? isFeatured = null,Object? isOnDeal = null,Object? isAvailable = null,Object? originalPrice = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,galleryImages: null == galleryImages ? _self.galleryImages : galleryImages // ignore: cast_nullable_to_non_nullable
as List<String>,pricePerUnit: null == pricePerUnit ? _self.pricePerUnit : pricePerUnit // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,stockQuantity: null == stockQuantity ? _self.stockQuantity : stockQuantity // ignore: cast_nullable_to_non_nullable
as int,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,produceListingId: freezed == produceListingId ? _self.produceListingId : produceListingId // ignore: cast_nullable_to_non_nullable
as String?,farmerName: null == farmerName ? _self.farmerName : farmerName // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,freshnessLabel: null == freshnessLabel ? _self.freshnessLabel : freshnessLabel // ignore: cast_nullable_to_non_nullable
as String,averageRating: null == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double,reviewCount: null == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,isOnDeal: null == isOnDeal ? _self.isOnDeal : isOnDeal // ignore: cast_nullable_to_non_nullable
as bool,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,originalPrice: freezed == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as double?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Product value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Product value)  $default,){
final _that = this;
switch (_that) {
case _Product():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Product value)?  $default,){
final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String imageUrl,  List<String> galleryImages,  double pricePerUnit,  String unit,  int stockQuantity,  String categoryId,  String? produceListingId,  String farmerName,  String location,  String freshnessLabel,  double averageRating,  int reviewCount,  bool isFeatured,  bool isOnDeal,  bool isAvailable,  double? originalPrice,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.imageUrl,_that.galleryImages,_that.pricePerUnit,_that.unit,_that.stockQuantity,_that.categoryId,_that.produceListingId,_that.farmerName,_that.location,_that.freshnessLabel,_that.averageRating,_that.reviewCount,_that.isFeatured,_that.isOnDeal,_that.isAvailable,_that.originalPrice,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String imageUrl,  List<String> galleryImages,  double pricePerUnit,  String unit,  int stockQuantity,  String categoryId,  String? produceListingId,  String farmerName,  String location,  String freshnessLabel,  double averageRating,  int reviewCount,  bool isFeatured,  bool isOnDeal,  bool isAvailable,  double? originalPrice,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Product():
return $default(_that.id,_that.name,_that.description,_that.imageUrl,_that.galleryImages,_that.pricePerUnit,_that.unit,_that.stockQuantity,_that.categoryId,_that.produceListingId,_that.farmerName,_that.location,_that.freshnessLabel,_that.averageRating,_that.reviewCount,_that.isFeatured,_that.isOnDeal,_that.isAvailable,_that.originalPrice,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  String imageUrl,  List<String> galleryImages,  double pricePerUnit,  String unit,  int stockQuantity,  String categoryId,  String? produceListingId,  String farmerName,  String location,  String freshnessLabel,  double averageRating,  int reviewCount,  bool isFeatured,  bool isOnDeal,  bool isAvailable,  double? originalPrice,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.imageUrl,_that.galleryImages,_that.pricePerUnit,_that.unit,_that.stockQuantity,_that.categoryId,_that.produceListingId,_that.farmerName,_that.location,_that.freshnessLabel,_that.averageRating,_that.reviewCount,_that.isFeatured,_that.isOnDeal,_that.isAvailable,_that.originalPrice,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Product extends Product {
  const _Product({required this.id, required this.name, this.description = '', required this.imageUrl,  List<String> galleryImages = const [], required this.pricePerUnit, required this.unit, required this.stockQuantity, required this.categoryId, this.produceListingId, required this.farmerName, this.location = '', this.freshnessLabel = '', this.averageRating = 0.0, this.reviewCount = 0, this.isFeatured = false, this.isOnDeal = false, this.isAvailable = true, this.originalPrice, this.createdAt, this.updatedAt}): _galleryImages = galleryImages,super._();
  factory _Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  String description;
@override final  String imageUrl;
 final  List<String> _galleryImages;
@override@JsonKey() List<String> get galleryImages {
  if (_galleryImages is EqualUnmodifiableListView) return _galleryImages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_galleryImages);
}

@override final  double pricePerUnit;
@override final  String unit;
@override final  int stockQuantity;
@override final  String categoryId;
@override final  String? produceListingId;
@override final  String farmerName;
@override@JsonKey() final  String location;
@override@JsonKey() final  String freshnessLabel;
@override@JsonKey() final  double averageRating;
@override@JsonKey() final  int reviewCount;
@override@JsonKey() final  bool isFeatured;
@override@JsonKey() final  bool isOnDeal;
@override@JsonKey() final  bool isAvailable;
@override final  double? originalPrice;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other._galleryImages, _galleryImages)&&(identical(other.pricePerUnit, pricePerUnit) || other.pricePerUnit == pricePerUnit)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.stockQuantity, stockQuantity) || other.stockQuantity == stockQuantity)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.produceListingId, produceListingId) || other.produceListingId == produceListingId)&&(identical(other.farmerName, farmerName) || other.farmerName == farmerName)&&(identical(other.location, location) || other.location == location)&&(identical(other.freshnessLabel, freshnessLabel) || other.freshnessLabel == freshnessLabel)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&(identical(other.isOnDeal, isOnDeal) || other.isOnDeal == isOnDeal)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,description,imageUrl,const DeepCollectionEquality().hash(_galleryImages),pricePerUnit,unit,stockQuantity,categoryId,produceListingId,farmerName,location,freshnessLabel,averageRating,reviewCount,isFeatured,isOnDeal,isAvailable,originalPrice,createdAt,updatedAt]);

@override
String toString() {
  return 'Product(id: $id, name: $name, description: $description, imageUrl: $imageUrl, galleryImages: $galleryImages, pricePerUnit: $pricePerUnit, unit: $unit, stockQuantity: $stockQuantity, categoryId: $categoryId, produceListingId: $produceListingId, farmerName: $farmerName, location: $location, freshnessLabel: $freshnessLabel, averageRating: $averageRating, reviewCount: $reviewCount, isFeatured: $isFeatured, isOnDeal: $isOnDeal, isAvailable: $isAvailable, originalPrice: $originalPrice, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, String imageUrl, List<String> galleryImages, double pricePerUnit, String unit, int stockQuantity, String categoryId, String? produceListingId, String farmerName, String location, String freshnessLabel, double averageRating, int reviewCount, bool isFeatured, bool isOnDeal, bool isAvailable, double? originalPrice, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? imageUrl = null,Object? galleryImages = null,Object? pricePerUnit = null,Object? unit = null,Object? stockQuantity = null,Object? categoryId = null,Object? produceListingId = freezed,Object? farmerName = null,Object? location = null,Object? freshnessLabel = null,Object? averageRating = null,Object? reviewCount = null,Object? isFeatured = null,Object? isOnDeal = null,Object? isAvailable = null,Object? originalPrice = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,galleryImages: null == galleryImages ? _self._galleryImages : galleryImages // ignore: cast_nullable_to_non_nullable
as List<String>,pricePerUnit: null == pricePerUnit ? _self.pricePerUnit : pricePerUnit // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,stockQuantity: null == stockQuantity ? _self.stockQuantity : stockQuantity // ignore: cast_nullable_to_non_nullable
as int,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,produceListingId: freezed == produceListingId ? _self.produceListingId : produceListingId // ignore: cast_nullable_to_non_nullable
as String?,farmerName: null == farmerName ? _self.farmerName : farmerName // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,freshnessLabel: null == freshnessLabel ? _self.freshnessLabel : freshnessLabel // ignore: cast_nullable_to_non_nullable
as String,averageRating: null == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double,reviewCount: null == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,isOnDeal: null == isOnDeal ? _self.isOnDeal : isOnDeal // ignore: cast_nullable_to_non_nullable
as bool,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,originalPrice: freezed == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as double?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ProductReview {

 String get id; String get reviewerName; String? get reviewerAvatar; double get rating; String get comment; DateTime get date;
/// Create a copy of ProductReview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductReviewCopyWith<ProductReview> get copyWith => _$ProductReviewCopyWithImpl<ProductReview>(this as ProductReview, _$identity);

  /// Serializes this ProductReview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductReview&&(identical(other.id, id) || other.id == id)&&(identical(other.reviewerName, reviewerName) || other.reviewerName == reviewerName)&&(identical(other.reviewerAvatar, reviewerAvatar) || other.reviewerAvatar == reviewerAvatar)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.date, date) || other.date == date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,reviewerName,reviewerAvatar,rating,comment,date);

@override
String toString() {
  return 'ProductReview(id: $id, reviewerName: $reviewerName, reviewerAvatar: $reviewerAvatar, rating: $rating, comment: $comment, date: $date)';
}


}

/// @nodoc
abstract mixin class $ProductReviewCopyWith<$Res>  {
  factory $ProductReviewCopyWith(ProductReview value, $Res Function(ProductReview) _then) = _$ProductReviewCopyWithImpl;
@useResult
$Res call({
 String id, String reviewerName, String? reviewerAvatar, double rating, String comment, DateTime date
});




}
/// @nodoc
class _$ProductReviewCopyWithImpl<$Res>
    implements $ProductReviewCopyWith<$Res> {
  _$ProductReviewCopyWithImpl(this._self, this._then);

  final ProductReview _self;
  final $Res Function(ProductReview) _then;

/// Create a copy of ProductReview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? reviewerName = null,Object? reviewerAvatar = freezed,Object? rating = null,Object? comment = null,Object? date = null,}) {
  return _then(ProductReview(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,reviewerName: null == reviewerName ? _self.reviewerName : reviewerName // ignore: cast_nullable_to_non_nullable
as String,reviewerAvatar: freezed == reviewerAvatar ? _self.reviewerAvatar : reviewerAvatar // ignore: cast_nullable_to_non_nullable
as String?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductReview].
extension ProductReviewPatterns on ProductReview {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductReview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductReview() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductReview value)  $default,){
final _that = this;
switch (_that) {
case _ProductReview():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductReview value)?  $default,){
final _that = this;
switch (_that) {
case _ProductReview() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String reviewerName,  String? reviewerAvatar,  double rating,  String comment,  DateTime date)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductReview() when $default != null:
return $default(_that.id,_that.reviewerName,_that.reviewerAvatar,_that.rating,_that.comment,_that.date);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String reviewerName,  String? reviewerAvatar,  double rating,  String comment,  DateTime date)  $default,) {final _that = this;
switch (_that) {
case _ProductReview():
return $default(_that.id,_that.reviewerName,_that.reviewerAvatar,_that.rating,_that.comment,_that.date);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String reviewerName,  String? reviewerAvatar,  double rating,  String comment,  DateTime date)?  $default,) {final _that = this;
switch (_that) {
case _ProductReview() when $default != null:
return $default(_that.id,_that.reviewerName,_that.reviewerAvatar,_that.rating,_that.comment,_that.date);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductReview implements ProductReview {
  const _ProductReview({required this.id, required this.reviewerName, this.reviewerAvatar, required this.rating, required this.comment, required this.date});
  factory _ProductReview.fromJson(Map<String, dynamic> json) => _$ProductReviewFromJson(json);

@override final  String id;
@override final  String reviewerName;
@override final  String? reviewerAvatar;
@override final  double rating;
@override final  String comment;
@override final  DateTime date;

/// Create a copy of ProductReview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductReviewCopyWith<_ProductReview> get copyWith => __$ProductReviewCopyWithImpl<_ProductReview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductReviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductReview&&(identical(other.id, id) || other.id == id)&&(identical(other.reviewerName, reviewerName) || other.reviewerName == reviewerName)&&(identical(other.reviewerAvatar, reviewerAvatar) || other.reviewerAvatar == reviewerAvatar)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.date, date) || other.date == date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,reviewerName,reviewerAvatar,rating,comment,date);

@override
String toString() {
  return 'ProductReview(id: $id, reviewerName: $reviewerName, reviewerAvatar: $reviewerAvatar, rating: $rating, comment: $comment, date: $date)';
}


}

/// @nodoc
abstract mixin class _$ProductReviewCopyWith<$Res> implements $ProductReviewCopyWith<$Res> {
  factory _$ProductReviewCopyWith(_ProductReview value, $Res Function(_ProductReview) _then) = __$ProductReviewCopyWithImpl;
@override @useResult
$Res call({
 String id, String reviewerName, String? reviewerAvatar, double rating, String comment, DateTime date
});




}
/// @nodoc
class __$ProductReviewCopyWithImpl<$Res>
    implements _$ProductReviewCopyWith<$Res> {
  __$ProductReviewCopyWithImpl(this._self, this._then);

  final _ProductReview _self;
  final $Res Function(_ProductReview) _then;

/// Create a copy of ProductReview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? reviewerName = null,Object? reviewerAvatar = freezed,Object? rating = null,Object? comment = null,Object? date = null,}) {
  return _then(_ProductReview(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,reviewerName: null == reviewerName ? _self.reviewerName : reviewerName // ignore: cast_nullable_to_non_nullable
as String,reviewerAvatar: freezed == reviewerAvatar ? _self.reviewerAvatar : reviewerAvatar // ignore: cast_nullable_to_non_nullable
as String?,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
