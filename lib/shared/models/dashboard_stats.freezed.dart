// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardStats {

 int get todayCollections; int get todayFarmers; int get pendingUploads; int get offlineRecords; double get todayWeight; double get weeklyWeight; double get monthlyRevenue; int get activePickups;
/// Create a copy of DashboardStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardStatsCopyWith<DashboardStats> get copyWith => _$DashboardStatsCopyWithImpl<DashboardStats>(this as DashboardStats, _$identity);

  /// Serializes this DashboardStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardStats&&(identical(other.todayCollections, todayCollections) || other.todayCollections == todayCollections)&&(identical(other.todayFarmers, todayFarmers) || other.todayFarmers == todayFarmers)&&(identical(other.pendingUploads, pendingUploads) || other.pendingUploads == pendingUploads)&&(identical(other.offlineRecords, offlineRecords) || other.offlineRecords == offlineRecords)&&(identical(other.todayWeight, todayWeight) || other.todayWeight == todayWeight)&&(identical(other.weeklyWeight, weeklyWeight) || other.weeklyWeight == weeklyWeight)&&(identical(other.monthlyRevenue, monthlyRevenue) || other.monthlyRevenue == monthlyRevenue)&&(identical(other.activePickups, activePickups) || other.activePickups == activePickups));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,todayCollections,todayFarmers,pendingUploads,offlineRecords,todayWeight,weeklyWeight,monthlyRevenue,activePickups);

@override
String toString() {
  return 'DashboardStats(todayCollections: $todayCollections, todayFarmers: $todayFarmers, pendingUploads: $pendingUploads, offlineRecords: $offlineRecords, todayWeight: $todayWeight, weeklyWeight: $weeklyWeight, monthlyRevenue: $monthlyRevenue, activePickups: $activePickups)';
}


}

