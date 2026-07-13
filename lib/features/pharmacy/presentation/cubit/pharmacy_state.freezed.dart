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

 StateStatus get medicinesLoadingStateStatus; List<PharmacyMedicineEntity> get medicines; String? get medicinesErrorMessage; String get searchQuery; int get currentPage; int get lastPage; int get totalProducts; bool get isLoadingMore; StateStatus get productDetailLoadingStateStatus; PharmacyMedicineEntity? get selectedProduct; List<PharmacyMedicineEntity> get relatedProducts; String? get productDetailErrorMessage; String get selectedCity; List<String> get checkoutCities; String? get cartBookingId; List<PharmacyCartItemEntity> get cartItems; PharmacyPaymentBreakdownEntity? get paymentBreakdown; PharmacyPaymentMethod get selectedPaymentMethod;
/// Create a copy of PharmacyState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PharmacyStateCopyWith<PharmacyState> get copyWith => _$PharmacyStateCopyWithImpl<PharmacyState>(this as PharmacyState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PharmacyState&&(identical(other.medicinesLoadingStateStatus, medicinesLoadingStateStatus) || other.medicinesLoadingStateStatus == medicinesLoadingStateStatus)&&const DeepCollectionEquality().equals(other.medicines, medicines)&&(identical(other.medicinesErrorMessage, medicinesErrorMessage) || other.medicinesErrorMessage == medicinesErrorMessage)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.totalProducts, totalProducts) || other.totalProducts == totalProducts)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.productDetailLoadingStateStatus, productDetailLoadingStateStatus) || other.productDetailLoadingStateStatus == productDetailLoadingStateStatus)&&(identical(other.selectedProduct, selectedProduct) || other.selectedProduct == selectedProduct)&&const DeepCollectionEquality().equals(other.relatedProducts, relatedProducts)&&(identical(other.productDetailErrorMessage, productDetailErrorMessage) || other.productDetailErrorMessage == productDetailErrorMessage)&&(identical(other.selectedCity, selectedCity) || other.selectedCity == selectedCity)&&const DeepCollectionEquality().equals(other.checkoutCities, checkoutCities)&&(identical(other.cartBookingId, cartBookingId) || other.cartBookingId == cartBookingId)&&const DeepCollectionEquality().equals(other.cartItems, cartItems)&&(identical(other.paymentBreakdown, paymentBreakdown) || other.paymentBreakdown == paymentBreakdown)&&(identical(other.selectedPaymentMethod, selectedPaymentMethod) || other.selectedPaymentMethod == selectedPaymentMethod));
}


@override
int get hashCode => Object.hash(runtimeType,medicinesLoadingStateStatus,const DeepCollectionEquality().hash(medicines),medicinesErrorMessage,searchQuery,currentPage,lastPage,totalProducts,isLoadingMore,productDetailLoadingStateStatus,selectedProduct,const DeepCollectionEquality().hash(relatedProducts),productDetailErrorMessage,selectedCity,const DeepCollectionEquality().hash(checkoutCities),cartBookingId,const DeepCollectionEquality().hash(cartItems),paymentBreakdown,selectedPaymentMethod);

@override
String toString() {
  return 'PharmacyState(medicinesLoadingStateStatus: $medicinesLoadingStateStatus, medicines: $medicines, medicinesErrorMessage: $medicinesErrorMessage, searchQuery: $searchQuery, currentPage: $currentPage, lastPage: $lastPage, totalProducts: $totalProducts, isLoadingMore: $isLoadingMore, productDetailLoadingStateStatus: $productDetailLoadingStateStatus, selectedProduct: $selectedProduct, relatedProducts: $relatedProducts, productDetailErrorMessage: $productDetailErrorMessage, selectedCity: $selectedCity, checkoutCities: $checkoutCities, cartBookingId: $cartBookingId, cartItems: $cartItems, paymentBreakdown: $paymentBreakdown, selectedPaymentMethod: $selectedPaymentMethod)';
}


}

