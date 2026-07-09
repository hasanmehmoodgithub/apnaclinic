// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileState {

 StateStatus get accountsStatus; List<AccountItemEntity> get accounts; String? get accountsError; int get profileRevision;
/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileStateCopyWith<ProfileState> get copyWith => _$ProfileStateCopyWithImpl<ProfileState>(this as ProfileState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileState&&(identical(other.accountsStatus, accountsStatus) || other.accountsStatus == accountsStatus)&&const DeepCollectionEquality().equals(other.accounts, accounts)&&(identical(other.accountsError, accountsError) || other.accountsError == accountsError)&&(identical(other.profileRevision, profileRevision) || other.profileRevision == profileRevision));
}


@override
int get hashCode => Object.hash(runtimeType,accountsStatus,const DeepCollectionEquality().hash(accounts),accountsError,profileRevision);

@override
String toString() {
  return 'ProfileState(accountsStatus: $accountsStatus, accounts: $accounts, accountsError: $accountsError, profileRevision: $profileRevision)';
}


}

/// @nodoc
abstract mixin class $ProfileStateCopyWith<$Res>  {
  factory $ProfileStateCopyWith(ProfileState value, $Res Function(ProfileState) _then) = _$ProfileStateCopyWithImpl;
@useResult
$Res call({
 StateStatus accountsStatus, List<AccountItemEntity> accounts, String? accountsError, int profileRevision
});




}
/// @nodoc
class _$ProfileStateCopyWithImpl<$Res>
    implements $ProfileStateCopyWith<$Res> {
  _$ProfileStateCopyWithImpl(this._self, this._then);

  final ProfileState _self;
  final $Res Function(ProfileState) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountsStatus = null,Object? accounts = null,Object? accountsError = freezed,Object? profileRevision = null,}) {
  return _then(_self.copyWith(
accountsStatus: null == accountsStatus ? _self.accountsStatus : accountsStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,accounts: null == accounts ? _self.accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<AccountItemEntity>,accountsError: freezed == accountsError ? _self.accountsError : accountsError // ignore: cast_nullable_to_non_nullable
as String?,profileRevision: null == profileRevision ? _self.profileRevision : profileRevision // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileState].
extension ProfileStatePatterns on ProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileState value)  $default,){
final _that = this;
switch (_that) {
case _ProfileState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileState value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StateStatus accountsStatus,  List<AccountItemEntity> accounts,  String? accountsError,  int profileRevision)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
return $default(_that.accountsStatus,_that.accounts,_that.accountsError,_that.profileRevision);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StateStatus accountsStatus,  List<AccountItemEntity> accounts,  String? accountsError,  int profileRevision)  $default,) {final _that = this;
switch (_that) {
case _ProfileState():
return $default(_that.accountsStatus,_that.accounts,_that.accountsError,_that.profileRevision);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StateStatus accountsStatus,  List<AccountItemEntity> accounts,  String? accountsError,  int profileRevision)?  $default,) {final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
return $default(_that.accountsStatus,_that.accounts,_that.accountsError,_that.profileRevision);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileState implements ProfileState {
  const _ProfileState({this.accountsStatus = StateStatus.loading, final  List<AccountItemEntity> accounts = const <AccountItemEntity>[], this.accountsError, this.profileRevision = 0}): _accounts = accounts;
  

@override@JsonKey() final  StateStatus accountsStatus;
 final  List<AccountItemEntity> _accounts;
@override@JsonKey() List<AccountItemEntity> get accounts {
  if (_accounts is EqualUnmodifiableListView) return _accounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_accounts);
}

@override final  String? accountsError;
@override@JsonKey() final  int profileRevision;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileStateCopyWith<_ProfileState> get copyWith => __$ProfileStateCopyWithImpl<_ProfileState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileState&&(identical(other.accountsStatus, accountsStatus) || other.accountsStatus == accountsStatus)&&const DeepCollectionEquality().equals(other._accounts, _accounts)&&(identical(other.accountsError, accountsError) || other.accountsError == accountsError)&&(identical(other.profileRevision, profileRevision) || other.profileRevision == profileRevision));
}


@override
int get hashCode => Object.hash(runtimeType,accountsStatus,const DeepCollectionEquality().hash(_accounts),accountsError,profileRevision);

@override
String toString() {
  return 'ProfileState(accountsStatus: $accountsStatus, accounts: $accounts, accountsError: $accountsError, profileRevision: $profileRevision)';
}


}

/// @nodoc
abstract mixin class _$ProfileStateCopyWith<$Res> implements $ProfileStateCopyWith<$Res> {
  factory _$ProfileStateCopyWith(_ProfileState value, $Res Function(_ProfileState) _then) = __$ProfileStateCopyWithImpl;
@override @useResult
$Res call({
 StateStatus accountsStatus, List<AccountItemEntity> accounts, String? accountsError, int profileRevision
});




}
/// @nodoc
class __$ProfileStateCopyWithImpl<$Res>
    implements _$ProfileStateCopyWith<$Res> {
  __$ProfileStateCopyWithImpl(this._self, this._then);

  final _ProfileState _self;
  final $Res Function(_ProfileState) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountsStatus = null,Object? accounts = null,Object? accountsError = freezed,Object? profileRevision = null,}) {
  return _then(_ProfileState(
accountsStatus: null == accountsStatus ? _self.accountsStatus : accountsStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,accounts: null == accounts ? _self._accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<AccountItemEntity>,accountsError: freezed == accountsError ? _self.accountsError : accountsError // ignore: cast_nullable_to_non_nullable
as String?,profileRevision: null == profileRevision ? _self.profileRevision : profileRevision // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
