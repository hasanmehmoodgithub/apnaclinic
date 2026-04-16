// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthState {

 String get phoneNumber; bool get isLoading; String? get errorMessage; int get otpSecondsRemaining; bool get otpRequested; StateStatus get requestOtpLoadingStateStatus; StateStatus get verifyOtpLoadingStateStatus;
/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthStateCopyWith<AuthState> get copyWith => _$AuthStateCopyWithImpl<AuthState>(this as AuthState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.otpSecondsRemaining, otpSecondsRemaining) || other.otpSecondsRemaining == otpSecondsRemaining)&&(identical(other.otpRequested, otpRequested) || other.otpRequested == otpRequested)&&(identical(other.requestOtpLoadingStateStatus, requestOtpLoadingStateStatus) || other.requestOtpLoadingStateStatus == requestOtpLoadingStateStatus)&&(identical(other.verifyOtpLoadingStateStatus, verifyOtpLoadingStateStatus) || other.verifyOtpLoadingStateStatus == verifyOtpLoadingStateStatus));
}


@override
int get hashCode => Object.hash(runtimeType,phoneNumber,isLoading,errorMessage,otpSecondsRemaining,otpRequested,requestOtpLoadingStateStatus,verifyOtpLoadingStateStatus);

@override
String toString() {
  return 'AuthState(phoneNumber: $phoneNumber, isLoading: $isLoading, errorMessage: $errorMessage, otpSecondsRemaining: $otpSecondsRemaining, otpRequested: $otpRequested, requestOtpLoadingStateStatus: $requestOtpLoadingStateStatus, verifyOtpLoadingStateStatus: $verifyOtpLoadingStateStatus)';
}


}

/// @nodoc
abstract mixin class $AuthStateCopyWith<$Res>  {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) _then) = _$AuthStateCopyWithImpl;
@useResult
$Res call({
 String phoneNumber, bool isLoading, String? errorMessage, int otpSecondsRemaining, bool otpRequested, StateStatus requestOtpLoadingStateStatus, StateStatus verifyOtpLoadingStateStatus
});




}
/// @nodoc
class _$AuthStateCopyWithImpl<$Res>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._self, this._then);

  final AuthState _self;
  final $Res Function(AuthState) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phoneNumber = null,Object? isLoading = null,Object? errorMessage = freezed,Object? otpSecondsRemaining = null,Object? otpRequested = null,Object? requestOtpLoadingStateStatus = null,Object? verifyOtpLoadingStateStatus = null,}) {
  return _then(_self.copyWith(
phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,otpSecondsRemaining: null == otpSecondsRemaining ? _self.otpSecondsRemaining : otpSecondsRemaining // ignore: cast_nullable_to_non_nullable
as int,otpRequested: null == otpRequested ? _self.otpRequested : otpRequested // ignore: cast_nullable_to_non_nullable
as bool,requestOtpLoadingStateStatus: null == requestOtpLoadingStateStatus ? _self.requestOtpLoadingStateStatus : requestOtpLoadingStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,verifyOtpLoadingStateStatus: null == verifyOtpLoadingStateStatus ? _self.verifyOtpLoadingStateStatus : verifyOtpLoadingStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthState value)  $default,){
final _that = this;
switch (_that) {
case _AuthState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthState value)?  $default,){
final _that = this;
switch (_that) {
case _AuthState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String phoneNumber,  bool isLoading,  String? errorMessage,  int otpSecondsRemaining,  bool otpRequested,  StateStatus requestOtpLoadingStateStatus,  StateStatus verifyOtpLoadingStateStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthState() when $default != null:
return $default(_that.phoneNumber,_that.isLoading,_that.errorMessage,_that.otpSecondsRemaining,_that.otpRequested,_that.requestOtpLoadingStateStatus,_that.verifyOtpLoadingStateStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String phoneNumber,  bool isLoading,  String? errorMessage,  int otpSecondsRemaining,  bool otpRequested,  StateStatus requestOtpLoadingStateStatus,  StateStatus verifyOtpLoadingStateStatus)  $default,) {final _that = this;
switch (_that) {
case _AuthState():
return $default(_that.phoneNumber,_that.isLoading,_that.errorMessage,_that.otpSecondsRemaining,_that.otpRequested,_that.requestOtpLoadingStateStatus,_that.verifyOtpLoadingStateStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String phoneNumber,  bool isLoading,  String? errorMessage,  int otpSecondsRemaining,  bool otpRequested,  StateStatus requestOtpLoadingStateStatus,  StateStatus verifyOtpLoadingStateStatus)?  $default,) {final _that = this;
switch (_that) {
case _AuthState() when $default != null:
return $default(_that.phoneNumber,_that.isLoading,_that.errorMessage,_that.otpSecondsRemaining,_that.otpRequested,_that.requestOtpLoadingStateStatus,_that.verifyOtpLoadingStateStatus);case _:
  return null;

}
}

}

/// @nodoc


class _AuthState implements AuthState {
  const _AuthState({this.phoneNumber = '', this.isLoading = false, this.errorMessage, this.otpSecondsRemaining = 30, this.otpRequested = false, this.requestOtpLoadingStateStatus = StateStatus.idle, this.verifyOtpLoadingStateStatus = StateStatus.idle});
  

@override@JsonKey() final  String phoneNumber;
@override@JsonKey() final  bool isLoading;
@override final  String? errorMessage;
@override@JsonKey() final  int otpSecondsRemaining;
@override@JsonKey() final  bool otpRequested;
@override@JsonKey() final  StateStatus requestOtpLoadingStateStatus;
@override@JsonKey() final  StateStatus verifyOtpLoadingStateStatus;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthStateCopyWith<_AuthState> get copyWith => __$AuthStateCopyWithImpl<_AuthState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthState&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.otpSecondsRemaining, otpSecondsRemaining) || other.otpSecondsRemaining == otpSecondsRemaining)&&(identical(other.otpRequested, otpRequested) || other.otpRequested == otpRequested)&&(identical(other.requestOtpLoadingStateStatus, requestOtpLoadingStateStatus) || other.requestOtpLoadingStateStatus == requestOtpLoadingStateStatus)&&(identical(other.verifyOtpLoadingStateStatus, verifyOtpLoadingStateStatus) || other.verifyOtpLoadingStateStatus == verifyOtpLoadingStateStatus));
}