/// @nodoc
abstract mixin class $PharmacyStateCopyWith<$Res>  {
  factory $PharmacyStateCopyWith(PharmacyState value, $Res Function(PharmacyState) _then) = _$PharmacyStateCopyWithImpl;
@useResult
$Res call({
 StateStatus medicinesLoadingStateStatus, List<PharmacyMedicineEntity> medicines, String? medicinesErrorMessage, String searchQuery, int currentPage, int lastPage, int totalProducts, bool isLoadingMore, StateStatus productDetailLoadingStateStatus, PharmacyMedicineEntity? selectedProduct, List<PharmacyMedicineEntity> relatedProducts, String? productDetailErrorMessage, String selectedCity, List<String> checkoutCities, String? cartBookingId, List<PharmacyCartItemEntity> cartItems, PharmacyPaymentBreakdownEntity? paymentBreakdown, PharmacyPaymentMethod selectedPaymentMethod
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
@pragma('vm:prefer-inline') @override $Res call({Object? medicinesLoadingStateStatus = null,Object? medicines = null,Object? medicinesErrorMessage = freezed,Object? searchQuery = null,Object? currentPage = null,Object? lastPage = null,Object? totalProducts = null,Object? isLoadingMore = null,Object? productDetailLoadingStateStatus = null,Object? selectedProduct = freezed,Object? relatedProducts = null,Object? productDetailErrorMessage = freezed,Object? selectedCity = null,Object? checkoutCities = null,Object? cartBookingId = freezed,Object? cartItems = null,Object? paymentBreakdown = freezed,Object? selectedPaymentMethod = null,}) {
  return _then(_self.copyWith(
medicinesLoadingStateStatus: null == medicinesLoadingStateStatus ? _self.medicinesLoadingStateStatus : medicinesLoadingStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,medicines: null == medicines ? _self.medicines : medicines // ignore: cast_nullable_to_non_nullable
as List<PharmacyMedicineEntity>,medicinesErrorMessage: freezed == medicinesErrorMessage ? _self.medicinesErrorMessage : medicinesErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,totalProducts: null == totalProducts ? _self.totalProducts : totalProducts // ignore: cast_nullable_to_non_nullable
as int,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,productDetailLoadingStateStatus: null == productDetailLoadingStateStatus ? _self.productDetailLoadingStateStatus : productDetailLoadingStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,selectedProduct: freezed == selectedProduct ? _self.selectedProduct : selectedProduct // ignore: cast_nullable_to_non_nullable
as PharmacyMedicineEntity?,relatedProducts: null == relatedProducts ? _self.relatedProducts : relatedProducts // ignore: cast_nullable_to_non_nullable
as List<PharmacyMedicineEntity>,productDetailErrorMessage: freezed == productDetailErrorMessage ? _self.productDetailErrorMessage : productDetailErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,selectedCity: null == selectedCity ? _self.selectedCity : selectedCity // ignore: cast_nullable_to_non_nullable
as String,checkoutCities: null == checkoutCities ? _self.checkoutCities : checkoutCities // ignore: cast_nullable_to_non_nullable
as List<String>,cartBookingId: freezed == cartBookingId ? _self.cartBookingId : cartBookingId // ignore: cast_nullable_to_non_nullable
as String?,cartItems: null == cartItems ? _self.cartItems : cartItems // ignore: cast_nullable_to_non_nullable
as List<PharmacyCartItemEntity>,paymentBreakdown: freezed == paymentBreakdown ? _self.paymentBreakdown : paymentBreakdown // ignore: cast_nullable_to_non_nullable
as PharmacyPaymentBreakdownEntity?,selectedPaymentMethod: null == selectedPaymentMethod ? _self.selectedPaymentMethod : selectedPaymentMethod // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StateStatus medicinesLoadingStateStatus,  List<PharmacyMedicineEntity> medicines,  String? medicinesErrorMessage,  String searchQuery,  int currentPage,  int lastPage,  int totalProducts,  bool isLoadingMore,  StateStatus productDetailLoadingStateStatus,  PharmacyMedicineEntity? selectedProduct,  List<PharmacyMedicineEntity> relatedProducts,  String? productDetailErrorMessage,  String selectedCity,  List<String> checkoutCities,  String? cartBookingId,  List<PharmacyCartItemEntity> cartItems,  PharmacyPaymentBreakdownEntity? paymentBreakdown,  PharmacyPaymentMethod selectedPaymentMethod)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PharmacyState() when $default != null:
return $default(_that.medicinesLoadingStateStatus,_that.medicines,_that.medicinesErrorMessage,_that.searchQuery,_that.currentPage,_that.lastPage,_that.totalProducts,_that.isLoadingMore,_that.productDetailLoadingStateStatus,_that.selectedProduct,_that.relatedProducts,_that.productDetailErrorMessage,_that.selectedCity,_that.checkoutCities,_that.cartBookingId,_that.cartItems,_that.paymentBreakdown,_that.selectedPaymentMethod);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StateStatus medicinesLoadingStateStatus,  List<PharmacyMedicineEntity> medicines,  String? medicinesErrorMessage,  String searchQuery,  int currentPage,  int lastPage,  int totalProducts,  bool isLoadingMore,  StateStatus productDetailLoadingStateStatus,  PharmacyMedicineEntity? selectedProduct,  List<PharmacyMedicineEntity> relatedProducts,  String? productDetailErrorMessage,  String selectedCity,  List<String> checkoutCities,  String? cartBookingId,  List<PharmacyCartItemEntity> cartItems,  PharmacyPaymentBreakdownEntity? paymentBreakdown,  PharmacyPaymentMethod selectedPaymentMethod)  $default,) {final _that = this;
switch (_that) {
case _PharmacyState():
return $default(_that.medicinesLoadingStateStatus,_that.medicines,_that.medicinesErrorMessage,_that.searchQuery,_that.currentPage,_that.lastPage,_that.totalProducts,_that.isLoadingMore,_that.productDetailLoadingStateStatus,_that.selectedProduct,_that.relatedProducts,_that.productDetailErrorMessage,_that.selectedCity,_that.checkoutCities,_that.cartBookingId,_that.cartItems,_that.paymentBreakdown,_that.selectedPaymentMethod);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StateStatus medicinesLoadingStateStatus,  List<PharmacyMedicineEntity> medicines,  String? medicinesErrorMessage,  String searchQuery,  int currentPage,  int lastPage,  int totalProducts,  bool isLoadingMore,  StateStatus productDetailLoadingStateStatus,  PharmacyMedicineEntity? selectedProduct,  List<PharmacyMedicineEntity> relatedProducts,  String? productDetailErrorMessage,  String selectedCity,  List<String> checkoutCities,  String? cartBookingId,  List<PharmacyCartItemEntity> cartItems,  PharmacyPaymentBreakdownEntity? paymentBreakdown,  PharmacyPaymentMethod selectedPaymentMethod)?  $default,) {final _that = this;
switch (_that) {
case _PharmacyState() when $default != null:
return $default(_that.medicinesLoadingStateStatus,_that.medicines,_that.medicinesErrorMessage,_that.searchQuery,_that.currentPage,_that.lastPage,_that.totalProducts,_that.isLoadingMore,_that.productDetailLoadingStateStatus,_that.selectedProduct,_that.relatedProducts,_that.productDetailErrorMessage,_that.selectedCity,_that.checkoutCities,_that.cartBookingId,_that.cartItems,_that.paymentBreakdown,_that.selectedPaymentMethod);case _:
  return null;

}
}

}

/// @nodoc


class _PharmacyState implements PharmacyState {
  const _PharmacyState({this.medicinesLoadingStateStatus = StateStatus.idle, final  List<PharmacyMedicineEntity> medicines = const [], this.medicinesErrorMessage, this.searchQuery = '', this.currentPage = 1, this.lastPage = 1, this.totalProducts = 0, this.isLoadingMore = false, this.productDetailLoadingStateStatus = StateStatus.idle, this.selectedProduct, final  List<PharmacyMedicineEntity> relatedProducts = const [], this.productDetailErrorMessage, this.selectedCity = 'Islamabad', final  List<String> checkoutCities = const [], this.cartBookingId, final  List<PharmacyCartItemEntity> cartItems = const [], this.paymentBreakdown, this.selectedPaymentMethod = PharmacyPaymentMethod.jazzCash}): _medicines = medicines,_relatedProducts = relatedProducts,_checkoutCities = checkoutCities,_cartItems = cartItems;
  

@override@JsonKey() final  StateStatus medicinesLoadingStateStatus;
 final  List<PharmacyMedicineEntity> _medicines;
@override@JsonKey() List<PharmacyMedicineEntity> get medicines {
  if (_medicines is EqualUnmodifiableListView) return _medicines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_medicines);
}

@override final  String? medicinesErrorMessage;
@override@JsonKey() final  String searchQuery;
@override@JsonKey() final  int currentPage;
@override@JsonKey() final  int lastPage;
@override@JsonKey() final  int totalProducts;
@override@JsonKey() final  bool isLoadingMore;
@override@JsonKey() final  StateStatus productDetailLoadingStateStatus;
@override final  PharmacyMedicineEntity? selectedProduct;
 final  List<PharmacyMedicineEntity> _relatedProducts;
@override@JsonKey() List<PharmacyMedicineEntity> get relatedProducts {
  if (_relatedProducts is EqualUnmodifiableListView) return _relatedProducts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_relatedProducts);
}

@override final  String? productDetailErrorMessage;
@override@JsonKey() final  String selectedCity;
 final  List<String> _checkoutCities;
@override@JsonKey() List<String> get checkoutCities {
  if (_checkoutCities is EqualUnmodifiableListView) return _checkoutCities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_checkoutCities);
}

@override final  String? cartBookingId;
 final  List<PharmacyCartItemEntity> _cartItems;
@override@JsonKey() List<PharmacyCartItemEntity> get cartItems {
  if (_cartItems is EqualUnmodifiableListView) return _cartItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cartItems);
}

