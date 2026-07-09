// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'farmer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FarmerModel {

 String get id; String get name; String get phone; String get nationalId; String get region; String get district; String get community; String get avatarUrl; FarmerStatus get status; DateTime get registeredDate; int get totalFarms; double get totalAcreage; List<FarmModel> get farms; List<String> get crops; double get totalCollected; SyncStatus get syncStatus;
/// Create a copy of FarmerModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FarmerModelCopyWith<FarmerModel> get copyWith => _$FarmerModelCopyWithImpl<FarmerModel>(this as FarmerModel, _$identity);

  /// Serializes this FarmerModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FarmerModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.nationalId, nationalId) || other.nationalId == nationalId)&&(identical(other.region, region) || other.region == region)&&(identical(other.district, district) || other.district == district)&&(identical(other.community, community) || other.community == community)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.registeredDate, registeredDate) || other.registeredDate == registeredDate)&&(identical(other.totalFarms, totalFarms) || other.totalFarms == totalFarms)&&(identical(other.totalAcreage, totalAcreage) || other.totalAcreage == totalAcreage)&&const DeepCollectionEquality().equals(other.farms, farms)&&const DeepCollectionEquality().equals(other.crops, crops)&&(identical(other.totalCollected, totalCollected) || other.totalCollected == totalCollected)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phone,nationalId,region,district,community,avatarUrl,status,registeredDate,totalFarms,totalAcreage,const DeepCollectionEquality().hash(farms),const DeepCollectionEquality().hash(crops),totalCollected,syncStatus);

