// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'instant_doctor_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InstantDoctorState {

 StateStatus get loadingStateStatus; InstantDoctorEntity? get content; String? get errorMessage; bool get isOpeningApp;
/// Create a copy of InstantDoctorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstantDoctorStateCopyWith<InstantDoctorState> get copyWith => _$InstantDoctorStateCopyWithImpl<InstantDoctorState>(this as InstantDoctorState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstantDoctorState&&(identical(other.loadingStateStatus, loadingStateStatus) || other.loadingStateStatus == loadingStateStatus)&&(identical(other.content, content) || other.content == content)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isOpeningApp, isOpeningApp) || other.isOpeningApp == isOpeningApp));
}


@override
int get hashCode => Object.hash(runtimeType,loadingStateStatus,content,errorMessage,isOpeningApp);

@override
String toString() {
  return 'InstantDoctorState(loadingStateStatus: $loadingStateStatus, content: $content, errorMessage: $errorMessage, isOpeningApp: $isOpeningApp)';
}


}

/// @nodoc
abstract mixin class $InstantDoctorStateCopyWith<$Res>  {
  factory $InstantDoctorStateCopyWith(InstantDoctorState value, $Res Function(InstantDoctorState) _then) = _$InstantDoctorStateCopyWithImpl;
@useResult
$Res call({
 StateStatus loadingStateStatus, InstantDoctorEntity? content, String? errorMessage, bool isOpeningApp
});




}
/// @nodoc
class _$InstantDoctorStateCopyWithImpl<$Res>
    implements $InstantDoctorStateCopyWith<$Res> {
  _$InstantDoctorStateCopyWithImpl(this._self, this._then);

  final InstantDoctorState _self;
  final $Res Function(InstantDoctorState) _then;

/// Create a copy of InstantDoctorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loadingStateStatus = null,Object? content = freezed,Object? errorMessage = freezed,Object? isOpeningApp = null,}) {
  return _then(_self.copyWith(
loadingStateStatus: null == loadingStateStatus ? _self.loadingStateStatus : loadingStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as InstantDoctorEntity?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,isOpeningApp: null == isOpeningApp ? _self.isOpeningApp : isOpeningApp // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [InstantDoctorState].
extension InstantDoctorStatePatterns on InstantDoctorState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InstantDoctorState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InstantDoctorState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InstantDoctorState value)  $default,){
final _that = this;
switch (_that) {
case _InstantDoctorState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InstantDoctorState value)?  $default,){
final _that = this;
switch (_that) {
case _InstantDoctorState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StateStatus loadingStateStatus,  InstantDoctorEntity? content,  String? errorMessage,  bool isOpeningApp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InstantDoctorState() when $default != null:
return $default(_that.loadingStateStatus,_that.content,_that.errorMessage,_that.isOpeningApp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StateStatus loadingStateStatus,  InstantDoctorEntity? content,  String? errorMessage,  bool isOpeningApp)  $default,) {final _that = this;
switch (_that) {
case _InstantDoctorState():
return $default(_that.loadingStateStatus,_that.content,_that.errorMessage,_that.isOpeningApp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StateStatus loadingStateStatus,  InstantDoctorEntity? content,  String? errorMessage,  bool isOpeningApp)?  $default,) {final _that = this;
switch (_that) {
case _InstantDoctorState() when $default != null:
return $default(_that.loadingStateStatus,_that.content,_that.errorMessage,_that.isOpeningApp);case _:
  return null;

}
}

}

/// @nodoc


class _InstantDoctorState implements InstantDoctorState {
  const _InstantDoctorState({this.loadingStateStatus = StateStatus.idle, this.content, this.errorMessage, this.isOpeningApp = false});
  

@override@JsonKey() final  StateStatus loadingStateStatus;
@override final  InstantDoctorEntity? content;
@override final  String? errorMessage;
@override@JsonKey() final  bool isOpeningApp;

/// Create a copy of InstantDoctorState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstantDoctorStateCopyWith<_InstantDoctorState> get copyWith => __$InstantDoctorStateCopyWithImpl<_InstantDoctorState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstantDoctorState&&(identical(other.loadingStateStatus, loadingStateStatus) || other.loadingStateStatus == loadingStateStatus)&&(identical(other.content, content) || other.content == content)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isOpeningApp, isOpeningApp) || other.isOpeningApp == isOpeningApp));
}


@override
int get hashCode => Object.hash(runtimeType,loadingStateStatus,content,errorMessage,isOpeningApp);

@override
String toString() {
  return 'InstantDoctorState(loadingStateStatus: $loadingStateStatus, content: $content, errorMessage: $errorMessage, isOpeningApp: $isOpeningApp)';
}


}

/// @nodoc
abstract mixin class _$InstantDoctorStateCopyWith<$Res> implements $InstantDoctorStateCopyWith<$Res> {
  factory _$InstantDoctorStateCopyWith(_InstantDoctorState value, $Res Function(_InstantDoctorState) _then) = __$InstantDoctorStateCopyWithImpl;
@override @useResult
$Res call({
 StateStatus loadingStateStatus, InstantDoctorEntity? content, String? errorMessage, bool isOpeningApp
});




}
/// @nodoc
class __$InstantDoctorStateCopyWithImpl<$Res>
    implements _$InstantDoctorStateCopyWith<$Res> {
  __$InstantDoctorStateCopyWithImpl(this._self, this._then);

  final _InstantDoctorState _self;
  final $Res Function(_InstantDoctorState) _then;

/// Create a copy of InstantDoctorState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loadingStateStatus = null,Object? content = freezed,Object? errorMessage = freezed,Object? isOpeningApp = null,}) {
  return _then(_InstantDoctorState(
loadingStateStatus: null == loadingStateStatus ? _self.loadingStateStatus : loadingStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as InstantDoctorEntity?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,isOpeningApp: null == isOpeningApp ? _self.isOpeningApp : isOpeningApp // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
