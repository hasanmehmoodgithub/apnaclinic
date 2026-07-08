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

 StateStatus get loadingStateStatus; List<InstantDoctorProviderEntity> get providers; String? get errorMessage; int? get openingProviderId; int? get cancellingProviderId; InstantDoctorProviderEntity? get activeOtpProvider; String? get subscriptionUuid; StateStatus get sendOtpStatus; StateStatus get verifyOtpStatus; int get otpSecondsRemaining; String? get otpErrorMessage;
/// Create a copy of InstantDoctorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstantDoctorStateCopyWith<InstantDoctorState> get copyWith => _$InstantDoctorStateCopyWithImpl<InstantDoctorState>(this as InstantDoctorState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstantDoctorState&&(identical(other.loadingStateStatus, loadingStateStatus) || other.loadingStateStatus == loadingStateStatus)&&const DeepCollectionEquality().equals(other.providers, providers)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.openingProviderId, openingProviderId) || other.openingProviderId == openingProviderId)&&(identical(other.cancellingProviderId, cancellingProviderId) || other.cancellingProviderId == cancellingProviderId)&&(identical(other.activeOtpProvider, activeOtpProvider) || other.activeOtpProvider == activeOtpProvider)&&(identical(other.subscriptionUuid, subscriptionUuid) || other.subscriptionUuid == subscriptionUuid)&&(identical(other.sendOtpStatus, sendOtpStatus) || other.sendOtpStatus == sendOtpStatus)&&(identical(other.verifyOtpStatus, verifyOtpStatus) || other.verifyOtpStatus == verifyOtpStatus)&&(identical(other.otpSecondsRemaining, otpSecondsRemaining) || other.otpSecondsRemaining == otpSecondsRemaining)&&(identical(other.otpErrorMessage, otpErrorMessage) || other.otpErrorMessage == otpErrorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,loadingStateStatus,const DeepCollectionEquality().hash(providers),errorMessage,openingProviderId,cancellingProviderId,activeOtpProvider,subscriptionUuid,sendOtpStatus,verifyOtpStatus,otpSecondsRemaining,otpErrorMessage);

@override
String toString() {
  return 'InstantDoctorState(loadingStateStatus: $loadingStateStatus, providers: $providers, errorMessage: $errorMessage, openingProviderId: $openingProviderId, cancellingProviderId: $cancellingProviderId, activeOtpProvider: $activeOtpProvider, subscriptionUuid: $subscriptionUuid, sendOtpStatus: $sendOtpStatus, verifyOtpStatus: $verifyOtpStatus, otpSecondsRemaining: $otpSecondsRemaining, otpErrorMessage: $otpErrorMessage)';
}


}

