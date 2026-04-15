// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_services_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DashboardServicesState {

// Loading status
 StateStatus get ourServicesLoadingStateStatus;// Data
 List<OurServiceEntity> get servicesList; String? get servicesErrorMessage;
/// Create a copy of DashboardServicesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardServicesStateCopyWith<DashboardServicesState> get copyWith => _$DashboardServicesStateCopyWithImpl<DashboardServicesState>(this as DashboardServicesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardServicesState&&(identical(other.ourServicesLoadingStateStatus, ourServicesLoadingStateStatus) || other.ourServicesLoadingStateStatus == ourServicesLoadingStateStatus)&&const DeepCollectionEquality().equals(other.servicesList, servicesList)&&(identical(other.servicesErrorMessage, servicesErrorMessage) || other.servicesErrorMessage == servicesErrorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,ourServicesLoadingStateStatus,const DeepCollectionEquality().hash(servicesList),servicesErrorMessage);

@override
String toString() {
  return 'DashboardServicesState(ourServicesLoadingStateStatus: $ourServicesLoadingStateStatus, servicesList: $servicesList, servicesErrorMessage: $servicesErrorMessage)';
}


}

/// @nodoc
abstract mixin class $DashboardServicesStateCopyWith<$Res>  {
  factory $DashboardServicesStateCopyWith(DashboardServicesState value, $Res Function(DashboardServicesState) _then) = _$DashboardServicesStateCopyWithImpl;
@useResult
$Res call({
 StateStatus ourServicesLoadingStateStatus, List<OurServiceEntity> servicesList, String? servicesErrorMessage
});




}
/// @nodoc
class _$DashboardServicesStateCopyWithImpl<$Res>
    implements $DashboardServicesStateCopyWith<$Res> {
  _$DashboardServicesStateCopyWithImpl(this._self, this._then);

  final DashboardServicesState _self;
  final $Res Function(DashboardServicesState) _then;

/// Create a copy of DashboardServicesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ourServicesLoadingStateStatus = null,Object? servicesList = null,Object? servicesErrorMessage = freezed,}) {
  return _then(_self.copyWith(
ourServicesLoadingStateStatus: null == ourServicesLoadingStateStatus ? _self.ourServicesLoadingStateStatus : ourServicesLoadingStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,servicesList: null == servicesList ? _self.servicesList : servicesList // ignore: cast_nullable_to_non_nullable
as List<OurServiceEntity>,servicesErrorMessage: freezed == servicesErrorMessage ? _self.servicesErrorMessage : servicesErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardServicesState].
extension DashboardServicesStatePatterns on DashboardServicesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardServicesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardServicesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardServicesState value)  $default,){
final _that = this;
switch (_that) {
case _DashboardServicesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardServicesState value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardServicesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StateStatus ourServicesLoadingStateStatus,  List<OurServiceEntity> servicesList,  String? servicesErrorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardServicesState() when $default != null:
return $default(_that.ourServicesLoadingStateStatus,_that.servicesList,_that.servicesErrorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StateStatus ourServicesLoadingStateStatus,  List<OurServiceEntity> servicesList,  String? servicesErrorMessage)  $default,) {final _that = this;
switch (_that) {
case _DashboardServicesState():
return $default(_that.ourServicesLoadingStateStatus,_that.servicesList,_that.servicesErrorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StateStatus ourServicesLoadingStateStatus,  List<OurServiceEntity> servicesList,  String? servicesErrorMessage)?  $default,) {final _that = this;
switch (_that) {
case _DashboardServicesState() when $default != null:
return $default(_that.ourServicesLoadingStateStatus,_that.servicesList,_that.servicesErrorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardServicesState implements DashboardServicesState {
  const _DashboardServicesState({this.ourServicesLoadingStateStatus = StateStatus.idle, final  List<OurServiceEntity> servicesList = const [], this.servicesErrorMessage}): _servicesList = servicesList;
  

// Loading status
@override@JsonKey() final  StateStatus ourServicesLoadingStateStatus;
// Data
 final  List<OurServiceEntity> _servicesList;
// Data
@override@JsonKey() List<OurServiceEntity> get servicesList {
  if (_servicesList is EqualUnmodifiableListView) return _servicesList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_servicesList);
}

@override final  String? servicesErrorMessage;

/// Create a copy of DashboardServicesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardServicesStateCopyWith<_DashboardServicesState> get copyWith => __$DashboardServicesStateCopyWithImpl<_DashboardServicesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardServicesState&&(identical(other.ourServicesLoadingStateStatus, ourServicesLoadingStateStatus) || other.ourServicesLoadingStateStatus == ourServicesLoadingStateStatus)&&const DeepCollectionEquality().equals(other._servicesList, _servicesList)&&(identical(other.servicesErrorMessage, servicesErrorMessage) || other.servicesErrorMessage == servicesErrorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,ourServicesLoadingStateStatus,const DeepCollectionEquality().hash(_servicesList),servicesErrorMessage);

@override
String toString() {
  return 'DashboardServicesState(ourServicesLoadingStateStatus: $ourServicesLoadingStateStatus, servicesList: $servicesList, servicesErrorMessage: $servicesErrorMessage)';
}


}

/// @nodoc
abstract mixin class _$DashboardServicesStateCopyWith<$Res> implements $DashboardServicesStateCopyWith<$Res> {
  factory _$DashboardServicesStateCopyWith(_DashboardServicesState value, $Res Function(_DashboardServicesState) _then) = __$DashboardServicesStateCopyWithImpl;
@override @useResult
$Res call({
 StateStatus ourServicesLoadingStateStatus, List<OurServiceEntity> servicesList, String? servicesErrorMessage
});




}
/// @nodoc
class __$DashboardServicesStateCopyWithImpl<$Res>
    implements _$DashboardServicesStateCopyWith<$Res> {
  __$DashboardServicesStateCopyWithImpl(this._self, this._then);

  final _DashboardServicesState _self;
  final $Res Function(_DashboardServicesState) _then;

/// Create a copy of DashboardServicesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ourServicesLoadingStateStatus = null,Object? servicesList = null,Object? servicesErrorMessage = freezed,}) {
  return _then(_DashboardServicesState(
ourServicesLoadingStateStatus: null == ourServicesLoadingStateStatus ? _self.ourServicesLoadingStateStatus : ourServicesLoadingStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,servicesList: null == servicesList ? _self._servicesList : servicesList // ignore: cast_nullable_to_non_nullable
as List<OurServiceEntity>,servicesErrorMessage: freezed == servicesErrorMessage ? _self.servicesErrorMessage : servicesErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
