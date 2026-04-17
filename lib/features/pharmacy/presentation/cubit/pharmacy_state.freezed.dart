// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pharmacy_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PharmacyState {

 StateStatus get medicinesLoadingStateStatus; List<PharmacyMedicineEntity> get medicines; String? get medicinesErrorMessage; List<PharmacyCartItemEntity> get cartItems; PharmacyPaymentMethod get selectedPaymentMethod;
/// Create a copy of PharmacyState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PharmacyStateCopyWith<PharmacyState> get copyWith => _$PharmacyStateCopyWithImpl<PharmacyState>(this as PharmacyState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PharmacyState&&(identical(other.medicinesLoadingStateStatus, medicinesLoadingStateStatus) || other.medicinesLoadingStateStatus == medicinesLoadingStateStatus)&&const DeepCollectionEquality().equals(other.medicines, medicines)&&(identical(other.medicinesErrorMessage, medicinesErrorMessage) || other.medicinesErrorMessage == medicinesErrorMessage)&&const DeepCollectionEquality().equals(other.cartItems, cartItems)&&(identical(other.selectedPaymentMethod, selectedPaymentMethod) || other.selectedPaymentMethod == selectedPaymentMethod));
}


@override
int get hashCode => Object.hash(runtimeType,medicinesLoadingStateStatus,const DeepCollectionEquality().hash(medicines),medicinesErrorMessage,const DeepCollectionEquality().hash(cartItems),selectedPaymentMethod);

@override
String toString() {
  return 'PharmacyState(medicinesLoadingStateStatus: $medicinesLoadingStateStatus, medicines: $medicines, medicinesErrorMessage: $medicinesErrorMessage, cartItems: $cartItems, selectedPaymentMethod: $selectedPaymentMethod)';
}


}

/// @nodoc
abstract mixin class $PharmacyStateCopyWith<$Res>  {
  factory $PharmacyStateCopyWith(PharmacyState value, $Res Function(PharmacyState) _then) = _$PharmacyStateCopyWithImpl;
@useResult
$Res call({
 StateStatus medicinesLoadingStateStatus, List<PharmacyMedicineEntity> medicines, String? medicinesErrorMessage, List<PharmacyCartItemEntity> cartItems, PharmacyPaymentMethod selectedPaymentMethod
});




}
/// @nodoc
class _$PharmacyStateCopyWithImpl<$Res>
    implements $PharmacyStateCopyWith<$Res> {
  _$PharmacyStateCopyWithImpl(this._self, this._then);

  final PharmacyState _self;
  final $Res Function(PharmacyState) _then;

/// Create a copy of PharmacyState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? medicinesLoadingStateStatus = null,Object? medicines = null,Object? medicinesErrorMessage = freezed,Object? cartItems = null,Object? selectedPaymentMethod = null,}) {
  return _then(_self.copyWith(
medicinesLoadingStateStatus: null == medicinesLoadingStateStatus ? _self.medicinesLoadingStateStatus : medicinesLoadingStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,medicines: null == medicines ? _self.medicines : medicines // ignore: cast_nullable_to_non_nullable
as List<PharmacyMedicineEntity>,medicinesErrorMessage: freezed == medicinesErrorMessage ? _self.medicinesErrorMessage : medicinesErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,cartItems: null == cartItems ? _self.cartItems : cartItems // ignore: cast_nullable_to_non_nullable
as List<PharmacyCartItemEntity>,selectedPaymentMethod: null == selectedPaymentMethod ? _self.selectedPaymentMethod : selectedPaymentMethod // ignore: cast_nullable_to_non_nullable
as PharmacyPaymentMethod,
  ));
}

}


/// Adds pattern-matching-related methods to [PharmacyState].
extension PharmacyStatePatterns on PharmacyState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PharmacyState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PharmacyState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PharmacyState value)  $default,){
final _that = this;
switch (_that) {
case _PharmacyState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PharmacyState value)?  $default,){
final _that = this;
switch (_that) {
case _PharmacyState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StateStatus medicinesLoadingStateStatus,  List<PharmacyMedicineEntity> medicines,  String? medicinesErrorMessage,  List<PharmacyCartItemEntity> cartItems,  PharmacyPaymentMethod selectedPaymentMethod)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PharmacyState() when $default != null:
return $default(_that.medicinesLoadingStateStatus,_that.medicines,_that.medicinesErrorMessage,_that.cartItems,_that.selectedPaymentMethod);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StateStatus medicinesLoadingStateStatus,  List<PharmacyMedicineEntity> medicines,  String? medicinesErrorMessage,  List<PharmacyCartItemEntity> cartItems,  PharmacyPaymentMethod selectedPaymentMethod)  $default,) {final _that = this;
switch (_that) {
case _PharmacyState():
return $default(_that.medicinesLoadingStateStatus,_that.medicines,_that.medicinesErrorMessage,_that.cartItems,_that.selectedPaymentMethod);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StateStatus medicinesLoadingStateStatus,  List<PharmacyMedicineEntity> medicines,  String? medicinesErrorMessage,  List<PharmacyCartItemEntity> cartItems,  PharmacyPaymentMethod selectedPaymentMethod)?  $default,) {final _that = this;
switch (_that) {
case _PharmacyState() when $default != null:
return $default(_that.medicinesLoadingStateStatus,_that.medicines,_that.medicinesErrorMessage,_that.cartItems,_that.selectedPaymentMethod);case _:
  return null;

}
}

}