@override
String toString() {
  return 'FarmerModel(id: $id, name: $name, phone: $phone, nationalId: $nationalId, region: $region, district: $district, community: $community, avatarUrl: $avatarUrl, status: $status, registeredDate: $registeredDate, totalFarms: $totalFarms, totalAcreage: $totalAcreage, farms: $farms, crops: $crops, totalCollected: $totalCollected, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class $FarmerModelCopyWith<$Res>  {
  factory $FarmerModelCopyWith(FarmerModel value, $Res Function(FarmerModel) _then) = _$FarmerModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String phone, String nationalId, String region, String district, String community, String avatarUrl, FarmerStatus status, DateTime registeredDate, int totalFarms, double totalAcreage, List<FarmModel> farms, List<String> crops, double totalCollected, SyncStatus syncStatus
});




}
/// @nodoc
class _$FarmerModelCopyWithImpl<$Res>
    implements $FarmerModelCopyWith<$Res> {
  _$FarmerModelCopyWithImpl(this._self, this._then);

  final FarmerModel _self;
  final $Res Function(FarmerModel) _then;

/// Create a copy of FarmerModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? phone = null,Object? nationalId = null,Object? region = null,Object? district = null,Object? community = null,Object? avatarUrl = null,Object? status = null,Object? registeredDate = null,Object? totalFarms = null,Object? totalAcreage = null,Object? farms = null,Object? crops = null,Object? totalCollected = null,Object? syncStatus = null,}) {
  return _then(FarmerModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,nationalId: null == nationalId ? _self.nationalId : nationalId // ignore: cast_nullable_to_non_nullable
as String,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,district: null == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String,community: null == community ? _self.community : community // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FarmerStatus,registeredDate: null == registeredDate ? _self.registeredDate : registeredDate // ignore: cast_nullable_to_non_nullable
as DateTime,totalFarms: null == totalFarms ? _self.totalFarms : totalFarms // ignore: cast_nullable_to_non_nullable
as int,totalAcreage: null == totalAcreage ? _self.totalAcreage : totalAcreage // ignore: cast_nullable_to_non_nullable
as double,farms: null == farms ? _self.farms : farms // ignore: cast_nullable_to_non_nullable
as List<FarmModel>,crops: null == crops ? _self.crops : crops // ignore: cast_nullable_to_non_nullable
as List<String>,totalCollected: null == totalCollected ? _self.totalCollected : totalCollected // ignore: cast_nullable_to_non_nullable
as double,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [FarmerModel].
extension FarmerModelPatterns on FarmerModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FarmerModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FarmerModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FarmerModel value)  $default,){
final _that = this;
switch (_that) {
case _FarmerModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FarmerModel value)?  $default,){
final _that = this;
switch (_that) {
case _FarmerModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String phone,  String nationalId,  String region,  String district,  String community,  String avatarUrl,  FarmerStatus status,  DateTime registeredDate,  int totalFarms,  double totalAcreage,  List<FarmModel> farms,  List<String> crops,  double totalCollected,  SyncStatus syncStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FarmerModel() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.nationalId,_that.region,_that.district,_that.community,_that.avatarUrl,_that.status,_that.registeredDate,_that.totalFarms,_that.totalAcreage,_that.farms,_that.crops,_that.totalCollected,_that.syncStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String phone,  String nationalId,  String region,  String district,  String community,  String avatarUrl,  FarmerStatus status,  DateTime registeredDate,  int totalFarms,  double totalAcreage,  List<FarmModel> farms,  List<String> crops,  double totalCollected,  SyncStatus syncStatus)  $default,) {final _that = this;
switch (_that) {
case _FarmerModel():
return $default(_that.id,_that.name,_that.phone,_that.nationalId,_that.region,_that.district,_that.community,_that.avatarUrl,_that.status,_that.registeredDate,_that.totalFarms,_that.totalAcreage,_that.farms,_that.crops,_that.totalCollected,_that.syncStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String phone,  String nationalId,  String region,  String district,  String community,  String avatarUrl,  FarmerStatus status,  DateTime registeredDate,  int totalFarms,  double totalAcreage,  List<FarmModel> farms,  List<String> crops,  double totalCollected,  SyncStatus syncStatus)?  $default,) {final _that = this;
switch (_that) {
case _FarmerModel() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.nationalId,_that.region,_that.district,_that.community,_that.avatarUrl,_that.status,_that.registeredDate,_that.totalFarms,_that.totalAcreage,_that.farms,_that.crops,_that.totalCollected,_that.syncStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FarmerModel implements FarmerModel {
  const _FarmerModel({required this.id, required this.name, required this.phone, required this.nationalId, required this.region, required this.district, required this.community, required this.avatarUrl, required this.status, required this.registeredDate, required this.totalFarms, required this.totalAcreage,  List<FarmModel> farms = const [],  List<String> crops = const [], required this.totalCollected, required this.syncStatus}): _farms = farms,_crops = crops;
  factory _FarmerModel.fromJson(Map<String, dynamic> json) => _$FarmerModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String phone;
@override final  String nationalId;
@override final  String region;
@override final  String district;
@override final  String community;
@override final  String avatarUrl;
@override final  FarmerStatus status;
@override final  DateTime registeredDate;
@override final  int totalFarms;
@override final  double totalAcreage;
 final  List<FarmModel> _farms;
@override@JsonKey() List<FarmModel> get farms {
  if (_farms is EqualUnmodifiableListView) return _farms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_farms);
}

 final  List<String> _crops;
@override@JsonKey() List<String> get crops {
  if (_crops is EqualUnmodifiableListView) return _crops;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_crops);
}

@override final  double totalCollected;
@override final  SyncStatus syncStatus;

/// Create a copy of FarmerModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FarmerModelCopyWith<_FarmerModel> get copyWith => __$FarmerModelCopyWithImpl<_FarmerModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FarmerModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FarmerModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.nationalId, nationalId) || other.nationalId == nationalId)&&(identical(other.region, region) || other.region == region)&&(identical(other.district, district) || other.district == district)&&(identical(other.community, community) || other.community == community)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.registeredDate, registeredDate) || other.registeredDate == registeredDate)&&(identical(other.totalFarms, totalFarms) || other.totalFarms == totalFarms)&&(identical(other.totalAcreage, totalAcreage) || other.totalAcreage == totalAcreage)&&const DeepCollectionEquality().equals(other._farms, _farms)&&const DeepCollectionEquality().equals(other._crops, _crops)&&(identical(other.totalCollected, totalCollected) || other.totalCollected == totalCollected)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phone,nationalId,region,district,community,avatarUrl,status,registeredDate,totalFarms,totalAcreage,const DeepCollectionEquality().hash(_farms),const DeepCollectionEquality().hash(_crops),totalCollected,syncStatus);

@override
String toString() {
  return 'FarmerModel(id: $id, name: $name, phone: $phone, nationalId: $nationalId, region: $region, district: $district, community: $community, avatarUrl: $avatarUrl, status: $status, registeredDate: $registeredDate, totalFarms: $totalFarms, totalAcreage: $totalAcreage, farms: $farms, crops: $crops, totalCollected: $totalCollected, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class _$FarmerModelCopyWith<$Res> implements $FarmerModelCopyWith<$Res> {
  factory _$FarmerModelCopyWith(_FarmerModel value, $Res Function(_FarmerModel) _then) = __$FarmerModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String phone, String nationalId, String region, String district, String community, String avatarUrl, FarmerStatus status, DateTime registeredDate, int totalFarms, double totalAcreage, List<FarmModel> farms, List<String> crops, double totalCollected, SyncStatus syncStatus
});




}
/// @nodoc
class __$FarmerModelCopyWithImpl<$Res>
    implements _$FarmerModelCopyWith<$Res> {
  __$FarmerModelCopyWithImpl(this._self, this._then);

  final _FarmerModel _self;
  final $Res Function(_FarmerModel) _then;

/// Create a copy of FarmerModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? phone = null,Object? nationalId = null,Object? region = null,Object? district = null,Object? community = null,Object? avatarUrl = null,Object? status = null,Object? registeredDate = null,Object? totalFarms = null,Object? totalAcreage = null,Object? farms = null,Object? crops = null,Object? totalCollected = null,Object? syncStatus = null,}) {
  return _then(_FarmerModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,nationalId: null == nationalId ? _self.nationalId : nationalId // ignore: cast_nullable_to_non_nullable
as String,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,district: null == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String,community: null == community ? _self.community : community // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FarmerStatus,registeredDate: null == registeredDate ? _self.registeredDate : registeredDate // ignore: cast_nullable_to_non_nullable
as DateTime,totalFarms: null == totalFarms ? _self.totalFarms : totalFarms // ignore: cast_nullable_to_non_nullable
as int,totalAcreage: null == totalAcreage ? _self.totalAcreage : totalAcreage // ignore: cast_nullable_to_non_nullable
as double,farms: null == farms ? _self._farms : farms // ignore: cast_nullable_to_non_nullable
as List<FarmModel>,crops: null == crops ? _self._crops : crops // ignore: cast_nullable_to_non_nullable
as List<String>,totalCollected: null == totalCollected ? _self.totalCollected : totalCollected // ignore: cast_nullable_to_non_nullable
as double,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,
  ));
}


}

// dart format on
