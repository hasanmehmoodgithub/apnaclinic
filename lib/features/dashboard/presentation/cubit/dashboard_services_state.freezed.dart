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
 StateStatus get ourServicesLoadingStateStatus; StateStatus get promotionalBannerLoadingStateStatus; StateStatus get appVersionLoadingStateStatus;/// Incremented after a successful user-profile sync so the home header can rebuild.
 int get profileSyncNonce;// Data
 List<OurServiceEntity> get servicesList; String? get servicesErrorMessage; String? get proBannerUrl; PromotionalBannerEntity? get promotionalBanner; String? get promotionalBannerErrorMessage; AppUpdatePromptEntity? get appUpdatePrompt;
/// Create a copy of DashboardServicesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardServicesStateCopyWith<DashboardServicesState> get copyWith => _$DashboardServicesStateCopyWithImpl<DashboardServicesState>(this as DashboardServicesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardServicesState&&(identical(other.ourServicesLoadingStateStatus, ourServicesLoadingStateStatus) || other.ourServicesLoadingStateStatus == ourServicesLoadingStateStatus)&&(identical(other.promotionalBannerLoadingStateStatus, promotionalBannerLoadingStateStatus) || other.promotionalBannerLoadingStateStatus == promotionalBannerLoadingStateStatus)&&(identical(other.appVersionLoadingStateStatus, appVersionLoadingStateStatus) || other.appVersionLoadingStateStatus == appVersionLoadingStateStatus)&&(identical(other.profileSyncNonce, profileSyncNonce) || other.profileSyncNonce == profileSyncNonce)&&const DeepCollectionEquality().equals(other.servicesList, servicesList)&&(identical(other.servicesErrorMessage, servicesErrorMessage) || other.servicesErrorMessage == servicesErrorMessage)&&(identical(other.proBannerUrl, proBannerUrl) || other.proBannerUrl == proBannerUrl)&&(identical(other.promotionalBanner, promotionalBanner) || other.promotionalBanner == promotionalBanner)&&(identical(other.promotionalBannerErrorMessage, promotionalBannerErrorMessage) || other.promotionalBannerErrorMessage == promotionalBannerErrorMessage)&&(identical(other.appUpdatePrompt, appUpdatePrompt) || other.appUpdatePrompt == appUpdatePrompt));
}


@override
int get hashCode => Object.hash(runtimeType,ourServicesLoadingStateStatus,promotionalBannerLoadingStateStatus,appVersionLoadingStateStatus,profileSyncNonce,const DeepCollectionEquality().hash(servicesList),servicesErrorMessage,proBannerUrl,promotionalBanner,promotionalBannerErrorMessage,appUpdatePrompt);

@override
String toString() {
  return 'DashboardServicesState(ourServicesLoadingStateStatus: $ourServicesLoadingStateStatus, promotionalBannerLoadingStateStatus: $promotionalBannerLoadingStateStatus, appVersionLoadingStateStatus: $appVersionLoadingStateStatus, profileSyncNonce: $profileSyncNonce, servicesList: $servicesList, servicesErrorMessage: $servicesErrorMessage, proBannerUrl: $proBannerUrl, promotionalBanner: $promotionalBanner, promotionalBannerErrorMessage: $promotionalBannerErrorMessage, appUpdatePrompt: $appUpdatePrompt)';
}


}

