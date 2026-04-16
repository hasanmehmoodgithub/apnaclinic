// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_support_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CustomerSupportState {

 StateStatus get loadingStateStatus; CustomerSupportEntity? get content; String? get errorMessage;
/// Create a copy of CustomerSupportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerSupportStateCopyWith<CustomerSupportState> get copyWith => _$CustomerSupportStateCopyWithImpl<CustomerSupportState>(this as CustomerSupportState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerSupportState&&(identical(other.loadingStateStatus, loadingStateStatus) || other.loadingStateStatus == loadingStateStatus)&&(identical(other.content, content) || other.content == content)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,loadingStateStatus,content,errorMessage);

@override
String toString() {
  return 'CustomerSupportState(loadingStateStatus: $loadingStateStatus, content: $content, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $CustomerSupportStateCopyWith<$Res>  {
  factory $CustomerSupportStateCopyWith(CustomerSupportState value, $Res Function(CustomerSupportState) _then) = _$CustomerSupportStateCopyWithImpl;
@useResult
$Res call({
 StateStatus loadingStateStatus, CustomerSupportEntity? content, String? errorMessage
});




}
/// @nodoc
class _$CustomerSupportStateCopyWithImpl<$Res>
    implements $CustomerSupportStateCopyWith<$Res> {
  _$CustomerSupportStateCopyWithImpl(this._self, this._then);

  final CustomerSupportState _self;
  final $Res Function(CustomerSupportState) _then;

/// Create a copy of CustomerSupportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loadingStateStatus = null,Object? content = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
loadingStateStatus: null == loadingStateStatus ? _self.loadingStateStatus : loadingStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as CustomerSupportEntity?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerSupportState].
extension CustomerSupportStatePatterns on CustomerSupportState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerSupportState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerSupportState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerSupportState value)  $default,){
final _that = this;
switch (_that) {
case _CustomerSupportState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerSupportState value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerSupportState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StateStatus loadingStateStatus,  CustomerSupportEntity? content,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerSupportState() when $default != null:
return $default(_that.loadingStateStatus,_that.content,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StateStatus loadingStateStatus,  CustomerSupportEntity? content,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _CustomerSupportState():
return $default(_that.loadingStateStatus,_that.content,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StateStatus loadingStateStatus,  CustomerSupportEntity? content,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _CustomerSupportState() when $default != null:
return $default(_that.loadingStateStatus,_that.content,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _CustomerSupportState implements CustomerSupportState {
  const _CustomerSupportState({this.loadingStateStatus = StateStatus.idle, this.content, this.errorMessage});
  

@override@JsonKey() final  StateStatus loadingStateStatus;
@override final  CustomerSupportEntity? content;
@override final  String? errorMessage;

/// Create a copy of CustomerSupportState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerSupportStateCopyWith<_CustomerSupportState> get copyWith => __$CustomerSupportStateCopyWithImpl<_CustomerSupportState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerSupportState&&(identical(other.loadingStateStatus, loadingStateStatus) || other.loadingStateStatus == loadingStateStatus)&&(identical(other.content, content) || other.content == content)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,loadingStateStatus,content,errorMessage);

@override
String toString() {
  return 'CustomerSupportState(loadingStateStatus: $loadingStateStatus, content: $content, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$CustomerSupportStateCopyWith<$Res> implements $CustomerSupportStateCopyWith<$Res> {
  factory _$CustomerSupportStateCopyWith(_CustomerSupportState value, $Res Function(_CustomerSupportState) _then) = __$CustomerSupportStateCopyWithImpl;
@override @useResult
$Res call({
 StateStatus loadingStateStatus, CustomerSupportEntity? content, String? errorMessage
});




}
/// @nodoc
class __$CustomerSupportStateCopyWithImpl<$Res>
    implements _$CustomerSupportStateCopyWith<$Res> {
  __$CustomerSupportStateCopyWithImpl(this._self, this._then);

  final _CustomerSupportState _self;
  final $Res Function(_CustomerSupportState) _then;

/// Create a copy of CustomerSupportState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loadingStateStatus = null,Object? content = freezed,Object? errorMessage = freezed,}) {
  return _then(_CustomerSupportState(
loadingStateStatus: null == loadingStateStatus ? _self.loadingStateStatus : loadingStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as CustomerSupportEntity?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
