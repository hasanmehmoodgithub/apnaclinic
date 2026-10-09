// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pro_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProState {

 StateStatus get loadingStateStatus; ProCatalogEntity? get catalog; String? get selectedPlanId; String? get errorMessage; StateStatus get subscribeStateStatus; String? get subscribeErrorMessage;
/// Create a copy of ProState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProStateCopyWith<ProState> get copyWith => _$ProStateCopyWithImpl<ProState>(this as ProState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProState&&(identical(other.loadingStateStatus, loadingStateStatus) || other.loadingStateStatus == loadingStateStatus)&&(identical(other.catalog, catalog) || other.catalog == catalog)&&(identical(other.selectedPlanId, selectedPlanId) || other.selectedPlanId == selectedPlanId)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.subscribeStateStatus, subscribeStateStatus) || other.subscribeStateStatus == subscribeStateStatus)&&(identical(other.subscribeErrorMessage, subscribeErrorMessage) || other.subscribeErrorMessage == subscribeErrorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,loadingStateStatus,catalog,selectedPlanId,errorMessage,subscribeStateStatus,subscribeErrorMessage);

@override
String toString() {
  return 'ProState(loadingStateStatus: $loadingStateStatus, catalog: $catalog, selectedPlanId: $selectedPlanId, errorMessage: $errorMessage, subscribeStateStatus: $subscribeStateStatus, subscribeErrorMessage: $subscribeErrorMessage)';
}


}

/// @nodoc
abstract mixin class $ProStateCopyWith<$Res>  {
  factory $ProStateCopyWith(ProState value, $Res Function(ProState) _then) = _$ProStateCopyWithImpl;
@useResult
$Res call({
 StateStatus loadingStateStatus, ProCatalogEntity? catalog, String? selectedPlanId, String? errorMessage, StateStatus subscribeStateStatus, String? subscribeErrorMessage
});




}
/// @nodoc
class _$ProStateCopyWithImpl<$Res>
    implements $ProStateCopyWith<$Res> {
  _$ProStateCopyWithImpl(this._self, this._then);

  final ProState _self;
  final $Res Function(ProState) _then;

/// Create a copy of ProState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loadingStateStatus = null,Object? catalog = freezed,Object? selectedPlanId = freezed,Object? errorMessage = freezed,Object? subscribeStateStatus = null,Object? subscribeErrorMessage = freezed,}) {
  return _then(_self.copyWith(
loadingStateStatus: null == loadingStateStatus ? _self.loadingStateStatus : loadingStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,catalog: freezed == catalog ? _self.catalog : catalog // ignore: cast_nullable_to_non_nullable
as ProCatalogEntity?,selectedPlanId: freezed == selectedPlanId ? _self.selectedPlanId : selectedPlanId // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,subscribeStateStatus: null == subscribeStateStatus ? _self.subscribeStateStatus : subscribeStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,subscribeErrorMessage: freezed == subscribeErrorMessage ? _self.subscribeErrorMessage : subscribeErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProState].
extension ProStatePatterns on ProState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProState value)  $default,){
final _that = this;
switch (_that) {
case _ProState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProState value)?  $default,){
final _that = this;
switch (_that) {
case _ProState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StateStatus loadingStateStatus,  ProCatalogEntity? catalog,  String? selectedPlanId,  String? errorMessage,  StateStatus subscribeStateStatus,  String? subscribeErrorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProState() when $default != null:
return $default(_that.loadingStateStatus,_that.catalog,_that.selectedPlanId,_that.errorMessage,_that.subscribeStateStatus,_that.subscribeErrorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StateStatus loadingStateStatus,  ProCatalogEntity? catalog,  String? selectedPlanId,  String? errorMessage,  StateStatus subscribeStateStatus,  String? subscribeErrorMessage)  $default,) {final _that = this;
switch (_that) {
case _ProState():
return $default(_that.loadingStateStatus,_that.catalog,_that.selectedPlanId,_that.errorMessage,_that.subscribeStateStatus,_that.subscribeErrorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StateStatus loadingStateStatus,  ProCatalogEntity? catalog,  String? selectedPlanId,  String? errorMessage,  StateStatus subscribeStateStatus,  String? subscribeErrorMessage)?  $default,) {final _that = this;
switch (_that) {
case _ProState() when $default != null:
return $default(_that.loadingStateStatus,_that.catalog,_that.selectedPlanId,_that.errorMessage,_that.subscribeStateStatus,_that.subscribeErrorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _ProState extends ProState {
  const _ProState({this.loadingStateStatus = StateStatus.idle, this.catalog, this.selectedPlanId, this.errorMessage, this.subscribeStateStatus = StateStatus.idle, this.subscribeErrorMessage}): super._();
  

@override@JsonKey() final  StateStatus loadingStateStatus;
@override final  ProCatalogEntity? catalog;
@override final  String? selectedPlanId;
@override final  String? errorMessage;
@override@JsonKey() final  StateStatus subscribeStateStatus;
@override final  String? subscribeErrorMessage;

/// Create a copy of ProState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProStateCopyWith<_ProState> get copyWith => __$ProStateCopyWithImpl<_ProState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProState&&(identical(other.loadingStateStatus, loadingStateStatus) || other.loadingStateStatus == loadingStateStatus)&&(identical(other.catalog, catalog) || other.catalog == catalog)&&(identical(other.selectedPlanId, selectedPlanId) || other.selectedPlanId == selectedPlanId)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.subscribeStateStatus, subscribeStateStatus) || other.subscribeStateStatus == subscribeStateStatus)&&(identical(other.subscribeErrorMessage, subscribeErrorMessage) || other.subscribeErrorMessage == subscribeErrorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,loadingStateStatus,catalog,selectedPlanId,errorMessage,subscribeStateStatus,subscribeErrorMessage);

@override
String toString() {
  return 'ProState(loadingStateStatus: $loadingStateStatus, catalog: $catalog, selectedPlanId: $selectedPlanId, errorMessage: $errorMessage, subscribeStateStatus: $subscribeStateStatus, subscribeErrorMessage: $subscribeErrorMessage)';
}


}

/// @nodoc
abstract mixin class _$ProStateCopyWith<$Res> implements $ProStateCopyWith<$Res> {
  factory _$ProStateCopyWith(_ProState value, $Res Function(_ProState) _then) = __$ProStateCopyWithImpl;
@override @useResult
$Res call({
 StateStatus loadingStateStatus, ProCatalogEntity? catalog, String? selectedPlanId, String? errorMessage, StateStatus subscribeStateStatus, String? subscribeErrorMessage
});




}
/// @nodoc
class __$ProStateCopyWithImpl<$Res>
    implements _$ProStateCopyWith<$Res> {
  __$ProStateCopyWithImpl(this._self, this._then);

  final _ProState _self;
  final $Res Function(_ProState) _then;

/// Create a copy of ProState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loadingStateStatus = null,Object? catalog = freezed,Object? selectedPlanId = freezed,Object? errorMessage = freezed,Object? subscribeStateStatus = null,Object? subscribeErrorMessage = freezed,}) {
  return _then(_ProState(
loadingStateStatus: null == loadingStateStatus ? _self.loadingStateStatus : loadingStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,catalog: freezed == catalog ? _self.catalog : catalog // ignore: cast_nullable_to_non_nullable
as ProCatalogEntity?,selectedPlanId: freezed == selectedPlanId ? _self.selectedPlanId : selectedPlanId // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,subscribeStateStatus: null == subscribeStateStatus ? _self.subscribeStateStatus : subscribeStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,subscribeErrorMessage: freezed == subscribeErrorMessage ? _self.subscribeErrorMessage : subscribeErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