/// @nodoc
abstract mixin class $DashboardServicesStateCopyWith<$Res>  {
  factory $DashboardServicesStateCopyWith(DashboardServicesState value, $Res Function(DashboardServicesState) _then) = _$DashboardServicesStateCopyWithImpl;
@useResult
$Res call({
 StateStatus ourServicesLoadingStateStatus, StateStatus promotionalBannerLoadingStateStatus, StateStatus appVersionLoadingStateStatus, int profileSyncNonce, List<OurServiceEntity> servicesList, String? servicesErrorMessage, String? proBannerUrl, PromotionalBannerEntity? promotionalBanner, String? promotionalBannerErrorMessage, AppUpdatePromptEntity? appUpdatePrompt
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
@pragma('vm:prefer-inline') @override $Res call({Object? ourServicesLoadingStateStatus = null,Object? promotionalBannerLoadingStateStatus = null,Object? appVersionLoadingStateStatus = null,Object? profileSyncNonce = null,Object? servicesList = null,Object? servicesErrorMessage = freezed,Object? proBannerUrl = freezed,Object? promotionalBanner = freezed,Object? promotionalBannerErrorMessage = freezed,Object? appUpdatePrompt = freezed,}) {
  return _then(_self.copyWith(
ourServicesLoadingStateStatus: null == ourServicesLoadingStateStatus ? _self.ourServicesLoadingStateStatus : ourServicesLoadingStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,promotionalBannerLoadingStateStatus: null == promotionalBannerLoadingStateStatus ? _self.promotionalBannerLoadingStateStatus : promotionalBannerLoadingStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,appVersionLoadingStateStatus: null == appVersionLoadingStateStatus ? _self.appVersionLoadingStateStatus : appVersionLoadingStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,profileSyncNonce: null == profileSyncNonce ? _self.profileSyncNonce : profileSyncNonce // ignore: cast_nullable_to_non_nullable
as int,servicesList: null == servicesList ? _self.servicesList : servicesList // ignore: cast_nullable_to_non_nullable
as List<OurServiceEntity>,servicesErrorMessage: freezed == servicesErrorMessage ? _self.servicesErrorMessage : servicesErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,proBannerUrl: freezed == proBannerUrl ? _self.proBannerUrl : proBannerUrl // ignore: cast_nullable_to_non_nullable
as String?,promotionalBanner: freezed == promotionalBanner ? _self.promotionalBanner : promotionalBanner // ignore: cast_nullable_to_non_nullable
as PromotionalBannerEntity?,promotionalBannerErrorMessage: freezed == promotionalBannerErrorMessage ? _self.promotionalBannerErrorMessage : promotionalBannerErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,appUpdatePrompt: freezed == appUpdatePrompt ? _self.appUpdatePrompt : appUpdatePrompt // ignore: cast_nullable_to_non_nullable
as AppUpdatePromptEntity?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StateStatus ourServicesLoadingStateStatus,  StateStatus promotionalBannerLoadingStateStatus,  StateStatus appVersionLoadingStateStatus,  int profileSyncNonce,  List<OurServiceEntity> servicesList,  String? servicesErrorMessage,  String? proBannerUrl,  PromotionalBannerEntity? promotionalBanner,  String? promotionalBannerErrorMessage,  AppUpdatePromptEntity? appUpdatePrompt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardServicesState() when $default != null:
return $default(_that.ourServicesLoadingStateStatus,_that.promotionalBannerLoadingStateStatus,_that.appVersionLoadingStateStatus,_that.profileSyncNonce,_that.servicesList,_that.servicesErrorMessage,_that.proBannerUrl,_that.promotionalBanner,_that.promotionalBannerErrorMessage,_that.appUpdatePrompt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StateStatus ourServicesLoadingStateStatus,  StateStatus promotionalBannerLoadingStateStatus,  StateStatus appVersionLoadingStateStatus,  int profileSyncNonce,  List<OurServiceEntity> servicesList,  String? servicesErrorMessage,  String? proBannerUrl,  PromotionalBannerEntity? promotionalBanner,  String? promotionalBannerErrorMessage,  AppUpdatePromptEntity? appUpdatePrompt)  $default,) {final _that = this;
switch (_that) {
case _DashboardServicesState():
return $default(_that.ourServicesLoadingStateStatus,_that.promotionalBannerLoadingStateStatus,_that.appVersionLoadingStateStatus,_that.profileSyncNonce,_that.servicesList,_that.servicesErrorMessage,_that.proBannerUrl,_that.promotionalBanner,_that.promotionalBannerErrorMessage,_that.appUpdatePrompt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StateStatus ourServicesLoadingStateStatus,  StateStatus promotionalBannerLoadingStateStatus,  StateStatus appVersionLoadingStateStatus,  int profileSyncNonce,  List<OurServiceEntity> servicesList,  String? servicesErrorMessage,  String? proBannerUrl,  PromotionalBannerEntity? promotionalBanner,  String? promotionalBannerErrorMessage,  AppUpdatePromptEntity? appUpdatePrompt)?  $default,) {final _that = this;
switch (_that) {
case _DashboardServicesState() when $default != null:
return $default(_that.ourServicesLoadingStateStatus,_that.promotionalBannerLoadingStateStatus,_that.appVersionLoadingStateStatus,_that.profileSyncNonce,_that.servicesList,_that.servicesErrorMessage,_that.proBannerUrl,_that.promotionalBanner,_that.promotionalBannerErrorMessage,_that.appUpdatePrompt);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardServicesState implements DashboardServicesState {
  const _DashboardServicesState({this.ourServicesLoadingStateStatus = StateStatus.idle, this.promotionalBannerLoadingStateStatus = StateStatus.idle, this.appVersionLoadingStateStatus = StateStatus.idle, this.profileSyncNonce = 0, final  List<OurServiceEntity> servicesList = const [], this.servicesErrorMessage, this.proBannerUrl, this.promotionalBanner, this.promotionalBannerErrorMessage, this.appUpdatePrompt}): _servicesList = servicesList;
  

// Loading status
@override@JsonKey() final  StateStatus ourServicesLoadingStateStatus;
@override@JsonKey() final  StateStatus promotionalBannerLoadingStateStatus;
@override@JsonKey() final  StateStatus appVersionLoadingStateStatus;
/// Incremented after a successful user-profile sync so the home header can rebuild.
@override@JsonKey() final  int profileSyncNonce;
// Data
 final  List<OurServiceEntity> _servicesList;
// Data
@override@JsonKey() List<OurServiceEntity> get servicesList {
  if (_servicesList is EqualUnmodifiableListView) return _servicesList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_servicesList);
}

@override final  String? servicesErrorMessage;
@override final  String? proBannerUrl;
@override final  PromotionalBannerEntity? promotionalBanner;
@override final  String? promotionalBannerErrorMessage;
@override final  AppUpdatePromptEntity? appUpdatePrompt;

/// Create a copy of DashboardServicesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardServicesStateCopyWith<_DashboardServicesState> get copyWith => __$DashboardServicesStateCopyWithImpl<_DashboardServicesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardServicesState&&(identical(other.ourServicesLoadingStateStatus, ourServicesLoadingStateStatus) || other.ourServicesLoadingStateStatus == ourServicesLoadingStateStatus)&&(identical(other.promotionalBannerLoadingStateStatus, promotionalBannerLoadingStateStatus) || other.promotionalBannerLoadingStateStatus == promotionalBannerLoadingStateStatus)&&(identical(other.appVersionLoadingStateStatus, appVersionLoadingStateStatus) || other.appVersionLoadingStateStatus == appVersionLoadingStateStatus)&&(identical(other.profileSyncNonce, profileSyncNonce) || other.profileSyncNonce == profileSyncNonce)&&const DeepCollectionEquality().equals(other._servicesList, _servicesList)&&(identical(other.servicesErrorMessage, servicesErrorMessage) || other.servicesErrorMessage == servicesErrorMessage)&&(identical(other.proBannerUrl, proBannerUrl) || other.proBannerUrl == proBannerUrl)&&(identical(other.promotionalBanner, promotionalBanner) || other.promotionalBanner == promotionalBanner)&&(identical(other.promotionalBannerErrorMessage, promotionalBannerErrorMessage) || other.promotionalBannerErrorMessage == promotionalBannerErrorMessage)&&(identical(other.appUpdatePrompt, appUpdatePrompt) || other.appUpdatePrompt == appUpdatePrompt));
}


@override
int get hashCode => Object.hash(runtimeType,ourServicesLoadingStateStatus,promotionalBannerLoadingStateStatus,appVersionLoadingStateStatus,profileSyncNonce,const DeepCollectionEquality().hash(_servicesList),servicesErrorMessage,proBannerUrl,promotionalBanner,promotionalBannerErrorMessage,appUpdatePrompt);

@override
String toString() {
  return 'DashboardServicesState(ourServicesLoadingStateStatus: $ourServicesLoadingStateStatus, promotionalBannerLoadingStateStatus: $promotionalBannerLoadingStateStatus, appVersionLoadingStateStatus: $appVersionLoadingStateStatus, profileSyncNonce: $profileSyncNonce, servicesList: $servicesList, servicesErrorMessage: $servicesErrorMessage, proBannerUrl: $proBannerUrl, promotionalBanner: $promotionalBanner, promotionalBannerErrorMessage: $promotionalBannerErrorMessage, appUpdatePrompt: $appUpdatePrompt)';
}


}

/// @nodoc
abstract mixin class _$DashboardServicesStateCopyWith<$Res> implements $DashboardServicesStateCopyWith<$Res> {
  factory _$DashboardServicesStateCopyWith(_DashboardServicesState value, $Res Function(_DashboardServicesState) _then) = __$DashboardServicesStateCopyWithImpl;
@override @useResult
$Res call({
 StateStatus ourServicesLoadingStateStatus, StateStatus promotionalBannerLoadingStateStatus, StateStatus appVersionLoadingStateStatus, int profileSyncNonce, List<OurServiceEntity> servicesList, String? servicesErrorMessage, String? proBannerUrl, PromotionalBannerEntity? promotionalBanner, String? promotionalBannerErrorMessage, AppUpdatePromptEntity? appUpdatePrompt
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
@override @pragma('vm:prefer-inline') $Res call({Object? ourServicesLoadingStateStatus = null,Object? promotionalBannerLoadingStateStatus = null,Object? appVersionLoadingStateStatus = null,Object? profileSyncNonce = null,Object? servicesList = null,Object? servicesErrorMessage = freezed,Object? proBannerUrl = freezed,Object? promotionalBanner = freezed,Object? promotionalBannerErrorMessage = freezed,Object? appUpdatePrompt = freezed,}) {
  return _then(_DashboardServicesState(
ourServicesLoadingStateStatus: null == ourServicesLoadingStateStatus ? _self.ourServicesLoadingStateStatus : ourServicesLoadingStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,promotionalBannerLoadingStateStatus: null == promotionalBannerLoadingStateStatus ? _self.promotionalBannerLoadingStateStatus : promotionalBannerLoadingStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,appVersionLoadingStateStatus: null == appVersionLoadingStateStatus ? _self.appVersionLoadingStateStatus : appVersionLoadingStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,profileSyncNonce: null == profileSyncNonce ? _self.profileSyncNonce : profileSyncNonce // ignore: cast_nullable_to_non_nullable
as int,servicesList: null == servicesList ? _self._servicesList : servicesList // ignore: cast_nullable_to_non_nullable
as List<OurServiceEntity>,servicesErrorMessage: freezed == servicesErrorMessage ? _self.servicesErrorMessage : servicesErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,proBannerUrl: freezed == proBannerUrl ? _self.proBannerUrl : proBannerUrl // ignore: cast_nullable_to_non_nullable
as String?,promotionalBanner: freezed == promotionalBanner ? _self.promotionalBanner : promotionalBanner // ignore: cast_nullable_to_non_nullable
as PromotionalBannerEntity?,promotionalBannerErrorMessage: freezed == promotionalBannerErrorMessage ? _self.promotionalBannerErrorMessage : promotionalBannerErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,appUpdatePrompt: freezed == appUpdatePrompt ? _self.appUpdatePrompt : appUpdatePrompt // ignore: cast_nullable_to_non_nullable
as AppUpdatePromptEntity?,
  ));
}


}

// dart format on
