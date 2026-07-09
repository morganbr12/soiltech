// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agent_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AgentProfile {

 String get id; String get name; String get phone; String get email; String get agentCode; String get region; String get district; String? get avatarUrl; int get totalFarmersRegistered; double get totalProduceCollected; int get totalCollections; double get performanceScore; DateTime get joinDate;
/// Create a copy of AgentProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgentProfileCopyWith<AgentProfile> get copyWith => _$AgentProfileCopyWithImpl<AgentProfile>(this as AgentProfile, _$identity);

  /// Serializes this AgentProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgentProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.agentCode, agentCode) || other.agentCode == agentCode)&&(identical(other.region, region) || other.region == region)&&(identical(other.district, district) || other.district == district)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.totalFarmersRegistered, totalFarmersRegistered) || other.totalFarmersRegistered == totalFarmersRegistered)&&(identical(other.totalProduceCollected, totalProduceCollected) || other.totalProduceCollected == totalProduceCollected)&&(identical(other.totalCollections, totalCollections) || other.totalCollections == totalCollections)&&(identical(other.performanceScore, performanceScore) || other.performanceScore == performanceScore)&&(identical(other.joinDate, joinDate) || other.joinDate == joinDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phone,email,agentCode,region,district,avatarUrl,totalFarmersRegistered,totalProduceCollected,totalCollections,performanceScore,joinDate);

@override
String toString() {
  return 'AgentProfile(id: $id, name: $name, phone: $phone, email: $email, agentCode: $agentCode, region: $region, district: $district, avatarUrl: $avatarUrl, totalFarmersRegistered: $totalFarmersRegistered, totalProduceCollected: $totalProduceCollected, totalCollections: $totalCollections, performanceScore: $performanceScore, joinDate: $joinDate)';
}


}

