// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaymentRecord {

 String get id; String get farmerId; String get farmerName; String get farmerPhone; String get produceRecordId; String get cropType; double get amount; PaymentStatus get status; DateTime get dueDate; DateTime? get paidDate; String get paymentMethod; String? get transactionRef; SyncStatus get syncStatus;
/// Create a copy of PaymentRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentRecordCopyWith<PaymentRecord> get copyWith => _$PaymentRecordCopyWithImpl<PaymentRecord>(this as PaymentRecord, _$identity);

  /// Serializes this PaymentRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.farmerId, farmerId) || other.farmerId == farmerId)&&(identical(other.farmerName, farmerName) || other.farmerName == farmerName)&&(identical(other.farmerPhone, farmerPhone) || other.farmerPhone == farmerPhone)&&(identical(other.produceRecordId, produceRecordId) || other.produceRecordId == produceRecordId)&&(identical(other.cropType, cropType) || other.cropType == cropType)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.status, status) || other.status == status)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.paidDate, paidDate) || other.paidDate == paidDate)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.transactionRef, transactionRef) || other.transactionRef == transactionRef)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,farmerId,farmerName,farmerPhone,produceRecordId,cropType,amount,status,dueDate,paidDate,paymentMethod,transactionRef,syncStatus);

@override
String toString() {
  return 'PaymentRecord(id: $id, farmerId: $farmerId, farmerName: $farmerName, farmerPhone: $farmerPhone, produceRecordId: $produceRecordId, cropType: $cropType, amount: $amount, status: $status, dueDate: $dueDate, paidDate: $paidDate, paymentMethod: $paymentMethod, transactionRef: $transactionRef, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class $PaymentRecordCopyWith<$Res>  {
  factory $PaymentRecordCopyWith(PaymentRecord value, $Res Function(PaymentRecord) _then) = _$PaymentRecordCopyWithImpl;
@useResult
$Res call({
 String id, String farmerId, String farmerName, String farmerPhone, String produceRecordId, String cropType, double amount, PaymentStatus status, DateTime dueDate, DateTime? paidDate, String paymentMethod, String? transactionRef, SyncStatus syncStatus
});




}
/// @nodoc
class _$PaymentRecordCopyWithImpl<$Res>
    implements $PaymentRecordCopyWith<$Res> {
  _$PaymentRecordCopyWithImpl(this._self, this._then);

  final PaymentRecord _self;
  final $Res Function(PaymentRecord) _then;

/// Create a copy of PaymentRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? farmerId = null,Object? farmerName = null,Object? farmerPhone = null,Object? produceRecordId = null,Object? cropType = null,Object? amount = null,Object? status = null,Object? dueDate = null,Object? paidDate = freezed,Object? paymentMethod = null,Object? transactionRef = freezed,Object? syncStatus = null,}) {
  return _then(PaymentRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,farmerId: null == farmerId ? _self.farmerId : farmerId // ignore: cast_nullable_to_non_nullable
as String,farmerName: null == farmerName ? _self.farmerName : farmerName // ignore: cast_nullable_to_non_nullable
as String,farmerPhone: null == farmerPhone ? _self.farmerPhone : farmerPhone // ignore: cast_nullable_to_non_nullable
as String,produceRecordId: null == produceRecordId ? _self.produceRecordId : produceRecordId // ignore: cast_nullable_to_non_nullable
as String,cropType: null == cropType ? _self.cropType : cropType // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,paidDate: freezed == paidDate ? _self.paidDate : paidDate // ignore: cast_nullable_to_non_nullable
as DateTime?,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,transactionRef: freezed == transactionRef ? _self.transactionRef : transactionRef // ignore: cast_nullable_to_non_nullable
as String?,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentRecord].
extension PaymentRecordPatterns on PaymentRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentRecord value)  $default,){
final _that = this;
switch (_that) {
case _PaymentRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentRecord value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String farmerId,  String farmerName,  String farmerPhone,  String produceRecordId,  String cropType,  double amount,  PaymentStatus status,  DateTime dueDate,  DateTime? paidDate,  String paymentMethod,  String? transactionRef,  SyncStatus syncStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentRecord() when $default != null:
return $default(_that.id,_that.farmerId,_that.farmerName,_that.farmerPhone,_that.produceRecordId,_that.cropType,_that.amount,_that.status,_that.dueDate,_that.paidDate,_that.paymentMethod,_that.transactionRef,_that.syncStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String farmerId,  String farmerName,  String farmerPhone,  String produceRecordId,  String cropType,  double amount,  PaymentStatus status,  DateTime dueDate,  DateTime? paidDate,  String paymentMethod,  String? transactionRef,  SyncStatus syncStatus)  $default,) {final _that = this;
switch (_that) {
case _PaymentRecord():
return $default(_that.id,_that.farmerId,_that.farmerName,_that.farmerPhone,_that.produceRecordId,_that.cropType,_that.amount,_that.status,_that.dueDate,_that.paidDate,_that.paymentMethod,_that.transactionRef,_that.syncStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String farmerId,  String farmerName,  String farmerPhone,  String produceRecordId,  String cropType,  double amount,  PaymentStatus status,  DateTime dueDate,  DateTime? paidDate,  String paymentMethod,  String? transactionRef,  SyncStatus syncStatus)?  $default,) {final _that = this;
switch (_that) {
case _PaymentRecord() when $default != null:
return $default(_that.id,_that.farmerId,_that.farmerName,_that.farmerPhone,_that.produceRecordId,_that.cropType,_that.amount,_that.status,_that.dueDate,_that.paidDate,_that.paymentMethod,_that.transactionRef,_that.syncStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentRecord implements PaymentRecord {
  const _PaymentRecord({required this.id, required this.farmerId, required this.farmerName, required this.farmerPhone, required this.produceRecordId, required this.cropType, required this.amount, required this.status, required this.dueDate, this.paidDate, required this.paymentMethod, this.transactionRef, required this.syncStatus});
  factory _PaymentRecord.fromJson(Map<String, dynamic> json) => _$PaymentRecordFromJson(json);

@override final  String id;
@override final  String farmerId;
@override final  String farmerName;
@override final  String farmerPhone;
@override final  String produceRecordId;
@override final  String cropType;
@override final  double amount;
@override final  PaymentStatus status;
@override final  DateTime dueDate;
@override final  DateTime? paidDate;
@override final  String paymentMethod;
@override final  String? transactionRef;
@override final  SyncStatus syncStatus;

/// Create a copy of PaymentRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentRecordCopyWith<_PaymentRecord> get copyWith => __$PaymentRecordCopyWithImpl<_PaymentRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.farmerId, farmerId) || other.farmerId == farmerId)&&(identical(other.farmerName, farmerName) || other.farmerName == farmerName)&&(identical(other.farmerPhone, farmerPhone) || other.farmerPhone == farmerPhone)&&(identical(other.produceRecordId, produceRecordId) || other.produceRecordId == produceRecordId)&&(identical(other.cropType, cropType) || other.cropType == cropType)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.status, status) || other.status == status)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.paidDate, paidDate) || other.paidDate == paidDate)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.transactionRef, transactionRef) || other.transactionRef == transactionRef)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,farmerId,farmerName,farmerPhone,produceRecordId,cropType,amount,status,dueDate,paidDate,paymentMethod,transactionRef,syncStatus);

@override
String toString() {
  return 'PaymentRecord(id: $id, farmerId: $farmerId, farmerName: $farmerName, farmerPhone: $farmerPhone, produceRecordId: $produceRecordId, cropType: $cropType, amount: $amount, status: $status, dueDate: $dueDate, paidDate: $paidDate, paymentMethod: $paymentMethod, transactionRef: $transactionRef, syncStatus: $syncStatus)';
}


}

/// @nodoc
abstract mixin class _$PaymentRecordCopyWith<$Res> implements $PaymentRecordCopyWith<$Res> {
  factory _$PaymentRecordCopyWith(_PaymentRecord value, $Res Function(_PaymentRecord) _then) = __$PaymentRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String farmerId, String farmerName, String farmerPhone, String produceRecordId, String cropType, double amount, PaymentStatus status, DateTime dueDate, DateTime? paidDate, String paymentMethod, String? transactionRef, SyncStatus syncStatus
});




}
/// @nodoc
class __$PaymentRecordCopyWithImpl<$Res>
    implements _$PaymentRecordCopyWith<$Res> {
  __$PaymentRecordCopyWithImpl(this._self, this._then);

  final _PaymentRecord _self;
  final $Res Function(_PaymentRecord) _then;

/// Create a copy of PaymentRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? farmerId = null,Object? farmerName = null,Object? farmerPhone = null,Object? produceRecordId = null,Object? cropType = null,Object? amount = null,Object? status = null,Object? dueDate = null,Object? paidDate = freezed,Object? paymentMethod = null,Object? transactionRef = freezed,Object? syncStatus = null,}) {
  return _then(_PaymentRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,farmerId: null == farmerId ? _self.farmerId : farmerId // ignore: cast_nullable_to_non_nullable
as String,farmerName: null == farmerName ? _self.farmerName : farmerName // ignore: cast_nullable_to_non_nullable
as String,farmerPhone: null == farmerPhone ? _self.farmerPhone : farmerPhone // ignore: cast_nullable_to_non_nullable
as String,produceRecordId: null == produceRecordId ? _self.produceRecordId : produceRecordId // ignore: cast_nullable_to_non_nullable
as String,cropType: null == cropType ? _self.cropType : cropType // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,paidDate: freezed == paidDate ? _self.paidDate : paidDate // ignore: cast_nullable_to_non_nullable
as DateTime?,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,transactionRef: freezed == transactionRef ? _self.transactionRef : transactionRef // ignore: cast_nullable_to_non_nullable
as String?,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as SyncStatus,
  ));
}


}

// dart format on