@override final  PharmacyPaymentBreakdownEntity? paymentBreakdown;
@override@JsonKey() final  PharmacyPaymentMethod selectedPaymentMethod;

/// Create a copy of PharmacyState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PharmacyStateCopyWith<_PharmacyState> get copyWith => __$PharmacyStateCopyWithImpl<_PharmacyState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PharmacyState&&(identical(other.medicinesLoadingStateStatus, medicinesLoadingStateStatus) || other.medicinesLoadingStateStatus == medicinesLoadingStateStatus)&&const DeepCollectionEquality().equals(other._medicines, _medicines)&&(identical(other.medicinesErrorMessage, medicinesErrorMessage) || other.medicinesErrorMessage == medicinesErrorMessage)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.totalProducts, totalProducts) || other.totalProducts == totalProducts)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.productDetailLoadingStateStatus, productDetailLoadingStateStatus) || other.productDetailLoadingStateStatus == productDetailLoadingStateStatus)&&(identical(other.selectedProduct, selectedProduct) || other.selectedProduct == selectedProduct)&&const DeepCollectionEquality().equals(other._relatedProducts, _relatedProducts)&&(identical(other.productDetailErrorMessage, productDetailErrorMessage) || other.productDetailErrorMessage == productDetailErrorMessage)&&(identical(other.selectedCity, selectedCity) || other.selectedCity == selectedCity)&&const DeepCollectionEquality().equals(other._checkoutCities, _checkoutCities)&&(identical(other.cartBookingId, cartBookingId) || other.cartBookingId == cartBookingId)&&const DeepCollectionEquality().equals(other._cartItems, _cartItems)&&(identical(other.paymentBreakdown, paymentBreakdown) || other.paymentBreakdown == paymentBreakdown)&&(identical(other.selectedPaymentMethod, selectedPaymentMethod) || other.selectedPaymentMethod == selectedPaymentMethod));
}