/// @nodoc
abstract mixin class $AgentProfileCopyWith<$Res>  {
  factory $AgentProfileCopyWith(AgentProfile value, $Res Function(AgentProfile) _then) = _$AgentProfileCopyWithImpl;
@useResult
$Res call({
 String id, String name, String phone, String email, String agentCode, String region, String district, String? avatarUrl, int totalFarmersRegistered, double totalProduceCollected, int totalCollections, double performanceScore, DateTime joinDate
});




}
/// @nodoc
class _$AgentProfileCopyWithImpl<$Res>
    implements $AgentProfileCopyWith<$Res> {
  _$AgentProfileCopyWithImpl(this._self, this._then);

  final AgentProfile _self;
  final $Res Function(AgentProfile) _then;

/// Create a copy of AgentProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? phone = null,Object? email = null,Object? agentCode = null,Object? region = null,Object? district = null,Object? avatarUrl = freezed,Object? totalFarmersRegistered = null,Object? totalProduceCollected = null,Object? totalCollections = null,Object? performanceScore = null,Object? joinDate = null,}) {
  return _then(AgentProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,agentCode: null == agentCode ? _self.agentCode : agentCode // ignore: cast_nullable_to_non_nullable
as String,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,district: null == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,totalFarmersRegistered: null == totalFarmersRegistered ? _self.totalFarmersRegistered : totalFarmersRegistered // ignore: cast_nullable_to_non_nullable
as int,totalProduceCollected: null == totalProduceCollected ? _self.totalProduceCollected : totalProduceCollected // ignore: cast_nullable_to_non_nullable
as double,totalCollections: null == totalCollections ? _self.totalCollections : totalCollections // ignore: cast_nullable_to_non_nullable
as int,performanceScore: null == performanceScore ? _self.performanceScore : performanceScore // ignore: cast_nullable_to_non_nullable
as double,joinDate: null == joinDate ? _self.joinDate : joinDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AgentProfile].
extension AgentProfilePatterns on AgentProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgentProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgentProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgentProfile value)  $default,){
final _that = this;
switch (_that) {
case _AgentProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgentProfile value)?  $default,){
final _that = this;
switch (_that) {
case _AgentProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String phone,  String email,  String agentCode,  String region,  String district,  String? avatarUrl,  int totalFarmersRegistered,  double totalProduceCollected,  int totalCollections,  double performanceScore,  DateTime joinDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgentProfile() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.email,_that.agentCode,_that.region,_that.district,_that.avatarUrl,_that.totalFarmersRegistered,_that.totalProduceCollected,_that.totalCollections,_that.performanceScore,_that.joinDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String phone,  String email,  String agentCode,  String region,  String district,  String? avatarUrl,  int totalFarmersRegistered,  double totalProduceCollected,  int totalCollections,  double performanceScore,  DateTime joinDate)  $default,) {final _that = this;
switch (_that) {
case _AgentProfile():
return $default(_that.id,_that.name,_that.phone,_that.email,_that.agentCode,_that.region,_that.district,_that.avatarUrl,_that.totalFarmersRegistered,_that.totalProduceCollected,_that.totalCollections,_that.performanceScore,_that.joinDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String phone,  String email,  String agentCode,  String region,  String district,  String? avatarUrl,  int totalFarmersRegistered,  double totalProduceCollected,  int totalCollections,  double performanceScore,  DateTime joinDate)?  $default,) {final _that = this;
switch (_that) {
case _AgentProfile() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.email,_that.agentCode,_that.region,_that.district,_that.avatarUrl,_that.totalFarmersRegistered,_that.totalProduceCollected,_that.totalCollections,_that.performanceScore,_that.joinDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AgentProfile implements AgentProfile {
  const _AgentProfile({required this.id, required this.name, required this.phone, required this.email, required this.agentCode, required this.region, required this.district, this.avatarUrl, required this.totalFarmersRegistered, required this.totalProduceCollected, required this.totalCollections, required this.performanceScore, required this.joinDate});
  factory _AgentProfile.fromJson(Map<String, dynamic> json) => _$AgentProfileFromJson(json);

@override final  String id;
@override final  String name;
@override final  String phone;
@override final  String email;
@override final  String agentCode;
@override final  String region;
@override final  String district;
@override final  String? avatarUrl;
@override final  int totalFarmersRegistered;
@override final  double totalProduceCollected;
@override final  int totalCollections;
@override final  double performanceScore;
@override final  DateTime joinDate;

/// Create a copy of AgentProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgentProfileCopyWith<_AgentProfile> get copyWith => __$AgentProfileCopyWithImpl<_AgentProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AgentProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgentProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.agentCode, agentCode) || other.agentCode == agentCode)&&(identical(other.region, region) || other.region == region)&&(identical(other.district, district) || other.district == district)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.totalFarmersRegistered, totalFarmersRegistered) || other.totalFarmersRegistered == totalFarmersRegistered)&&(identical(other.totalProduceCollected, totalProduceCollected) || other.totalProduceCollected == totalProduceCollected)&&(identical(other.totalCollections, totalCollections) || other.totalCollections == totalCollections)&&(identical(other.performanceScore, performanceScore) || other.performanceScore == performanceScore)&&(identical(other.joinDate, joinDate) || other.joinDate == joinDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phone,email,agentCode,region,district,avatarUrl,totalFarmersRegistered,totalProduceCollected,totalCollections,performanceScore,joinDate);

@override
String toString() {
  return 'AgentProfile(id: $id, name: $name, phone: $phone, email: $email, agentCode: $agentCode, region: $region, district: $district, avatarUrl: $avatarUrl, totalFarmersRegistered: $totalFarmersRegistered, totalProduceCollected: $totalProduceCollected, totalCollections: $totalCollections, performanceScore: $performanceScore, joinDate: $joinDate)';
}


}

/// @nodoc
abstract mixin class _$AgentProfileCopyWith<$Res> implements $AgentProfileCopyWith<$Res> {
  factory _$AgentProfileCopyWith(_AgentProfile value, $Res Function(_AgentProfile) _then) = __$AgentProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String phone, String email, String agentCode, String region, String district, String? avatarUrl, int totalFarmersRegistered, double totalProduceCollected, int totalCollections, double performanceScore, DateTime joinDate
});




}
/// @nodoc
class __$AgentProfileCopyWithImpl<$Res>
    implements _$AgentProfileCopyWith<$Res> {
  __$AgentProfileCopyWithImpl(this._self, this._then);

  final _AgentProfile _self;
  final $Res Function(_AgentProfile) _then;

/// Create a copy of AgentProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? phone = null,Object? email = null,Object? agentCode = null,Object? region = null,Object? district = null,Object? avatarUrl = freezed,Object? totalFarmersRegistered = null,Object? totalProduceCollected = null,Object? totalCollections = null,Object? performanceScore = null,Object? joinDate = null,}) {
  return _then(_AgentProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,agentCode: null == agentCode ? _self.agentCode : agentCode // ignore: cast_nullable_to_non_nullable
as String,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String,district: null == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,totalFarmersRegistered: null == totalFarmersRegistered ? _self.totalFarmersRegistered : totalFarmersRegistered // ignore: cast_nullable_to_non_nullable
as int,totalProduceCollected: null == totalProduceCollected ? _self.totalProduceCollected : totalProduceCollected // ignore: cast_nullable_to_non_nullable
as double,totalCollections: null == totalCollections ? _self.totalCollections : totalCollections // ignore: cast_nullable_to_non_nullable
as int,performanceScore: null == performanceScore ? _self.performanceScore : performanceScore // ignore: cast_nullable_to_non_nullable
as double,joinDate: null == joinDate ? _self.joinDate : joinDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