/// @nodoc
abstract mixin class $DashboardStatsCopyWith<$Res>  {
  factory $DashboardStatsCopyWith(DashboardStats value, $Res Function(DashboardStats) _then) = _$DashboardStatsCopyWithImpl;
@useResult
$Res call({
 int todayCollections, int todayFarmers, int pendingUploads, int offlineRecords, double todayWeight, double weeklyWeight, double monthlyRevenue, int activePickups
});




}
/// @nodoc
class _$DashboardStatsCopyWithImpl<$Res>
    implements $DashboardStatsCopyWith<$Res> {
  _$DashboardStatsCopyWithImpl(this._self, this._then);

  final DashboardStats _self;
  final $Res Function(DashboardStats) _then;

/// Create a copy of DashboardStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? todayCollections = null,Object? todayFarmers = null,Object? pendingUploads = null,Object? offlineRecords = null,Object? todayWeight = null,Object? weeklyWeight = null,Object? monthlyRevenue = null,Object? activePickups = null,}) {
  return _then(DashboardStats(
todayCollections: null == todayCollections ? _self.todayCollections : todayCollections // ignore: cast_nullable_to_non_nullable
as int,todayFarmers: null == todayFarmers ? _self.todayFarmers : todayFarmers // ignore: cast_nullable_to_non_nullable
as int,pendingUploads: null == pendingUploads ? _self.pendingUploads : pendingUploads // ignore: cast_nullable_to_non_nullable
as int,offlineRecords: null == offlineRecords ? _self.offlineRecords : offlineRecords // ignore: cast_nullable_to_non_nullable
as int,todayWeight: null == todayWeight ? _self.todayWeight : todayWeight // ignore: cast_nullable_to_non_nullable
as double,weeklyWeight: null == weeklyWeight ? _self.weeklyWeight : weeklyWeight // ignore: cast_nullable_to_non_nullable
as double,monthlyRevenue: null == monthlyRevenue ? _self.monthlyRevenue : monthlyRevenue // ignore: cast_nullable_to_non_nullable
as double,activePickups: null == activePickups ? _self.activePickups : activePickups // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardStats].
extension DashboardStatsPatterns on DashboardStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardStats value)  $default,){
final _that = this;
switch (_that) {
case _DashboardStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardStats value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int todayCollections,  int todayFarmers,  int pendingUploads,  int offlineRecords,  double todayWeight,  double weeklyWeight,  double monthlyRevenue,  int activePickups)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardStats() when $default != null:
return $default(_that.todayCollections,_that.todayFarmers,_that.pendingUploads,_that.offlineRecords,_that.todayWeight,_that.weeklyWeight,_that.monthlyRevenue,_that.activePickups);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int todayCollections,  int todayFarmers,  int pendingUploads,  int offlineRecords,  double todayWeight,  double weeklyWeight,  double monthlyRevenue,  int activePickups)  $default,) {final _that = this;
switch (_that) {
case _DashboardStats():
return $default(_that.todayCollections,_that.todayFarmers,_that.pendingUploads,_that.offlineRecords,_that.todayWeight,_that.weeklyWeight,_that.monthlyRevenue,_that.activePickups);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int todayCollections,  int todayFarmers,  int pendingUploads,  int offlineRecords,  double todayWeight,  double weeklyWeight,  double monthlyRevenue,  int activePickups)?  $default,) {final _that = this;
switch (_that) {
case _DashboardStats() when $default != null:
return $default(_that.todayCollections,_that.todayFarmers,_that.pendingUploads,_that.offlineRecords,_that.todayWeight,_that.weeklyWeight,_that.monthlyRevenue,_that.activePickups);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardStats implements DashboardStats {
  const _DashboardStats({required this.todayCollections, required this.todayFarmers, required this.pendingUploads, required this.offlineRecords, required this.todayWeight, required this.weeklyWeight, required this.monthlyRevenue, required this.activePickups});
  factory _DashboardStats.fromJson(Map<String, dynamic> json) => _$DashboardStatsFromJson(json);

@override final  int todayCollections;
@override final  int todayFarmers;
@override final  int pendingUploads;
@override final  int offlineRecords;
@override final  double todayWeight;
@override final  double weeklyWeight;
@override final  double monthlyRevenue;
@override final  int activePickups;

/// Create a copy of DashboardStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardStatsCopyWith<_DashboardStats> get copyWith => __$DashboardStatsCopyWithImpl<_DashboardStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardStats&&(identical(other.todayCollections, todayCollections) || other.todayCollections == todayCollections)&&(identical(other.todayFarmers, todayFarmers) || other.todayFarmers == todayFarmers)&&(identical(other.pendingUploads, pendingUploads) || other.pendingUploads == pendingUploads)&&(identical(other.offlineRecords, offlineRecords) || other.offlineRecords == offlineRecords)&&(identical(other.todayWeight, todayWeight) || other.todayWeight == todayWeight)&&(identical(other.weeklyWeight, weeklyWeight) || other.weeklyWeight == weeklyWeight)&&(identical(other.monthlyRevenue, monthlyRevenue) || other.monthlyRevenue == monthlyRevenue)&&(identical(other.activePickups, activePickups) || other.activePickups == activePickups));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,todayCollections,todayFarmers,pendingUploads,offlineRecords,todayWeight,weeklyWeight,monthlyRevenue,activePickups);

@override
String toString() {
  return 'DashboardStats(todayCollections: $todayCollections, todayFarmers: $todayFarmers, pendingUploads: $pendingUploads, offlineRecords: $offlineRecords, todayWeight: $todayWeight, weeklyWeight: $weeklyWeight, monthlyRevenue: $monthlyRevenue, activePickups: $activePickups)';
}


}

/// @nodoc
abstract mixin class _$DashboardStatsCopyWith<$Res> implements $DashboardStatsCopyWith<$Res> {
  factory _$DashboardStatsCopyWith(_DashboardStats value, $Res Function(_DashboardStats) _then) = __$DashboardStatsCopyWithImpl;
@override @useResult
$Res call({
 int todayCollections, int todayFarmers, int pendingUploads, int offlineRecords, double todayWeight, double weeklyWeight, double monthlyRevenue, int activePickups
});




}
/// @nodoc
class __$DashboardStatsCopyWithImpl<$Res>
    implements _$DashboardStatsCopyWith<$Res> {
  __$DashboardStatsCopyWithImpl(this._self, this._then);

  final _DashboardStats _self;
  final $Res Function(_DashboardStats) _then;

/// Create a copy of DashboardStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? todayCollections = null,Object? todayFarmers = null,Object? pendingUploads = null,Object? offlineRecords = null,Object? todayWeight = null,Object? weeklyWeight = null,Object? monthlyRevenue = null,Object? activePickups = null,}) {
  return _then(_DashboardStats(
todayCollections: null == todayCollections ? _self.todayCollections : todayCollections // ignore: cast_nullable_to_non_nullable
as int,todayFarmers: null == todayFarmers ? _self.todayFarmers : todayFarmers // ignore: cast_nullable_to_non_nullable
as int,pendingUploads: null == pendingUploads ? _self.pendingUploads : pendingUploads // ignore: cast_nullable_to_non_nullable
as int,offlineRecords: null == offlineRecords ? _self.offlineRecords : offlineRecords // ignore: cast_nullable_to_non_nullable
as int,todayWeight: null == todayWeight ? _self.todayWeight : todayWeight // ignore: cast_nullable_to_non_nullable
as double,weeklyWeight: null == weeklyWeight ? _self.weeklyWeight : weeklyWeight // ignore: cast_nullable_to_non_nullable
as double,monthlyRevenue: null == monthlyRevenue ? _self.monthlyRevenue : monthlyRevenue // ignore: cast_nullable_to_non_nullable
as double,activePickups: null == activePickups ? _self.activePickups : activePickups // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
