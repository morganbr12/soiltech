// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'farm_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FarmModel {

 String get id; String get farmerId; String get name; double get latitude; double get longitude; double get sizeAcres; List<String> get cropTypes; String get region; String get district; String get community; DateTime get registeredDate; String? get harvestPeriod; List<String> get photoUrls; SyncStatus get syncStatus;
/// Create a copy of FarmModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FarmModelCopyWith<FarmModel> get copyWith => _$FarmModelCopyWithImpl<FarmModel>(this as FarmModel, _$identity);

  /// Serializes this FarmModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FarmModel&&(identical(other.id, id) || other.id == id)&&(identical(other.farmerId, farmerId) || other.farmerId == farmerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.sizeAcres, sizeAcres) || other.sizeAcres == sizeAcres)&&const DeepCollectionEquality().equals(other.cropTypes, cropTypes)&&(identical(other.region, region) || other.region == region)&&(identical(other.district, district) || other.district == district)&&(identical(other.community, community) || other.community == community)&&(identical(other.registeredDate, registeredDate) || other.registeredDate == registeredDate)&&(identical(other.harvestPeriod, harvestPeriod) || other.harvestPeriod == harvestPeriod)&&const DeepCollectionEquality().equals(other.photoUrls, photoUrls)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,farmerId,name,latitude,longitude,sizeAcres,const DeepCollectionEquality().hash(cropTypes),region,district,community,registeredDate,harvestPeriod,const DeepCollectionEquality().hash(photoUrls),syncStatus);

