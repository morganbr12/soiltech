// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'produce_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProduceRecord {

 String get id; String get farmerId; String get farmerName; String get farmId; String get cropType; double get weightKg; int get quantityBags; double get moisturePercent; String get qualityGrade; CollectionStatus get status; DateTime get collectionDate; List<String> get photoUrls; String get agentId; String get notes; double get pricePerKg; SyncStatus get syncStatus;
/// Create a copy of ProduceRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProduceRecordCopyWith<ProduceRecord> get copyWith => _$ProduceRecordCopyWithImpl<ProduceRecord>(this as ProduceRecord, _$identity);

  /// Serializes this ProduceRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProduceRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.farmerId, farmerId) || other.farmerId == farmerId)&&(identical(other.farmerName, farmerName) || other.farmerName == farmerName)&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.cropType, cropType) || other.cropType == cropType)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.quantityBags, quantityBags) || other.quantityBags == quantityBags)&&(identical(other.moisturePercent, moisturePercent) || other.moisturePercent == moisturePercent)&&(identical(other.qualityGrade, qualityGrade) || other.qualityGrade == qualityGrade)&&(identical(other.status, status) || other.status == status)&&(identical(other.collectionDate, collectionDate) || other.collectionDate == collectionDate)&&const DeepCollectionEquality().equals(other.photoUrls, photoUrls)&&(identical(other.agentId, agentId) || other.agentId == agentId)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.pricePerKg, pricePerKg) || other.pricePerKg == pricePerKg)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,farmerId,farmerName,farmId,cropType,weightKg,quantityBags,moisturePercent,qualityGrade,status,collectionDate,const DeepCollectionEquality().hash(photoUrls),agentId,notes,pricePerKg,syncStatus);

