// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pickup_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PickupRequest {

 String get id; String get produceRecordId; String get farmerId; String get farmerName; String get cropType; double get weightKg; String get pickupLocation; double get pickupLatitude; double get pickupLongitude; String get deliveryLocation; LogisticsStatus get status; DateTime get requestDate; String? get driverName; String? get driverPhone; String? get vehicleNumber; DateTime? get estimatedPickup; SyncStatus get syncStatus;
/// Create a copy of PickupRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PickupRequestCopyWith<PickupRequest> get copyWith => _$PickupRequestCopyWithImpl<PickupRequest>(this as PickupRequest, _$identity);

  /// Serializes this PickupRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PickupRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.produceRecordId, produceRecordId) || other.produceRecordId == produceRecordId)&&(identical(other.farmerId, farmerId) || other.farmerId == farmerId)&&(identical(other.farmerName, farmerName) || other.farmerName == farmerName)&&(identical(other.cropType, cropType) || other.cropType == cropType)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.pickupLocation, pickupLocation) || other.pickupLocation == pickupLocation)&&(identical(other.pickupLatitude, pickupLatitude) || other.pickupLatitude == pickupLatitude)&&(identical(other.pickupLongitude, pickupLongitude) || other.pickupLongitude == pickupLongitude)&&(identical(other.deliveryLocation, deliveryLocation) || other.deliveryLocation == deliveryLocation)&&(identical(other.status, status) || other.status == status)&&(identical(other.requestDate, requestDate) || other.requestDate == requestDate)&&(identical(other.driverName, driverName) || other.driverName == driverName)&&(identical(other.driverPhone, driverPhone) || other.driverPhone == driverPhone)&&(identical(other.vehicleNumber, vehicleNumber) || other.vehicleNumber == vehicleNumber)&&(identical(other.estimatedPickup, estimatedPickup) || other.estimatedPickup == estimatedPickup)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,produceRecordId,farmerId,farmerName,cropType,weightKg,pickupLocation,pickupLatitude,pickupLongitude,deliveryLocation,status,requestDate,driverName,driverPhone,vehicleNumber,estimatedPickup,syncStatus);