@override
String toString() {
  return 'FarmModel(id: $id, farmerId: $farmerId, name: $name, latitude: $latitude, longitude: $longitude, sizeAcres: $sizeAcres, cropTypes: $cropTypes, region: $region, district: $district, community: $community, registeredDate: $registeredDate, harvestPeriod: $harvestPeriod, photoUrls: $photoUrls, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class $FarmModelCopyWith<$Res>  {
  factory $FarmModelCopyWith(FarmModel value, $Res Function(FarmModel) _then) = _$FarmModelCopyWithImpl;
@useResult
$Res call({
 String id, String farmerId, String name, double latitude, double longitude, double sizeAcres, List<String> cropTypes, String region, String district, String community, DateTime registeredDate, String? harvestPeriod, List<String> photoUrls, SyncStatus syncStatus
});




}
/// @nodoc
class _$FarmModelCopyWithImpl<$Res>
    implements $FarmModelCopyWith<$Res> {
  _$FarmModelCopyWithImpl(this._self, this._then);

  final FarmModel _self;
  final $Res Function(FarmModel) _then;

/// Create a copy of FarmModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? farmerId = null,Object? name = null,Object? latitude = null,Object? longitude = null,Object? sizeAcres = null,Object? cropTypes = null,Object? region = null,Object? district = null,Object? community = null,Object? registeredDate = null,Object? harvestPeriod = freezed,Object? photoUrls = null,Object? syncStatus = null,}) {
  return _then(FarmModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,farmerId: null == farmerId ? _self.farmerId : farmerId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,sizeAcres: null == sizeAcres ? _self.sizeAcres : sizeAcres // ignore: cast_nullable_to_non_nullable
as double,cropTypes: null == cropTypes ? _self.cropTypes : cropTypes // ignore: cast_nullable_to_non_nullable
as List<String>,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,district: null == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String,community: null == community ? _self.community : community // ignore: cast_nullable_to_non_nullable
as String,registeredDate: null == registeredDate ? _self.registeredDate : registeredDate // ignore: cast_nullable_to_non_nullable
as DateTime,harvestPeriod: freezed == harvestPeriod ? _self.harvestPeriod : harvestPeriod // ignore: cast_nullable_to_non_nullable
as String?,photoUrls: null == photoUrls ? _self.photoUrls : photoUrls // ignore: cast_nullable_to_non_nullable
as List<String>,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [FarmModel].
extension FarmModelPatterns on FarmModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FarmModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FarmModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FarmModel value)  $default,){
final _that = this;
switch (_that) {
case _FarmModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FarmModel value)?  $default,){
final _that = this;
switch (_that) {
case _FarmModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String farmerId,  String name,  double latitude,  double longitude,  double sizeAcres,  List<String> cropTypes,  String region,  String district,  String community,  DateTime registeredDate,  String? harvestPeriod,  List<String> photoUrls,  SyncStatus syncStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FarmModel() when $default != null:
return $default(_that.id,_that.farmerId,_that.name,_that.latitude,_that.longitude,_that.sizeAcres,_that.cropTypes,_that.region,_that.district,_that.community,_that.registeredDate,_that.harvestPeriod,_that.photoUrls,_that.syncStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String farmerId,  String name,  double latitude,  double longitude,  double sizeAcres,  List<String> cropTypes,  String region,  String district,  String community,  DateTime registeredDate,  String? harvestPeriod,  List<String> photoUrls,  SyncStatus syncStatus)  $default,) {final _that = this;
switch (_that) {
case _FarmModel():
return $default(_that.id,_that.farmerId,_that.name,_that.latitude,_that.longitude,_that.sizeAcres,_that.cropTypes,_that.region,_that.district,_that.community,_that.registeredDate,_that.harvestPeriod,_that.photoUrls,_that.syncStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String farmerId,  String name,  double latitude,  double longitude,  double sizeAcres,  List<String> cropTypes,  String region,  String district,  String community,  DateTime registeredDate,  String? harvestPeriod,  List<String> photoUrls,  SyncStatus syncStatus)?  $default,) {final _that = this;
switch (_that) {
case _FarmModel() when $default != null:
return $default(_that.id,_that.farmerId,_that.name,_that.latitude,_that.longitude,_that.sizeAcres,_that.cropTypes,_that.region,_that.district,_that.community,_that.registeredDate,_that.harvestPeriod,_that.photoUrls,_that.syncStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FarmModel implements FarmModel {
  const _FarmModel({required this.id, required this.farmerId, required this.name, required this.latitude, required this.longitude, required this.sizeAcres,  List<String> cropTypes = const [], required this.region, required this.district, required this.community, required this.registeredDate, this.harvestPeriod,  List<String> photoUrls = const [], required this.syncStatus}): _cropTypes = cropTypes,_photoUrls = photoUrls;
  factory _FarmModel.fromJson(Map<String, dynamic> json) => _$FarmModelFromJson(json);

@override final  String id;
@override final  String farmerId;
@override final  String name;
@override final  double latitude;
@override final  double longitude;
@override final  double sizeAcres;
 final  List<String> _cropTypes;
@override@JsonKey() List<String> get cropTypes {
  if (_cropTypes is EqualUnmodifiableListView) return _cropTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cropTypes);
}

@override final  String region;
@override final  String district;
@override final  String community;
@override final  DateTime registeredDate;
@override final  String? harvestPeriod;
 final  List<String> _photoUrls;
@override@JsonKey() List<String> get photoUrls {
  if (_photoUrls is EqualUnmodifiableListView) return _photoUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photoUrls);
}

@override final  SyncStatus syncStatus;

/// Create a copy of FarmModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FarmModelCopyWith<_FarmModel> get copyWith => __$FarmModelCopyWithImpl<_FarmModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FarmModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FarmModel&&(identical(other.id, id) || other.id == id)&&(identical(other.farmerId, farmerId) || other.farmerId == farmerId)&&(identical(other.name, name) || other.name == name)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.sizeAcres, sizeAcres) || other.sizeAcres == sizeAcres)&&const DeepCollectionEquality().equals(other._cropTypes, _cropTypes)&&(identical(other.region, region) || other.region == region)&&(identical(other.district, district) || other.district == district)&&(identical(other.community, community) || other.community == community)&&(identical(other.registeredDate, registeredDate) || other.registeredDate == registeredDate)&&(identical(other.harvestPeriod, harvestPeriod) || other.harvestPeriod == harvestPeriod)&&const DeepCollectionEquality().equals(other._photoUrls, _photoUrls)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,farmerId,name,latitude,longitude,sizeAcres,const DeepCollectionEquality().hash(_cropTypes),region,district,community,registeredDate,harvestPeriod,const DeepCollectionEquality().hash(_photoUrls),syncStatus);

@override
String toString() {
  return 'FarmModel(id: $id, farmerId: $farmerId, name: $name, latitude: $latitude, longitude: $longitude, sizeAcres: $sizeAcres, cropTypes: $cropTypes, region: $region, district: $district, community: $community, registeredDate: $registeredDate, harvestPeriod: $harvestPeriod, photoUrls: $photoUrls, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class _$FarmModelCopyWith<$Res> implements $FarmModelCopyWith<$Res> {
  factory _$FarmModelCopyWith(_FarmModel value, $Res Function(_FarmModel) _then) = __$FarmModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String farmerId, String name, double latitude, double longitude, double sizeAcres, List<String> cropTypes, String region, String district, String community, DateTime registeredDate, String? harvestPeriod, List<String> photoUrls, SyncStatus syncStatus
});




}
/// @nodoc
class __$FarmModelCopyWithImpl<$Res>
    implements _$FarmModelCopyWith<$Res> {
  __$FarmModelCopyWithImpl(this._self, this._then);

  final _FarmModel _self;
  final $Res Function(_FarmModel) _then;

/// Create a copy of FarmModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? farmerId = null,Object? name = null,Object? latitude = null,Object? longitude = null,Object? sizeAcres = null,Object? cropTypes = null,Object? region = null,Object? district = null,Object? community = null,Object? registeredDate = null,Object? harvestPeriod = freezed,Object? photoUrls = null,Object? syncStatus = null,}) {
  return _then(_FarmModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,farmerId: null == farmerId ? _self.farmerId : farmerId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,sizeAcres: null == sizeAcres ? _self.sizeAcres : sizeAcres // ignore: cast_nullable_to_non_nullable
as double,cropTypes: null == cropTypes ? _self._cropTypes : cropTypes // ignore: cast_nullable_to_non_nullable
as List<String>,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,district: null == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String,community: null == community ? _self.community : community // ignore: cast_nullable_to_non_nullable
as String,registeredDate: null == registeredDate ? _self.registeredDate : registeredDate // ignore: cast_nullable_to_non_nullable
as DateTime,harvestPeriod: freezed == harvestPeriod ? _self.harvestPeriod : harvestPeriod // ignore: cast_nullable_to_non_nullable
as String?,photoUrls: null == photoUrls ? _self._photoUrls : photoUrls // ignore: cast_nullable_to_non_nullable
as List<String>,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,
  ));
}


}

// dart format on