/// @nodoc


class _PharmacyState implements PharmacyState {
  const _PharmacyState({this.medicinesLoadingStateStatus = StateStatus.idle, final  List<PharmacyMedicineEntity> medicines = const [], this.medicinesErrorMessage, final  List<PharmacyCartItemEntity> cartItems = const [], this.selectedPaymentMethod = PharmacyPaymentMethod.jazzCash}): _medicines = medicines,_cartItems = cartItems;
  

@override@JsonKey() final  StateStatus medicinesLoadingStateStatus;
 final  List<PharmacyMedicineEntity> _medicines;
@override@JsonKey() List<PharmacyMedicineEntity> get medicines {
  if (_medicines is EqualUnmodifiableListView) return _medicines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_medicines);
}

@override final  String? medicinesErrorMessage;
 final  List<PharmacyCartItemEntity> _cartItems;
@override@JsonKey() List<PharmacyCartItemEntity> get cartItems {
  if (_cartItems is EqualUnmodifiableListView) return _cartItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cartItems);
}

@override@JsonKey() final  PharmacyPaymentMethod selectedPaymentMethod;

/// Create a copy of PharmacyState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PharmacyStateCopyWith<_PharmacyState> get copyWith => __$PharmacyStateCopyWithImpl<_PharmacyState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PharmacyState&&(identical(other.medicinesLoadingStateStatus, medicinesLoadingStateStatus) || other.medicinesLoadingStateStatus == medicinesLoadingStateStatus)&&const DeepCollectionEquality().equals(other._medicines, _medicines)&&(identical(other.medicinesErrorMessage, medicinesErrorMessage) || other.medicinesErrorMessage == medicinesErrorMessage)&&const DeepCollectionEquality().equals(other._cartItems, _cartItems)&&(identical(other.selectedPaymentMethod, selectedPaymentMethod) || other.selectedPaymentMethod == selectedPaymentMethod));
}


@override
int get hashCode => Object.hash(runtimeType,medicinesLoadingStateStatus,const DeepCollectionEquality().hash(_medicines),medicinesErrorMessage,const DeepCollectionEquality().hash(_cartItems),selectedPaymentMethod);

@override
String toString() {
  return 'PharmacyState(medicinesLoadingStateStatus: $medicinesLoadingStateStatus, medicines: $medicines, medicinesErrorMessage: $medicinesErrorMessage, cartItems: $cartItems, selectedPaymentMethod: $selectedPaymentMethod)';
}


}

/// @nodoc
abstract mixin class _$PharmacyStateCopyWith<$Res> implements $PharmacyStateCopyWith<$Res> {
  factory _$PharmacyStateCopyWith(_PharmacyState value, $Res Function(_PharmacyState) _then) = __$PharmacyStateCopyWithImpl;
@override @useResult
$Res call({
 StateStatus medicinesLoadingStateStatus, List<PharmacyMedicineEntity> medicines, String? medicinesErrorMessage, List<PharmacyCartItemEntity> cartItems, PharmacyPaymentMethod selectedPaymentMethod
});




}
/// @nodoc
class __$PharmacyStateCopyWithImpl<$Res>
    implements _$PharmacyStateCopyWith<$Res> {
  __$PharmacyStateCopyWithImpl(this._self, this._then);

  final _PharmacyState _self;
  final $Res Function(_PharmacyState) _then;

/// Create a copy of PharmacyState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? medicinesLoadingStateStatus = null,Object? medicines = null,Object? medicinesErrorMessage = freezed,Object? cartItems = null,Object? selectedPaymentMethod = null,}) {
  return _then(_PharmacyState(
medicinesLoadingStateStatus: null == medicinesLoadingStateStatus ? _self.medicinesLoadingStateStatus : medicinesLoadingStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,medicines: null == medicines ? _self._medicines : medicines // ignore: cast_nullable_to_non_nullable
as List<PharmacyMedicineEntity>,medicinesErrorMessage: freezed == medicinesErrorMessage ? _self.medicinesErrorMessage : medicinesErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,cartItems: null == cartItems ? _self._cartItems : cartItems // ignore: cast_nullable_to_non_nullable
as List<PharmacyCartItemEntity>,selectedPaymentMethod: null == selectedPaymentMethod ? _self.selectedPaymentMethod : selectedPaymentMethod // ignore: cast_nullable_to_non_nullable
as PharmacyPaymentMethod,
  ));
}


}

// dart format on