@override
String toString() {
  return 'PickupRequest(id: $id, produceRecordId: $produceRecordId, farmerId: $farmerId, farmerName: $farmerName, cropType: $cropType, weightKg: $weightKg, pickupLocation: $pickupLocation, pickupLatitude: $pickupLatitude, pickupLongitude: $pickupLongitude, deliveryLocation: $deliveryLocation, status: $status, requestDate: $requestDate, driverName: $driverName, driverPhone: $driverPhone, vehicleNumber: $vehicleNumber, estimatedPickup: $estimatedPickup, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class $PickupRequestCopyWith<$Res>  {
  factory $PickupRequestCopyWith(PickupRequest value, $Res Function(PickupRequest) _then) = _$PickupRequestCopyWithImpl;
@useResult
$Res call({
 String id, String produceRecordId, String farmerId, String farmerName, String cropType, double weightKg, String pickupLocation, double pickupLatitude, double pickupLongitude, String deliveryLocation, LogisticsStatus status, DateTime requestDate, String? driverName, String? driverPhone, String? vehicleNumber, DateTime? estimatedPickup, SyncStatus syncStatus
});




}
/// @nodoc
class _$PickupRequestCopyWithImpl<$Res>
    implements $PickupRequestCopyWith<$Res> {
  _$PickupRequestCopyWithImpl(this._self, this._then);

  final PickupRequest _self;
  final $Res Function(PickupRequest) _then;

/// Create a copy of PickupRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? produceRecordId = null,Object? farmerId = null,Object? farmerName = null,Object? cropType = null,Object? weightKg = null,Object? pickupLocation = null,Object? pickupLatitude = null,Object? pickupLongitude = null,Object? deliveryLocation = null,Object? status = null,Object? requestDate = null,Object? driverName = freezed,Object? driverPhone = freezed,Object? vehicleNumber = freezed,Object? estimatedPickup = freezed,Object? syncStatus = null,}) {
  return _then(PickupRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,produceRecordId: null == produceRecordId ? _self.produceRecordId : produceRecordId // ignore: cast_nullable_to_non_nullable
as String,farmerId: null == farmerId ? _self.farmerId : farmerId // ignore: cast_nullable_to_non_nullable
as String,farmerName: null == farmerName ? _self.farmerName : farmerName // ignore: cast_nullable_to_non_nullable
as String,cropType: null == cropType ? _self.cropType : cropType // ignore: cast_nullable_to_non_nullable
as String,weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,pickupLocation: null == pickupLocation ? _self.pickupLocation : pickupLocation // ignore: cast_nullable_to_non_nullable
as String,pickupLatitude: null == pickupLatitude ? _self.pickupLatitude : pickupLatitude // ignore: cast_nullable_to_non_nullable
as double,pickupLongitude: null == pickupLongitude ? _self.pickupLongitude : pickupLongitude // ignore: cast_nullable_to_non_nullable
as double,deliveryLocation: null == deliveryLocation ? _self.deliveryLocation : deliveryLocation // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LogisticsStatus,requestDate: null == requestDate ? _self.requestDate : requestDate // ignore: cast_nullable_to_non_nullable
as DateTime,driverName: freezed == driverName ? _self.driverName : driverName // ignore: cast_nullable_to_non_nullable
as String?,driverPhone: freezed == driverPhone ? _self.driverPhone : driverPhone // ignore: cast_nullable_to_non_nullable
as String?,vehicleNumber: freezed == vehicleNumber ? _self.vehicleNumber : vehicleNumber // ignore: cast_nullable_to_non_nullable
as String?,estimatedPickup: freezed == estimatedPickup ? _self.estimatedPickup : estimatedPickup // ignore: cast_nullable_to_non_nullable
as DateTime?,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [PickupRequest].
extension PickupRequestPatterns on PickupRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PickupRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PickupRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PickupRequest value)  $default,){
final _that = this;
switch (_that) {
case _PickupRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PickupRequest value)?  $default,){
final _that = this;
switch (_that) {
case _PickupRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String produceRecordId,  String farmerId,  String farmerName,  String cropType,  double weightKg,  String pickupLocation,  double pickupLatitude,  double pickupLongitude,  String deliveryLocation,  LogisticsStatus status,  DateTime requestDate,  String? driverName,  String? driverPhone,  String? vehicleNumber,  DateTime? estimatedPickup,  SyncStatus syncStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PickupRequest() when $default != null:
return $default(_that.id,_that.produceRecordId,_that.farmerId,_that.farmerName,_that.cropType,_that.weightKg,_that.pickupLocation,_that.pickupLatitude,_that.pickupLongitude,_that.deliveryLocation,_that.status,_that.requestDate,_that.driverName,_that.driverPhone,_that.vehicleNumber,_that.estimatedPickup,_that.syncStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String produceRecordId,  String farmerId,  String farmerName,  String cropType,  double weightKg,  String pickupLocation,  double pickupLatitude,  double pickupLongitude,  String deliveryLocation,  LogisticsStatus status,  DateTime requestDate,  String? driverName,  String? driverPhone,  String? vehicleNumber,  DateTime? estimatedPickup,  SyncStatus syncStatus)  $default,) {final _that = this;
switch (_that) {
case _PickupRequest():
return $default(_that.id,_that.produceRecordId,_that.farmerId,_that.farmerName,_that.cropType,_that.weightKg,_that.pickupLocation,_that.pickupLatitude,_that.pickupLongitude,_that.deliveryLocation,_that.status,_that.requestDate,_that.driverName,_that.driverPhone,_that.vehicleNumber,_that.estimatedPickup,_that.syncStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String produceRecordId,  String farmerId,  String farmerName,  String cropType,  double weightKg,  String pickupLocation,  double pickupLatitude,  double pickupLongitude,  String deliveryLocation,  LogisticsStatus status,  DateTime requestDate,  String? driverName,  String? driverPhone,  String? vehicleNumber,  DateTime? estimatedPickup,  SyncStatus syncStatus)?  $default,) {final _that = this;
switch (_that) {
case _PickupRequest() when $default != null:
return $default(_that.id,_that.produceRecordId,_that.farmerId,_that.farmerName,_that.cropType,_that.weightKg,_that.pickupLocation,_that.pickupLatitude,_that.pickupLongitude,_that.deliveryLocation,_that.status,_that.requestDate,_that.driverName,_that.driverPhone,_that.vehicleNumber,_that.estimatedPickup,_that.syncStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PickupRequest implements PickupRequest {
  const _PickupRequest({required this.id, required this.produceRecordId, required this.farmerId, required this.farmerName, required this.cropType, required this.weightKg, required this.pickupLocation, required this.pickupLatitude, required this.pickupLongitude, required this.deliveryLocation, required this.status, required this.requestDate, this.driverName, this.driverPhone, this.vehicleNumber, this.estimatedPickup, required this.syncStatus});
  factory _PickupRequest.fromJson(Map<String, dynamic> json) => _$PickupRequestFromJson(json);

@override final  String id;
@override final  String produceRecordId;
@override final  String farmerId;
@override final  String farmerName;
@override final  String cropType;
@override final  double weightKg;
@override final  String pickupLocation;
@override final  double pickupLatitude;
@override final  double pickupLongitude;
@override final  String deliveryLocation;
@override final  LogisticsStatus status;
@override final  DateTime requestDate;
@override final  String? driverName;
@override final  String? driverPhone;
@override final  String? vehicleNumber;
@override final  DateTime? estimatedPickup;
@override final  SyncStatus syncStatus;

/// Create a copy of PickupRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PickupRequestCopyWith<_PickupRequest> get copyWith => __$PickupRequestCopyWithImpl<_PickupRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PickupRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PickupRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.produceRecordId, produceRecordId) || other.produceRecordId == produceRecordId)&&(identical(other.farmerId, farmerId) || other.farmerId == farmerId)&&(identical(other.farmerName, farmerName) || other.farmerName == farmerName)&&(identical(other.cropType, cropType) || other.cropType == cropType)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.pickupLocation, pickupLocation) || other.pickupLocation == pickupLocation)&&(identical(other.pickupLatitude, pickupLatitude) || other.pickupLatitude == pickupLatitude)&&(identical(other.pickupLongitude, pickupLongitude) || other.pickupLongitude == pickupLongitude)&&(identical(other.deliveryLocation, deliveryLocation) || other.deliveryLocation == deliveryLocation)&&(identical(other.status, status) || other.status == status)&&(identical(other.requestDate, requestDate) || other.requestDate == requestDate)&&(identical(other.driverName, driverName) || other.driverName == driverName)&&(identical(other.driverPhone, driverPhone) || other.driverPhone == driverPhone)&&(identical(other.vehicleNumber, vehicleNumber) || other.vehicleNumber == vehicleNumber)&&(identical(other.estimatedPickup, estimatedPickup) || other.estimatedPickup == estimatedPickup)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,produceRecordId,farmerId,farmerName,cropType,weightKg,pickupLocation,pickupLatitude,pickupLongitude,deliveryLocation,status,requestDate,driverName,driverPhone,vehicleNumber,estimatedPickup,syncStatus);

@override
String toString() {
  return 'PickupRequest(id: $id, produceRecordId: $produceRecordId, farmerId: $farmerId, farmerName: $farmerName, cropType: $cropType, weightKg: $weightKg, pickupLocation: $pickupLocation, pickupLatitude: $pickupLatitude, pickupLongitude: $pickupLongitude, deliveryLocation: $deliveryLocation, status: $status, requestDate: $requestDate, driverName: $driverName, driverPhone: $driverPhone, vehicleNumber: $vehicleNumber, estimatedPickup: $estimatedPickup, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class _$PickupRequestCopyWith<$Res> implements $PickupRequestCopyWith<$Res> {
  factory _$PickupRequestCopyWith(_PickupRequest value, $Res Function(_PickupRequest) _then) = __$PickupRequestCopyWithImpl;
@override @useResult
$Res call({
 String id, String produceRecordId, String farmerId, String farmerName, String cropType, double weightKg, String pickupLocation, double pickupLatitude, double pickupLongitude, String deliveryLocation, LogisticsStatus status, DateTime requestDate, String? driverName, String? driverPhone, String? vehicleNumber, DateTime? estimatedPickup, SyncStatus syncStatus
});




}
/// @nodoc
class __$PickupRequestCopyWithImpl<$Res>
    implements _$PickupRequestCopyWith<$Res> {
  __$PickupRequestCopyWithImpl(this._self, this._then);

  final _PickupRequest _self;
  final $Res Function(_PickupRequest) _then;

/// Create a copy of PickupRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? produceRecordId = null,Object? farmerId = null,Object? farmerName = null,Object? cropType = null,Object? weightKg = null,Object? pickupLocation = null,Object? pickupLatitude = null,Object? pickupLongitude = null,Object? deliveryLocation = null,Object? status = null,Object? requestDate = null,Object? driverName = freezed,Object? driverPhone = freezed,Object? vehicleNumber = freezed,Object? estimatedPickup = freezed,Object? syncStatus = null,}) {
  return _then(_PickupRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,produceRecordId: null == produceRecordId ? _self.produceRecordId : produceRecordId // ignore: cast_nullable_to_non_nullable
as String,farmerId: null == farmerId ? _self.farmerId : farmerId // ignore: cast_nullable_to_non_nullable
as String,farmerName: null == farmerName ? _self.farmerName : farmerName // ignore: cast_nullable_to_non_nullable
as String,cropType: null == cropType ? _self.cropType : cropType // ignore: cast_nullable_to_non_nullable
as String,weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,pickupLocation: null == pickupLocation ? _self.pickupLocation : pickupLocation // ignore: cast_nullable_to_non_nullable
as String,pickupLatitude: null == pickupLatitude ? _self.pickupLatitude : pickupLatitude // ignore: cast_nullable_to_non_nullable
as double,pickupLongitude: null == pickupLongitude ? _self.pickupLongitude : pickupLongitude // ignore: cast_nullable_to_non_nullable
as double,deliveryLocation: null == deliveryLocation ? _self.deliveryLocation : deliveryLocation // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LogisticsStatus,requestDate: null == requestDate ? _self.requestDate : requestDate // ignore: cast_nullable_to_non_nullable
as DateTime,driverName: freezed == driverName ? _self.driverName : driverName // ignore: cast_nullable_to_non_nullable
as String?,driverPhone: freezed == driverPhone ? _self.driverPhone : driverPhone // ignore: cast_nullable_to_non_nullable
as String?,vehicleNumber: freezed == vehicleNumber ? _self.vehicleNumber : vehicleNumber // ignore: cast_nullable_to_non_nullable
as String?,estimatedPickup: freezed == estimatedPickup ? _self.estimatedPickup : estimatedPickup // ignore: cast_nullable_to_non_nullable
as DateTime?,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,
  ));
}


}

// dart format on