@override
int get hashCode => Object.hash(runtimeType,phoneNumber,isLoading,errorMessage,otpSecondsRemaining,otpRequested,requestOtpLoadingStateStatus,verifyOtpLoadingStateStatus);

@override
String toString() {
  return 'AuthState(phoneNumber: $phoneNumber, isLoading: $isLoading, errorMessage: $errorMessage, otpSecondsRemaining: $otpSecondsRemaining, otpRequested: $otpRequested, requestOtpLoadingStateStatus: $requestOtpLoadingStateStatus, verifyOtpLoadingStateStatus: $verifyOtpLoadingStateStatus)';
}


}

/// @nodoc
abstract mixin class _$AuthStateCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$AuthStateCopyWith(_AuthState value, $Res Function(_AuthState) _then) = __$AuthStateCopyWithImpl;
@override @useResult
$Res call({
 String phoneNumber, bool isLoading, String? errorMessage, int otpSecondsRemaining, bool otpRequested, StateStatus requestOtpLoadingStateStatus, StateStatus verifyOtpLoadingStateStatus
});




}
/// @nodoc
class __$AuthStateCopyWithImpl<$Res>
    implements _$AuthStateCopyWith<$Res> {
  __$AuthStateCopyWithImpl(this._self, this._then);

  final _AuthState _self;
  final $Res Function(_AuthState) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phoneNumber = null,Object? isLoading = null,Object? errorMessage = freezed,Object? otpSecondsRemaining = null,Object? otpRequested = null,Object? requestOtpLoadingStateStatus = null,Object? verifyOtpLoadingStateStatus = null,}) {
  return _then(_AuthState(
phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,otpSecondsRemaining: null == otpSecondsRemaining ? _self.otpSecondsRemaining : otpSecondsRemaining // ignore: cast_nullable_to_non_nullable
as int,otpRequested: null == otpRequested ? _self.otpRequested : otpRequested // ignore: cast_nullable_to_non_nullable
as bool,requestOtpLoadingStateStatus: null == requestOtpLoadingStateStatus ? _self.requestOtpLoadingStateStatus : requestOtpLoadingStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,verifyOtpLoadingStateStatus: null == verifyOtpLoadingStateStatus ? _self.verifyOtpLoadingStateStatus : verifyOtpLoadingStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,
  ));
}


}

// dart format on