@override
int get hashCode => Object.hash(runtimeType,medicinesLoadingStateStatus,const DeepCollectionEquality().hash(_medicines),medicinesErrorMessage,searchQuery,currentPage,lastPage,totalProducts,isLoadingMore,productDetailLoadingStateStatus,selectedProduct,const DeepCollectionEquality().hash(_relatedProducts),productDetailErrorMessage,selectedCity,const DeepCollectionEquality().hash(_checkoutCities),cartBookingId,const DeepCollectionEquality().hash(_cartItems),paymentBreakdown,selectedPaymentMethod);

@override
String toString() {
  return 'PharmacyState(medicinesLoadingStateStatus: $medicinesLoadingStateStatus, medicines: $medicines, medicinesErrorMessage: $medicinesErrorMessage, searchQuery: $searchQuery, currentPage: $currentPage, lastPage: $lastPage, totalProducts: $totalProducts, isLoadingMore: $isLoadingMore, productDetailLoadingStateStatus: $productDetailLoadingStateStatus, selectedProduct: $selectedProduct, relatedProducts: $relatedProducts, productDetailErrorMessage: $productDetailErrorMessage, selectedCity: $selectedCity, checkoutCities: $checkoutCities, cartBookingId: $cartBookingId, cartItems: $cartItems, paymentBreakdown: $paymentBreakdown, selectedPaymentMethod: $selectedPaymentMethod)';
}


}