@override
String toString() {
  return 'ProduceRecord(id: $id, farmerId: $farmerId, farmerName: $farmerName, farmId: $farmId, cropType: $cropType, weightKg: $weightKg, quantityBags: $quantityBags, moisturePercent: $moisturePercent, qualityGrade: $qualityGrade, status: $status, collectionDate: $collectionDate, photoUrls: $photoUrls, agentId: $agentId, notes: $notes, pricePerKg: $pricePerKg, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class $ProduceRecordCopyWith<$Res>  {
  factory $ProduceRecordCopyWith(ProduceRecord value, $Res Function(ProduceRecord) _then) = _$ProduceRecordCopyWithImpl;
@useResult
$Res call({
 String id, String farmerId, String farmerName, String farmId, String cropType, double weightKg, int quantityBags, double moisturePercent, String qualityGrade, CollectionStatus status, DateTime collectionDate, List<String> photoUrls, String agentId, String notes, double pricePerKg, SyncStatus syncStatus
});




}
/// @nodoc
class _$ProduceRecordCopyWithImpl<$Res>
    implements $ProduceRecordCopyWith<$Res> {
  _$ProduceRecordCopyWithImpl(this._self, this._then);

  final ProduceRecord _self;
  final $Res Function(ProduceRecord) _then;

/// Create a copy of ProduceRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? farmerId = null,Object? farmerName = null,Object? farmId = null,Object? cropType = null,Object? weightKg = null,Object? quantityBags = null,Object? moisturePercent = null,Object? qualityGrade = null,Object? status = null,Object? collectionDate = null,Object? photoUrls = null,Object? agentId = null,Object? notes = null,Object? pricePerKg = null,Object? syncStatus = null,}) {
  return _then(ProduceRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,farmerId: null == farmerId ? _self.farmerId : farmerId // ignore: cast_nullable_to_non_nullable
as String,farmerName: null == farmerName ? _self.farmerName : farmerName // ignore: cast_nullable_to_non_nullable
as String,farmId: null == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String,cropType: null == cropType ? _self.cropType : cropType // ignore: cast_nullable_to_non_nullable
as String,weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,quantityBags: null == quantityBags ? _self.quantityBags : quantityBags // ignore: cast_nullable_to_non_nullable
as int,moisturePercent: null == moisturePercent ? _self.moisturePercent : moisturePercent // ignore: cast_nullable_to_non_nullable
as double,qualityGrade: null == qualityGrade ? _self.qualityGrade : qualityGrade // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CollectionStatus,collectionDate: null == collectionDate ? _self.collectionDate : collectionDate // ignore: cast_nullable_to_non_nullable
as DateTime,photoUrls: null == photoUrls ? _self.photoUrls : photoUrls // ignore: cast_nullable_to_non_nullable
as List<String>,agentId: null == agentId ? _self.agentId : agentId // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,pricePerKg: null == pricePerKg ? _self.pricePerKg : pricePerKg // ignore: cast_nullable_to_non_nullable
as double,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [ProduceRecord].
extension ProduceRecordPatterns on ProduceRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProduceRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProduceRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProduceRecord value)  $default,){
final _that = this;
switch (_that) {
case _ProduceRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProduceRecord value)?  $default,){
final _that = this;
switch (_that) {
case _ProduceRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String farmerId,  String farmerName,  String farmId,  String cropType,  double weightKg,  int quantityBags,  double moisturePercent,  String qualityGrade,  CollectionStatus status,  DateTime collectionDate,  List<String> photoUrls,  String agentId,  String notes,  double pricePerKg,  SyncStatus syncStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProduceRecord() when $default != null:
return $default(_that.id,_that.farmerId,_that.farmerName,_that.farmId,_that.cropType,_that.weightKg,_that.quantityBags,_that.moisturePercent,_that.qualityGrade,_that.status,_that.collectionDate,_that.photoUrls,_that.agentId,_that.notes,_that.pricePerKg,_that.syncStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String farmerId,  String farmerName,  String farmId,  String cropType,  double weightKg,  int quantityBags,  double moisturePercent,  String qualityGrade,  CollectionStatus status,  DateTime collectionDate,  List<String> photoUrls,  String agentId,  String notes,  double pricePerKg,  SyncStatus syncStatus)  $default,) {final _that = this;
switch (_that) {
case _ProduceRecord():
return $default(_that.id,_that.farmerId,_that.farmerName,_that.farmId,_that.cropType,_that.weightKg,_that.quantityBags,_that.moisturePercent,_that.qualityGrade,_that.status,_that.collectionDate,_that.photoUrls,_that.agentId,_that.notes,_that.pricePerKg,_that.syncStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String farmerId,  String farmerName,  String farmId,  String cropType,  double weightKg,  int quantityBags,  double moisturePercent,  String qualityGrade,  CollectionStatus status,  DateTime collectionDate,  List<String> photoUrls,  String agentId,  String notes,  double pricePerKg,  SyncStatus syncStatus)?  $default,) {final _that = this;
switch (_that) {
case _ProduceRecord() when $default != null:
return $default(_that.id,_that.farmerId,_that.farmerName,_that.farmId,_that.cropType,_that.weightKg,_that.quantityBags,_that.moisturePercent,_that.qualityGrade,_that.status,_that.collectionDate,_that.photoUrls,_that.agentId,_that.notes,_that.pricePerKg,_that.syncStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProduceRecord extends ProduceRecord {
  const _ProduceRecord({required this.id, required this.farmerId, required this.farmerName, required this.farmId, required this.cropType, required this.weightKg, required this.quantityBags, required this.moisturePercent, required this.qualityGrade, required this.status, required this.collectionDate,  List<String> photoUrls = const [], required this.agentId, this.notes = '', required this.pricePerKg, required this.syncStatus}): _photoUrls = photoUrls,super._();
  factory _ProduceRecord.fromJson(Map<String, dynamic> json) => _$ProduceRecordFromJson(json);

@override final  String id;
@override final  String farmerId;
@override final  String farmerName;
@override final  String farmId;
@override final  String cropType;
@override final  double weightKg;
@override final  int quantityBags;
@override final  double moisturePercent;
@override final  String qualityGrade;
@override final  CollectionStatus status;
@override final  DateTime collectionDate;
 final  List<String> _photoUrls;
@override@JsonKey() List<String> get photoUrls {
  if (_photoUrls is EqualUnmodifiableListView) return _photoUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photoUrls);
}

@override final  String agentId;
@override@JsonKey() final  String notes;
@override final  double pricePerKg;
@override final  SyncStatus syncStatus;

/// Create a copy of ProduceRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProduceRecordCopyWith<_ProduceRecord> get copyWith => __$ProduceRecordCopyWithImpl<_ProduceRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProduceRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProduceRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.farmerId, farmerId) || other.farmerId == farmerId)&&(identical(other.farmerName, farmerName) || other.farmerName == farmerName)&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.cropType, cropType) || other.cropType == cropType)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.quantityBags, quantityBags) || other.quantityBags == quantityBags)&&(identical(other.moisturePercent, moisturePercent) || other.moisturePercent == moisturePercent)&&(identical(other.qualityGrade, qualityGrade) || other.qualityGrade == qualityGrade)&&(identical(other.status, status) || other.status == status)&&(identical(other.collectionDate, collectionDate) || other.collectionDate == collectionDate)&&const DeepCollectionEquality().equals(other._photoUrls, _photoUrls)&&(identical(other.agentId, agentId) || other.agentId == agentId)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.pricePerKg, pricePerKg) || other.pricePerKg == pricePerKg)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,farmerId,farmerName,farmId,cropType,weightKg,quantityBags,moisturePercent,qualityGrade,status,collectionDate,const DeepCollectionEquality().hash(_photoUrls),agentId,notes,pricePerKg,syncStatus);

@override
String toString() {
  return 'ProduceRecord(id: $id, farmerId: $farmerId, farmerName: $farmerName, farmId: $farmId, cropType: $cropType, weightKg: $weightKg, quantityBags: $quantityBags, moisturePercent: $moisturePercent, qualityGrade: $qualityGrade, status: $status, collectionDate: $collectionDate, photoUrls: $photoUrls, agentId: $agentId, notes: $notes, pricePerKg: $pricePerKg, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class _$ProduceRecordCopyWith<$Res> implements $ProduceRecordCopyWith<$Res> {
  factory _$ProduceRecordCopyWith(_ProduceRecord value, $Res Function(_ProduceRecord) _then) = __$ProduceRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String farmerId, String farmerName, String farmId, String cropType, double weightKg, int quantityBags, double moisturePercent, String qualityGrade, CollectionStatus status, DateTime collectionDate, List<String> photoUrls, String agentId, String notes, double pricePerKg, SyncStatus syncStatus
});




}
/// @nodoc
class __$ProduceRecordCopyWithImpl<$Res>
    implements _$ProduceRecordCopyWith<$Res> {
  __$ProduceRecordCopyWithImpl(this._self, this._then);

  final _ProduceRecord _self;
  final $Res Function(_ProduceRecord) _then;

/// Create a copy of ProduceRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? farmerId = null,Object? farmerName = null,Object? farmId = null,Object? cropType = null,Object? weightKg = null,Object? quantityBags = null,Object? moisturePercent = null,Object? qualityGrade = null,Object? status = null,Object? collectionDate = null,Object? photoUrls = null,Object? agentId = null,Object? notes = null,Object? pricePerKg = null,Object? syncStatus = null,}) {
  return _then(_ProduceRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,farmerId: null == farmerId ? _self.farmerId : farmerId // ignore: cast_nullable_to_non_nullable
as String,farmerName: null == farmerName ? _self.farmerName : farmerName // ignore: cast_nullable_to_non_nullable
as String,farmId: null == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String,cropType: null == cropType ? _self.cropType : cropType // ignore: cast_nullable_to_non_nullable
as String,weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,quantityBags: null == quantityBags ? _self.quantityBags : quantityBags // ignore: cast_nullable_to_non_nullable
as int,moisturePercent: null == moisturePercent ? _self.moisturePercent : moisturePercent // ignore: cast_nullable_to_non_nullable
as double,qualityGrade: null == qualityGrade ? _self.qualityGrade : qualityGrade // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CollectionStatus,collectionDate: null == collectionDate ? _self.collectionDate : collectionDate // ignore: cast_nullable_to_non_nullable
as DateTime,photoUrls: null == photoUrls ? _self._photoUrls : photoUrls // ignore: cast_nullable_to_non_nullable
as List<String>,agentId: null == agentId ? _self.agentId : agentId // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,pricePerKg: null == pricePerKg ? _self.pricePerKg : pricePerKg // ignore: cast_nullable_to_non_nullable
as double,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,
  ));
}


}

// dart format on