/// @nodoc
abstract mixin class $InstantDoctorStateCopyWith<$Res>  {
  factory $InstantDoctorStateCopyWith(InstantDoctorState value, $Res Function(InstantDoctorState) _then) = _$InstantDoctorStateCopyWithImpl;
@useResult
$Res call({
 StateStatus loadingStateStatus, List<InstantDoctorProviderEntity> providers, String? errorMessage, int? openingProviderId, int? cancellingProviderId, InstantDoctorProviderEntity? activeOtpProvider, String? subscriptionUuid, StateStatus sendOtpStatus, StateStatus verifyOtpStatus, int otpSecondsRemaining, String? otpErrorMessage
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
@pragma('vm:prefer-inline') @override $Res call({Object? loadingStateStatus = null,Object? providers = null,Object? errorMessage = freezed,Object? openingProviderId = freezed,Object? cancellingProviderId = freezed,Object? activeOtpProvider = freezed,Object? subscriptionUuid = freezed,Object? sendOtpStatus = null,Object? verifyOtpStatus = null,Object? otpSecondsRemaining = null,Object? otpErrorMessage = freezed,}) {
  return _then(_self.copyWith(
loadingStateStatus: null == loadingStateStatus ? _self.loadingStateStatus : loadingStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,providers: null == providers ? _self.providers : providers // ignore: cast_nullable_to_non_nullable
as List<InstantDoctorProviderEntity>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,openingProviderId: freezed == openingProviderId ? _self.openingProviderId : openingProviderId // ignore: cast_nullable_to_non_nullable
as int?,cancellingProviderId: freezed == cancellingProviderId ? _self.cancellingProviderId : cancellingProviderId // ignore: cast_nullable_to_non_nullable
as int?,activeOtpProvider: freezed == activeOtpProvider ? _self.activeOtpProvider : activeOtpProvider // ignore: cast_nullable_to_non_nullable
as InstantDoctorProviderEntity?,subscriptionUuid: freezed == subscriptionUuid ? _self.subscriptionUuid : subscriptionUuid // ignore: cast_nullable_to_non_nullable
as String?,sendOtpStatus: null == sendOtpStatus ? _self.sendOtpStatus : sendOtpStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,verifyOtpStatus: null == verifyOtpStatus ? _self.verifyOtpStatus : verifyOtpStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,otpSecondsRemaining: null == otpSecondsRemaining ? _self.otpSecondsRemaining : otpSecondsRemaining // ignore: cast_nullable_to_non_nullable
as int,otpErrorMessage: freezed == otpErrorMessage ? _self.otpErrorMessage : otpErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StateStatus loadingStateStatus,  List<InstantDoctorProviderEntity> providers,  String? errorMessage,  int? openingProviderId,  int? cancellingProviderId,  InstantDoctorProviderEntity? activeOtpProvider,  String? subscriptionUuid,  StateStatus sendOtpStatus,  StateStatus verifyOtpStatus,  int otpSecondsRemaining,  String? otpErrorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InstantDoctorState() when $default != null:
return $default(_that.loadingStateStatus,_that.providers,_that.errorMessage,_that.openingProviderId,_that.cancellingProviderId,_that.activeOtpProvider,_that.subscriptionUuid,_that.sendOtpStatus,_that.verifyOtpStatus,_that.otpSecondsRemaining,_that.otpErrorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StateStatus loadingStateStatus,  List<InstantDoctorProviderEntity> providers,  String? errorMessage,  int? openingProviderId,  int? cancellingProviderId,  InstantDoctorProviderEntity? activeOtpProvider,  String? subscriptionUuid,  StateStatus sendOtpStatus,  StateStatus verifyOtpStatus,  int otpSecondsRemaining,  String? otpErrorMessage)  $default,) {final _that = this;
switch (_that) {
case _InstantDoctorState():
return $default(_that.loadingStateStatus,_that.providers,_that.errorMessage,_that.openingProviderId,_that.cancellingProviderId,_that.activeOtpProvider,_that.subscriptionUuid,_that.sendOtpStatus,_that.verifyOtpStatus,_that.otpSecondsRemaining,_that.otpErrorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StateStatus loadingStateStatus,  List<InstantDoctorProviderEntity> providers,  String? errorMessage,  int? openingProviderId,  int? cancellingProviderId,  InstantDoctorProviderEntity? activeOtpProvider,  String? subscriptionUuid,  StateStatus sendOtpStatus,  StateStatus verifyOtpStatus,  int otpSecondsRemaining,  String? otpErrorMessage)?  $default,) {final _that = this;
switch (_that) {
case _InstantDoctorState() when $default != null:
return $default(_that.loadingStateStatus,_that.providers,_that.errorMessage,_that.openingProviderId,_that.cancellingProviderId,_that.activeOtpProvider,_that.subscriptionUuid,_that.sendOtpStatus,_that.verifyOtpStatus,_that.otpSecondsRemaining,_that.otpErrorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _InstantDoctorState extends InstantDoctorState {
  const _InstantDoctorState({this.loadingStateStatus = StateStatus.idle, final  List<InstantDoctorProviderEntity> providers = const <InstantDoctorProviderEntity>[], this.errorMessage, this.openingProviderId, this.cancellingProviderId, this.activeOtpProvider, this.subscriptionUuid, this.sendOtpStatus = StateStatus.idle, this.verifyOtpStatus = StateStatus.idle, this.otpSecondsRemaining = 30, this.otpErrorMessage}): _providers = providers,super._();
  

@override@JsonKey() final  StateStatus loadingStateStatus;
 final  List<InstantDoctorProviderEntity> _providers;
@override@JsonKey() List<InstantDoctorProviderEntity> get providers {
  if (_providers is EqualUnmodifiableListView) return _providers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_providers);
}

@override final  String? errorMessage;
@override final  int? openingProviderId;
@override final  int? cancellingProviderId;
@override final  InstantDoctorProviderEntity? activeOtpProvider;
@override final  String? subscriptionUuid;
@override@JsonKey() final  StateStatus sendOtpStatus;
@override@JsonKey() final  StateStatus verifyOtpStatus;
@override@JsonKey() final  int otpSecondsRemaining;
@override final  String? otpErrorMessage;

/// Create a copy of InstantDoctorState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstantDoctorStateCopyWith<_InstantDoctorState> get copyWith => __$InstantDoctorStateCopyWithImpl<_InstantDoctorState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstantDoctorState&&(identical(other.loadingStateStatus, loadingStateStatus) || other.loadingStateStatus == loadingStateStatus)&&const DeepCollectionEquality().equals(other._providers, _providers)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.openingProviderId, openingProviderId) || other.openingProviderId == openingProviderId)&&(identical(other.cancellingProviderId, cancellingProviderId) || other.cancellingProviderId == cancellingProviderId)&&(identical(other.activeOtpProvider, activeOtpProvider) || other.activeOtpProvider == activeOtpProvider)&&(identical(other.subscriptionUuid, subscriptionUuid) || other.subscriptionUuid == subscriptionUuid)&&(identical(other.sendOtpStatus, sendOtpStatus) || other.sendOtpStatus == sendOtpStatus)&&(identical(other.verifyOtpStatus, verifyOtpStatus) || other.verifyOtpStatus == verifyOtpStatus)&&(identical(other.otpSecondsRemaining, otpSecondsRemaining) || other.otpSecondsRemaining == otpSecondsRemaining)&&(identical(other.otpErrorMessage, otpErrorMessage) || other.otpErrorMessage == otpErrorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,loadingStateStatus,const DeepCollectionEquality().hash(_providers),errorMessage,openingProviderId,cancellingProviderId,activeOtpProvider,subscriptionUuid,sendOtpStatus,verifyOtpStatus,otpSecondsRemaining,otpErrorMessage);

@override
String toString() {
  return 'InstantDoctorState(loadingStateStatus: $loadingStateStatus, providers: $providers, errorMessage: $errorMessage, openingProviderId: $openingProviderId, cancellingProviderId: $cancellingProviderId, activeOtpProvider: $activeOtpProvider, subscriptionUuid: $subscriptionUuid, sendOtpStatus: $sendOtpStatus, verifyOtpStatus: $verifyOtpStatus, otpSecondsRemaining: $otpSecondsRemaining, otpErrorMessage: $otpErrorMessage)';
}


}

/// @nodoc
abstract mixin class _$InstantDoctorStateCopyWith<$Res> implements $InstantDoctorStateCopyWith<$Res> {
  factory _$InstantDoctorStateCopyWith(_InstantDoctorState value, $Res Function(_InstantDoctorState) _then) = __$InstantDoctorStateCopyWithImpl;
@override @useResult
$Res call({
 StateStatus loadingStateStatus, List<InstantDoctorProviderEntity> providers, String? errorMessage, int? openingProviderId, int? cancellingProviderId, InstantDoctorProviderEntity? activeOtpProvider, String? subscriptionUuid, StateStatus sendOtpStatus, StateStatus verifyOtpStatus, int otpSecondsRemaining, String? otpErrorMessage
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
@override @pragma('vm:prefer-inline') $Res call({Object? loadingStateStatus = null,Object? providers = null,Object? errorMessage = freezed,Object? openingProviderId = freezed,Object? cancellingProviderId = freezed,Object? activeOtpProvider = freezed,Object? subscriptionUuid = freezed,Object? sendOtpStatus = null,Object? verifyOtpStatus = null,Object? otpSecondsRemaining = null,Object? otpErrorMessage = freezed,}) {
  return _then(_InstantDoctorState(
loadingStateStatus: null == loadingStateStatus ? _self.loadingStateStatus : loadingStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,providers: null == providers ? _self._providers : providers // ignore: cast_nullable_to_non_nullable
as List<InstantDoctorProviderEntity>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,openingProviderId: freezed == openingProviderId ? _self.openingProviderId : openingProviderId // ignore: cast_nullable_to_non_nullable
as int?,cancellingProviderId: freezed == cancellingProviderId ? _self.cancellingProviderId : cancellingProviderId // ignore: cast_nullable_to_non_nullable
as int?,activeOtpProvider: freezed == activeOtpProvider ? _self.activeOtpProvider : activeOtpProvider // ignore: cast_nullable_to_non_nullable
as InstantDoctorProviderEntity?,subscriptionUuid: freezed == subscriptionUuid ? _self.subscriptionUuid : subscriptionUuid // ignore: cast_nullable_to_non_nullable
as String?,sendOtpStatus: null == sendOtpStatus ? _self.sendOtpStatus : sendOtpStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,verifyOtpStatus: null == verifyOtpStatus ? _self.verifyOtpStatus : verifyOtpStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,otpSecondsRemaining: null == otpSecondsRemaining ? _self.otpSecondsRemaining : otpSecondsRemaining // ignore: cast_nullable_to_non_nullable
as int,otpErrorMessage: freezed == otpErrorMessage ? _self.otpErrorMessage : otpErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