/// @nodoc
abstract mixin class _$PharmacyStateCopyWith<$Res> implements $PharmacyStateCopyWith<$Res> {
  factory _$PharmacyStateCopyWith(_PharmacyState value, $Res Function(_PharmacyState) _then) = __$PharmacyStateCopyWithImpl;
@override @useResult
$Res call({
 StateStatus medicinesLoadingStateStatus, List<PharmacyMedicineEntity> medicines, String? medicinesErrorMessage, String searchQuery, int currentPage, int lastPage, int totalProducts, bool isLoadingMore, StateStatus productDetailLoadingStateStatus, PharmacyMedicineEntity? selectedProduct, List<PharmacyMedicineEntity> relatedProducts, String? productDetailErrorMessage, String selectedCity, List<String> checkoutCities, String? cartBookingId, List<PharmacyCartItemEntity> cartItems, PharmacyPaymentBreakdownEntity? paymentBreakdown, PharmacyPaymentMethod selectedPaymentMethod
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
@override @pragma('vm:prefer-inline') $Res call({Object? medicinesLoadingStateStatus = null,Object? medicines = null,Object? medicinesErrorMessage = freezed,Object? searchQuery = null,Object? currentPage = null,Object? lastPage = null,Object? totalProducts = null,Object? isLoadingMore = null,Object? productDetailLoadingStateStatus = null,Object? selectedProduct = freezed,Object? relatedProducts = null,Object? productDetailErrorMessage = freezed,Object? selectedCity = null,Object? checkoutCities = null,Object? cartBookingId = freezed,Object? cartItems = null,Object? paymentBreakdown = freezed,Object? selectedPaymentMethod = null,}) {
  return _then(_PharmacyState(
medicinesLoadingStateStatus: null == medicinesLoadingStateStatus ? _self.medicinesLoadingStateStatus : medicinesLoadingStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,medicines: null == medicines ? _self._medicines : medicines // ignore: cast_nullable_to_non_nullable
as List<PharmacyMedicineEntity>,medicinesErrorMessage: freezed == medicinesErrorMessage ? _self.medicinesErrorMessage : medicinesErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,totalProducts: null == totalProducts ? _self.totalProducts : totalProducts // ignore: cast_nullable_to_non_nullable
as int,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,productDetailLoadingStateStatus: null == productDetailLoadingStateStatus ? _self.productDetailLoadingStateStatus : productDetailLoadingStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,selectedProduct: freezed == selectedProduct ? _self.selectedProduct : selectedProduct // ignore: cast_nullable_to_non_nullable
as PharmacyMedicineEntity?,relatedProducts: null == relatedProducts ? _self._relatedProducts : relatedProducts // ignore: cast_nullable_to_non_nullable
as List<PharmacyMedicineEntity>,productDetailErrorMessage: freezed == productDetailErrorMessage ? _self.productDetailErrorMessage : productDetailErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,selectedCity: null == selectedCity ? _self.selectedCity : selectedCity // ignore: cast_nullable_to_non_nullable
as String,checkoutCities: null == checkoutCities ? _self._checkoutCities : checkoutCities // ignore: cast_nullable_to_non_nullable
as List<String>,cartBookingId: freezed == cartBookingId ? _self.cartBookingId : cartBookingId // ignore: cast_nullable_to_non_nullable
as String?,cartItems: null == cartItems ? _self._cartItems : cartItems // ignore: cast_nullable_to_non_nullable
as List<PharmacyCartItemEntity>,paymentBreakdown: freezed == paymentBreakdown ? _self.paymentBreakdown : paymentBreakdown // ignore: cast_nullable_to_non_nullable
as PharmacyPaymentBreakdownEntity?,selectedPaymentMethod: null == selectedPaymentMethod ? _self.selectedPaymentMethod : selectedPaymentMethod // ignore: cast_nullable_to_non_nullable
as PharmacyPaymentMethod,
  ));
}


}

// dart format on
