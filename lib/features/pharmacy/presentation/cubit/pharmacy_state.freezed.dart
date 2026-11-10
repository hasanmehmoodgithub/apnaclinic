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

 StateStatus get medicinesLoadingStateStatus; List<PharmacyMedicineEntity> get medicines; String? get medicinesErrorMessage; String get searchQuery; int get currentPage; int get lastPage; int get totalProducts; bool get isLoadingMore; StateStatus get productDetailLoadingStateStatus; PharmacyMedicineEntity? get selectedProduct; List<PharmacyMedicineEntity> get relatedProducts; String? get productDetailErrorMessage; bool get productUnavailableInCity;/// Stored pharmacy delivery city name (empty until the user confirms).
 String get selectedCity; int? get pharmacyCityId; String get pharmacyPartner; List<PharmacyCityEntity> get pharmacyCities; bool get needsPharmacyCitySelection; List<String> get checkoutCities; String? get cartBookingId; List<PharmacyCartItemEntity> get cartItems; List<PharmacyCartAddressEntity> get cartAddresses; PharmacyPaymentBreakdownEntity? get paymentBreakdown; List<PaymentProviderEntity> get paymentProviders; StateStatus get paymentProvidersStatus; String? get paymentProvidersErrorMessage; String? get selectedPaymentProviderCode; PharmacyCartMessagesEntity? get cartMessages; List<PharmacyCartInvalidItemEntity> get checkoutInvalidItems; PrescriptionScanState get prescriptionScan;
/// Create a copy of PharmacyState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PharmacyStateCopyWith<PharmacyState> get copyWith => _$PharmacyStateCopyWithImpl<PharmacyState>(this as PharmacyState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PharmacyState&&(identical(other.medicinesLoadingStateStatus, medicinesLoadingStateStatus) || other.medicinesLoadingStateStatus == medicinesLoadingStateStatus)&&const DeepCollectionEquality().equals(other.medicines, medicines)&&(identical(other.medicinesErrorMessage, medicinesErrorMessage) || other.medicinesErrorMessage == medicinesErrorMessage)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.totalProducts, totalProducts) || other.totalProducts == totalProducts)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.productDetailLoadingStateStatus, productDetailLoadingStateStatus) || other.productDetailLoadingStateStatus == productDetailLoadingStateStatus)&&(identical(other.selectedProduct, selectedProduct) || other.selectedProduct == selectedProduct)&&const DeepCollectionEquality().equals(other.relatedProducts, relatedProducts)&&(identical(other.productDetailErrorMessage, productDetailErrorMessage) || other.productDetailErrorMessage == productDetailErrorMessage)&&(identical(other.productUnavailableInCity, productUnavailableInCity) || other.productUnavailableInCity == productUnavailableInCity)&&(identical(other.selectedCity, selectedCity) || other.selectedCity == selectedCity)&&(identical(other.pharmacyCityId, pharmacyCityId) || other.pharmacyCityId == pharmacyCityId)&&(identical(other.pharmacyPartner, pharmacyPartner) || other.pharmacyPartner == pharmacyPartner)&&const DeepCollectionEquality().equals(other.pharmacyCities, pharmacyCities)&&(identical(other.needsPharmacyCitySelection, needsPharmacyCitySelection) || other.needsPharmacyCitySelection == needsPharmacyCitySelection)&&const DeepCollectionEquality().equals(other.checkoutCities, checkoutCities)&&(identical(other.cartBookingId, cartBookingId) || other.cartBookingId == cartBookingId)&&const DeepCollectionEquality().equals(other.cartItems, cartItems)&&const DeepCollectionEquality().equals(other.cartAddresses, cartAddresses)&&(identical(other.paymentBreakdown, paymentBreakdown) || other.paymentBreakdown == paymentBreakdown)&&const DeepCollectionEquality().equals(other.paymentProviders, paymentProviders)&&(identical(other.paymentProvidersStatus, paymentProvidersStatus) || other.paymentProvidersStatus == paymentProvidersStatus)&&(identical(other.paymentProvidersErrorMessage, paymentProvidersErrorMessage) || other.paymentProvidersErrorMessage == paymentProvidersErrorMessage)&&(identical(other.selectedPaymentProviderCode, selectedPaymentProviderCode) || other.selectedPaymentProviderCode == selectedPaymentProviderCode)&&(identical(other.cartMessages, cartMessages) || other.cartMessages == cartMessages)&&const DeepCollectionEquality().equals(other.checkoutInvalidItems, checkoutInvalidItems)&&(identical(other.prescriptionScan, prescriptionScan) || other.prescriptionScan == prescriptionScan));
}


@override
int get hashCode => Object.hashAll([runtimeType,medicinesLoadingStateStatus,const DeepCollectionEquality().hash(medicines),medicinesErrorMessage,searchQuery,currentPage,lastPage,totalProducts,isLoadingMore,productDetailLoadingStateStatus,selectedProduct,const DeepCollectionEquality().hash(relatedProducts),productDetailErrorMessage,productUnavailableInCity,selectedCity,pharmacyCityId,pharmacyPartner,const DeepCollectionEquality().hash(pharmacyCities),needsPharmacyCitySelection,const DeepCollectionEquality().hash(checkoutCities),cartBookingId,const DeepCollectionEquality().hash(cartItems),const DeepCollectionEquality().hash(cartAddresses),paymentBreakdown,const DeepCollectionEquality().hash(paymentProviders),paymentProvidersStatus,paymentProvidersErrorMessage,selectedPaymentProviderCode,cartMessages,const DeepCollectionEquality().hash(checkoutInvalidItems),prescriptionScan]);

@override
String toString() {
  return 'PharmacyState(medicinesLoadingStateStatus: $medicinesLoadingStateStatus, medicines: $medicines, medicinesErrorMessage: $medicinesErrorMessage, searchQuery: $searchQuery, currentPage: $currentPage, lastPage: $lastPage, totalProducts: $totalProducts, isLoadingMore: $isLoadingMore, productDetailLoadingStateStatus: $productDetailLoadingStateStatus, selectedProduct: $selectedProduct, relatedProducts: $relatedProducts, productDetailErrorMessage: $productDetailErrorMessage, productUnavailableInCity: $productUnavailableInCity, selectedCity: $selectedCity, pharmacyCityId: $pharmacyCityId, pharmacyPartner: $pharmacyPartner, pharmacyCities: $pharmacyCities, needsPharmacyCitySelection: $needsPharmacyCitySelection, checkoutCities: $checkoutCities, cartBookingId: $cartBookingId, cartItems: $cartItems, cartAddresses: $cartAddresses, paymentBreakdown: $paymentBreakdown, paymentProviders: $paymentProviders, paymentProvidersStatus: $paymentProvidersStatus, paymentProvidersErrorMessage: $paymentProvidersErrorMessage, selectedPaymentProviderCode: $selectedPaymentProviderCode, cartMessages: $cartMessages, checkoutInvalidItems: $checkoutInvalidItems, prescriptionScan: $prescriptionScan)';
}


}

/// @nodoc
abstract mixin class $PharmacyStateCopyWith<$Res>  {
  factory $PharmacyStateCopyWith(PharmacyState value, $Res Function(PharmacyState) _then) = _$PharmacyStateCopyWithImpl;
@useResult
$Res call({
 StateStatus medicinesLoadingStateStatus, List<PharmacyMedicineEntity> medicines, String? medicinesErrorMessage, String searchQuery, int currentPage, int lastPage, int totalProducts, bool isLoadingMore, StateStatus productDetailLoadingStateStatus, PharmacyMedicineEntity? selectedProduct, List<PharmacyMedicineEntity> relatedProducts, String? productDetailErrorMessage, bool productUnavailableInCity, String selectedCity, int? pharmacyCityId, String pharmacyPartner, List<PharmacyCityEntity> pharmacyCities, bool needsPharmacyCitySelection, List<String> checkoutCities, String? cartBookingId, List<PharmacyCartItemEntity> cartItems, List<PharmacyCartAddressEntity> cartAddresses, PharmacyPaymentBreakdownEntity? paymentBreakdown, List<PaymentProviderEntity> paymentProviders, StateStatus paymentProvidersStatus, String? paymentProvidersErrorMessage, String? selectedPaymentProviderCode, PharmacyCartMessagesEntity? cartMessages, List<PharmacyCartInvalidItemEntity> checkoutInvalidItems, PrescriptionScanState prescriptionScan
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
@pragma('vm:prefer-inline') @override $Res call({Object? medicinesLoadingStateStatus = null,Object? medicines = null,Object? medicinesErrorMessage = freezed,Object? searchQuery = null,Object? currentPage = null,Object? lastPage = null,Object? totalProducts = null,Object? isLoadingMore = null,Object? productDetailLoadingStateStatus = null,Object? selectedProduct = freezed,Object? relatedProducts = null,Object? productDetailErrorMessage = freezed,Object? productUnavailableInCity = null,Object? selectedCity = null,Object? pharmacyCityId = freezed,Object? pharmacyPartner = null,Object? pharmacyCities = null,Object? needsPharmacyCitySelection = null,Object? checkoutCities = null,Object? cartBookingId = freezed,Object? cartItems = null,Object? cartAddresses = null,Object? paymentBreakdown = freezed,Object? paymentProviders = null,Object? paymentProvidersStatus = null,Object? paymentProvidersErrorMessage = freezed,Object? selectedPaymentProviderCode = freezed,Object? cartMessages = freezed,Object? checkoutInvalidItems = null,Object? prescriptionScan = null,}) {
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
as String?,productUnavailableInCity: null == productUnavailableInCity ? _self.productUnavailableInCity : productUnavailableInCity // ignore: cast_nullable_to_non_nullable
as bool,selectedCity: null == selectedCity ? _self.selectedCity : selectedCity // ignore: cast_nullable_to_non_nullable
as String,pharmacyCityId: freezed == pharmacyCityId ? _self.pharmacyCityId : pharmacyCityId // ignore: cast_nullable_to_non_nullable
as int?,pharmacyPartner: null == pharmacyPartner ? _self.pharmacyPartner : pharmacyPartner // ignore: cast_nullable_to_non_nullable
as String,pharmacyCities: null == pharmacyCities ? _self.pharmacyCities : pharmacyCities // ignore: cast_nullable_to_non_nullable
as List<PharmacyCityEntity>,needsPharmacyCitySelection: null == needsPharmacyCitySelection ? _self.needsPharmacyCitySelection : needsPharmacyCitySelection // ignore: cast_nullable_to_non_nullable
as bool,checkoutCities: null == checkoutCities ? _self.checkoutCities : checkoutCities // ignore: cast_nullable_to_non_nullable
as List<String>,cartBookingId: freezed == cartBookingId ? _self.cartBookingId : cartBookingId // ignore: cast_nullable_to_non_nullable
as String?,cartItems: null == cartItems ? _self.cartItems : cartItems // ignore: cast_nullable_to_non_nullable
as List<PharmacyCartItemEntity>,cartAddresses: null == cartAddresses ? _self.cartAddresses : cartAddresses // ignore: cast_nullable_to_non_nullable
as List<PharmacyCartAddressEntity>,paymentBreakdown: freezed == paymentBreakdown ? _self.paymentBreakdown : paymentBreakdown // ignore: cast_nullable_to_non_nullable
as PharmacyPaymentBreakdownEntity?,paymentProviders: null == paymentProviders ? _self.paymentProviders : paymentProviders // ignore: cast_nullable_to_non_nullable
as List<PaymentProviderEntity>,paymentProvidersStatus: null == paymentProvidersStatus ? _self.paymentProvidersStatus : paymentProvidersStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,paymentProvidersErrorMessage: freezed == paymentProvidersErrorMessage ? _self.paymentProvidersErrorMessage : paymentProvidersErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,selectedPaymentProviderCode: freezed == selectedPaymentProviderCode ? _self.selectedPaymentProviderCode : selectedPaymentProviderCode // ignore: cast_nullable_to_non_nullable
as String?,cartMessages: freezed == cartMessages ? _self.cartMessages : cartMessages // ignore: cast_nullable_to_non_nullable
as PharmacyCartMessagesEntity?,checkoutInvalidItems: null == checkoutInvalidItems ? _self.checkoutInvalidItems : checkoutInvalidItems // ignore: cast_nullable_to_non_nullable
as List<PharmacyCartInvalidItemEntity>,prescriptionScan: null == prescriptionScan ? _self.prescriptionScan : prescriptionScan // ignore: cast_nullable_to_non_nullable
as PrescriptionScanState,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StateStatus medicinesLoadingStateStatus,  List<PharmacyMedicineEntity> medicines,  String? medicinesErrorMessage,  String searchQuery,  int currentPage,  int lastPage,  int totalProducts,  bool isLoadingMore,  StateStatus productDetailLoadingStateStatus,  PharmacyMedicineEntity? selectedProduct,  List<PharmacyMedicineEntity> relatedProducts,  String? productDetailErrorMessage,  bool productUnavailableInCity,  String selectedCity,  int? pharmacyCityId,  String pharmacyPartner,  List<PharmacyCityEntity> pharmacyCities,  bool needsPharmacyCitySelection,  List<String> checkoutCities,  String? cartBookingId,  List<PharmacyCartItemEntity> cartItems,  List<PharmacyCartAddressEntity> cartAddresses,  PharmacyPaymentBreakdownEntity? paymentBreakdown,  List<PaymentProviderEntity> paymentProviders,  StateStatus paymentProvidersStatus,  String? paymentProvidersErrorMessage,  String? selectedPaymentProviderCode,  PharmacyCartMessagesEntity? cartMessages,  List<PharmacyCartInvalidItemEntity> checkoutInvalidItems,  PrescriptionScanState prescriptionScan)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PharmacyState() when $default != null:
return $default(_that.medicinesLoadingStateStatus,_that.medicines,_that.medicinesErrorMessage,_that.searchQuery,_that.currentPage,_that.lastPage,_that.totalProducts,_that.isLoadingMore,_that.productDetailLoadingStateStatus,_that.selectedProduct,_that.relatedProducts,_that.productDetailErrorMessage,_that.productUnavailableInCity,_that.selectedCity,_that.pharmacyCityId,_that.pharmacyPartner,_that.pharmacyCities,_that.needsPharmacyCitySelection,_that.checkoutCities,_that.cartBookingId,_that.cartItems,_that.cartAddresses,_that.paymentBreakdown,_that.paymentProviders,_that.paymentProvidersStatus,_that.paymentProvidersErrorMessage,_that.selectedPaymentProviderCode,_that.cartMessages,_that.checkoutInvalidItems,_that.prescriptionScan);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StateStatus medicinesLoadingStateStatus,  List<PharmacyMedicineEntity> medicines,  String? medicinesErrorMessage,  String searchQuery,  int currentPage,  int lastPage,  int totalProducts,  bool isLoadingMore,  StateStatus productDetailLoadingStateStatus,  PharmacyMedicineEntity? selectedProduct,  List<PharmacyMedicineEntity> relatedProducts,  String? productDetailErrorMessage,  bool productUnavailableInCity,  String selectedCity,  int? pharmacyCityId,  String pharmacyPartner,  List<PharmacyCityEntity> pharmacyCities,  bool needsPharmacyCitySelection,  List<String> checkoutCities,  String? cartBookingId,  List<PharmacyCartItemEntity> cartItems,  List<PharmacyCartAddressEntity> cartAddresses,  PharmacyPaymentBreakdownEntity? paymentBreakdown,  List<PaymentProviderEntity> paymentProviders,  StateStatus paymentProvidersStatus,  String? paymentProvidersErrorMessage,  String? selectedPaymentProviderCode,  PharmacyCartMessagesEntity? cartMessages,  List<PharmacyCartInvalidItemEntity> checkoutInvalidItems,  PrescriptionScanState prescriptionScan)  $default,) {final _that = this;
switch (_that) {
case _PharmacyState():
return $default(_that.medicinesLoadingStateStatus,_that.medicines,_that.medicinesErrorMessage,_that.searchQuery,_that.currentPage,_that.lastPage,_that.totalProducts,_that.isLoadingMore,_that.productDetailLoadingStateStatus,_that.selectedProduct,_that.relatedProducts,_that.productDetailErrorMessage,_that.productUnavailableInCity,_that.selectedCity,_that.pharmacyCityId,_that.pharmacyPartner,_that.pharmacyCities,_that.needsPharmacyCitySelection,_that.checkoutCities,_that.cartBookingId,_that.cartItems,_that.cartAddresses,_that.paymentBreakdown,_that.paymentProviders,_that.paymentProvidersStatus,_that.paymentProvidersErrorMessage,_that.selectedPaymentProviderCode,_that.cartMessages,_that.checkoutInvalidItems,_that.prescriptionScan);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StateStatus medicinesLoadingStateStatus,  List<PharmacyMedicineEntity> medicines,  String? medicinesErrorMessage,  String searchQuery,  int currentPage,  int lastPage,  int totalProducts,  bool isLoadingMore,  StateStatus productDetailLoadingStateStatus,  PharmacyMedicineEntity? selectedProduct,  List<PharmacyMedicineEntity> relatedProducts,  String? productDetailErrorMessage,  bool productUnavailableInCity,  String selectedCity,  int? pharmacyCityId,  String pharmacyPartner,  List<PharmacyCityEntity> pharmacyCities,  bool needsPharmacyCitySelection,  List<String> checkoutCities,  String? cartBookingId,  List<PharmacyCartItemEntity> cartItems,  List<PharmacyCartAddressEntity> cartAddresses,  PharmacyPaymentBreakdownEntity? paymentBreakdown,  List<PaymentProviderEntity> paymentProviders,  StateStatus paymentProvidersStatus,  String? paymentProvidersErrorMessage,  String? selectedPaymentProviderCode,  PharmacyCartMessagesEntity? cartMessages,  List<PharmacyCartInvalidItemEntity> checkoutInvalidItems,  PrescriptionScanState prescriptionScan)?  $default,) {final _that = this;
switch (_that) {
case _PharmacyState() when $default != null:
return $default(_that.medicinesLoadingStateStatus,_that.medicines,_that.medicinesErrorMessage,_that.searchQuery,_that.currentPage,_that.lastPage,_that.totalProducts,_that.isLoadingMore,_that.productDetailLoadingStateStatus,_that.selectedProduct,_that.relatedProducts,_that.productDetailErrorMessage,_that.productUnavailableInCity,_that.selectedCity,_that.pharmacyCityId,_that.pharmacyPartner,_that.pharmacyCities,_that.needsPharmacyCitySelection,_that.checkoutCities,_that.cartBookingId,_that.cartItems,_that.cartAddresses,_that.paymentBreakdown,_that.paymentProviders,_that.paymentProvidersStatus,_that.paymentProvidersErrorMessage,_that.selectedPaymentProviderCode,_that.cartMessages,_that.checkoutInvalidItems,_that.prescriptionScan);case _:
  return null;

}
}

}

/// @nodoc


class _PharmacyState implements PharmacyState {
  const _PharmacyState({this.medicinesLoadingStateStatus = StateStatus.idle, final  List<PharmacyMedicineEntity> medicines = const [], this.medicinesErrorMessage, this.searchQuery = '', this.currentPage = 1, this.lastPage = 1, this.totalProducts = 0, this.isLoadingMore = false, this.productDetailLoadingStateStatus = StateStatus.idle, this.selectedProduct, final  List<PharmacyMedicineEntity> relatedProducts = const [], this.productDetailErrorMessage, this.productUnavailableInCity = false, this.selectedCity = '', this.pharmacyCityId, this.pharmacyPartner = '', final  List<PharmacyCityEntity> pharmacyCities = const [], this.needsPharmacyCitySelection = false, final  List<String> checkoutCities = const [], this.cartBookingId, final  List<PharmacyCartItemEntity> cartItems = const [], final  List<PharmacyCartAddressEntity> cartAddresses = const [], this.paymentBreakdown, final  List<PaymentProviderEntity> paymentProviders = const [], this.paymentProvidersStatus = StateStatus.idle, this.paymentProvidersErrorMessage, this.selectedPaymentProviderCode, this.cartMessages, final  List<PharmacyCartInvalidItemEntity> checkoutInvalidItems = const [], this.prescriptionScan = const PrescriptionScanState()}): _medicines = medicines,_relatedProducts = relatedProducts,_pharmacyCities = pharmacyCities,_checkoutCities = checkoutCities,_cartItems = cartItems,_cartAddresses = cartAddresses,_paymentProviders = paymentProviders,_checkoutInvalidItems = checkoutInvalidItems;
  

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
@override@JsonKey() final  bool productUnavailableInCity;
/// Stored pharmacy delivery city name (empty until the user confirms).
@override@JsonKey() final  String selectedCity;
@override final  int? pharmacyCityId;
@override@JsonKey() final  String pharmacyPartner;
 final  List<PharmacyCityEntity> _pharmacyCities;
@override@JsonKey() List<PharmacyCityEntity> get pharmacyCities {
  if (_pharmacyCities is EqualUnmodifiableListView) return _pharmacyCities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pharmacyCities);
}

@override@JsonKey() final  bool needsPharmacyCitySelection;
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

 final  List<PharmacyCartAddressEntity> _cartAddresses;
@override@JsonKey() List<PharmacyCartAddressEntity> get cartAddresses {
  if (_cartAddresses is EqualUnmodifiableListView) return _cartAddresses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cartAddresses);
}

@override final  PharmacyPaymentBreakdownEntity? paymentBreakdown;
 final  List<PaymentProviderEntity> _paymentProviders;
@override@JsonKey() List<PaymentProviderEntity> get paymentProviders {
  if (_paymentProviders is EqualUnmodifiableListView) return _paymentProviders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_paymentProviders);
}

@override@JsonKey() final  StateStatus paymentProvidersStatus;
@override final  String? paymentProvidersErrorMessage;
@override final  String? selectedPaymentProviderCode;
@override final  PharmacyCartMessagesEntity? cartMessages;
 final  List<PharmacyCartInvalidItemEntity> _checkoutInvalidItems;
@override@JsonKey() List<PharmacyCartInvalidItemEntity> get checkoutInvalidItems {
  if (_checkoutInvalidItems is EqualUnmodifiableListView) return _checkoutInvalidItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_checkoutInvalidItems);
}

@override@JsonKey() final  PrescriptionScanState prescriptionScan;

/// Create a copy of PharmacyState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PharmacyStateCopyWith<_PharmacyState> get copyWith => __$PharmacyStateCopyWithImpl<_PharmacyState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PharmacyState&&(identical(other.medicinesLoadingStateStatus, medicinesLoadingStateStatus) || other.medicinesLoadingStateStatus == medicinesLoadingStateStatus)&&const DeepCollectionEquality().equals(other._medicines, _medicines)&&(identical(other.medicinesErrorMessage, medicinesErrorMessage) || other.medicinesErrorMessage == medicinesErrorMessage)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.totalProducts, totalProducts) || other.totalProducts == totalProducts)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.productDetailLoadingStateStatus, productDetailLoadingStateStatus) || other.productDetailLoadingStateStatus == productDetailLoadingStateStatus)&&(identical(other.selectedProduct, selectedProduct) || other.selectedProduct == selectedProduct)&&const DeepCollectionEquality().equals(other._relatedProducts, _relatedProducts)&&(identical(other.productDetailErrorMessage, productDetailErrorMessage) || other.productDetailErrorMessage == productDetailErrorMessage)&&(identical(other.productUnavailableInCity, productUnavailableInCity) || other.productUnavailableInCity == productUnavailableInCity)&&(identical(other.selectedCity, selectedCity) || other.selectedCity == selectedCity)&&(identical(other.pharmacyCityId, pharmacyCityId) || other.pharmacyCityId == pharmacyCityId)&&(identical(other.pharmacyPartner, pharmacyPartner) || other.pharmacyPartner == pharmacyPartner)&&const DeepCollectionEquality().equals(other._pharmacyCities, _pharmacyCities)&&(identical(other.needsPharmacyCitySelection, needsPharmacyCitySelection) || other.needsPharmacyCitySelection == needsPharmacyCitySelection)&&const DeepCollectionEquality().equals(other._checkoutCities, _checkoutCities)&&(identical(other.cartBookingId, cartBookingId) || other.cartBookingId == cartBookingId)&&const DeepCollectionEquality().equals(other._cartItems, _cartItems)&&const DeepCollectionEquality().equals(other._cartAddresses, _cartAddresses)&&(identical(other.paymentBreakdown, paymentBreakdown) || other.paymentBreakdown == paymentBreakdown)&&const DeepCollectionEquality().equals(other._paymentProviders, _paymentProviders)&&(identical(other.paymentProvidersStatus, paymentProvidersStatus) || other.paymentProvidersStatus == paymentProvidersStatus)&&(identical(other.paymentProvidersErrorMessage, paymentProvidersErrorMessage) || other.paymentProvidersErrorMessage == paymentProvidersErrorMessage)&&(identical(other.selectedPaymentProviderCode, selectedPaymentProviderCode) || other.selectedPaymentProviderCode == selectedPaymentProviderCode)&&(identical(other.cartMessages, cartMessages) || other.cartMessages == cartMessages)&&const DeepCollectionEquality().equals(other._checkoutInvalidItems, _checkoutInvalidItems)&&(identical(other.prescriptionScan, prescriptionScan) || other.prescriptionScan == prescriptionScan));
}


@override
int get hashCode => Object.hashAll([runtimeType,medicinesLoadingStateStatus,const DeepCollectionEquality().hash(_medicines),medicinesErrorMessage,searchQuery,currentPage,lastPage,totalProducts,isLoadingMore,productDetailLoadingStateStatus,selectedProduct,const DeepCollectionEquality().hash(_relatedProducts),productDetailErrorMessage,productUnavailableInCity,selectedCity,pharmacyCityId,pharmacyPartner,const DeepCollectionEquality().hash(_pharmacyCities),needsPharmacyCitySelection,const DeepCollectionEquality().hash(_checkoutCities),cartBookingId,const DeepCollectionEquality().hash(_cartItems),const DeepCollectionEquality().hash(_cartAddresses),paymentBreakdown,const DeepCollectionEquality().hash(_paymentProviders),paymentProvidersStatus,paymentProvidersErrorMessage,selectedPaymentProviderCode,cartMessages,const DeepCollectionEquality().hash(_checkoutInvalidItems),prescriptionScan]);

@override
String toString() {
  return 'PharmacyState(medicinesLoadingStateStatus: $medicinesLoadingStateStatus, medicines: $medicines, medicinesErrorMessage: $medicinesErrorMessage, searchQuery: $searchQuery, currentPage: $currentPage, lastPage: $lastPage, totalProducts: $totalProducts, isLoadingMore: $isLoadingMore, productDetailLoadingStateStatus: $productDetailLoadingStateStatus, selectedProduct: $selectedProduct, relatedProducts: $relatedProducts, productDetailErrorMessage: $productDetailErrorMessage, productUnavailableInCity: $productUnavailableInCity, selectedCity: $selectedCity, pharmacyCityId: $pharmacyCityId, pharmacyPartner: $pharmacyPartner, pharmacyCities: $pharmacyCities, needsPharmacyCitySelection: $needsPharmacyCitySelection, checkoutCities: $checkoutCities, cartBookingId: $cartBookingId, cartItems: $cartItems, cartAddresses: $cartAddresses, paymentBreakdown: $paymentBreakdown, paymentProviders: $paymentProviders, paymentProvidersStatus: $paymentProvidersStatus, paymentProvidersErrorMessage: $paymentProvidersErrorMessage, selectedPaymentProviderCode: $selectedPaymentProviderCode, cartMessages: $cartMessages, checkoutInvalidItems: $checkoutInvalidItems, prescriptionScan: $prescriptionScan)';
}


}

/// @nodoc
abstract mixin class _$PharmacyStateCopyWith<$Res> implements $PharmacyStateCopyWith<$Res> {
  factory _$PharmacyStateCopyWith(_PharmacyState value, $Res Function(_PharmacyState) _then) = __$PharmacyStateCopyWithImpl;
@override @useResult
$Res call({
 StateStatus medicinesLoadingStateStatus, List<PharmacyMedicineEntity> medicines, String? medicinesErrorMessage, String searchQuery, int currentPage, int lastPage, int totalProducts, bool isLoadingMore, StateStatus productDetailLoadingStateStatus, PharmacyMedicineEntity? selectedProduct, List<PharmacyMedicineEntity> relatedProducts, String? productDetailErrorMessage, bool productUnavailableInCity, String selectedCity, int? pharmacyCityId, String pharmacyPartner, List<PharmacyCityEntity> pharmacyCities, bool needsPharmacyCitySelection, List<String> checkoutCities, String? cartBookingId, List<PharmacyCartItemEntity> cartItems, List<PharmacyCartAddressEntity> cartAddresses, PharmacyPaymentBreakdownEntity? paymentBreakdown, List<PaymentProviderEntity> paymentProviders, StateStatus paymentProvidersStatus, String? paymentProvidersErrorMessage, String? selectedPaymentProviderCode, PharmacyCartMessagesEntity? cartMessages, List<PharmacyCartInvalidItemEntity> checkoutInvalidItems, PrescriptionScanState prescriptionScan
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
@override @pragma('vm:prefer-inline') $Res call({Object? medicinesLoadingStateStatus = null,Object? medicines = null,Object? medicinesErrorMessage = freezed,Object? searchQuery = null,Object? currentPage = null,Object? lastPage = null,Object? totalProducts = null,Object? isLoadingMore = null,Object? productDetailLoadingStateStatus = null,Object? selectedProduct = freezed,Object? relatedProducts = null,Object? productDetailErrorMessage = freezed,Object? productUnavailableInCity = null,Object? selectedCity = null,Object? pharmacyCityId = freezed,Object? pharmacyPartner = null,Object? pharmacyCities = null,Object? needsPharmacyCitySelection = null,Object? checkoutCities = null,Object? cartBookingId = freezed,Object? cartItems = null,Object? cartAddresses = null,Object? paymentBreakdown = freezed,Object? paymentProviders = null,Object? paymentProvidersStatus = null,Object? paymentProvidersErrorMessage = freezed,Object? selectedPaymentProviderCode = freezed,Object? cartMessages = freezed,Object? checkoutInvalidItems = null,Object? prescriptionScan = null,}) {
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
as String?,productUnavailableInCity: null == productUnavailableInCity ? _self.productUnavailableInCity : productUnavailableInCity // ignore: cast_nullable_to_non_nullable
as bool,selectedCity: null == selectedCity ? _self.selectedCity : selectedCity // ignore: cast_nullable_to_non_nullable
as String,pharmacyCityId: freezed == pharmacyCityId ? _self.pharmacyCityId : pharmacyCityId // ignore: cast_nullable_to_non_nullable
as int?,pharmacyPartner: null == pharmacyPartner ? _self.pharmacyPartner : pharmacyPartner // ignore: cast_nullable_to_non_nullable
as String,pharmacyCities: null == pharmacyCities ? _self._pharmacyCities : pharmacyCities // ignore: cast_nullable_to_non_nullable
as List<PharmacyCityEntity>,needsPharmacyCitySelection: null == needsPharmacyCitySelection ? _self.needsPharmacyCitySelection : needsPharmacyCitySelection // ignore: cast_nullable_to_non_nullable
as bool,checkoutCities: null == checkoutCities ? _self._checkoutCities : checkoutCities // ignore: cast_nullable_to_non_nullable
as List<String>,cartBookingId: freezed == cartBookingId ? _self.cartBookingId : cartBookingId // ignore: cast_nullable_to_non_nullable
as String?,cartItems: null == cartItems ? _self._cartItems : cartItems // ignore: cast_nullable_to_non_nullable
as List<PharmacyCartItemEntity>,cartAddresses: null == cartAddresses ? _self._cartAddresses : cartAddresses // ignore: cast_nullable_to_non_nullable
as List<PharmacyCartAddressEntity>,paymentBreakdown: freezed == paymentBreakdown ? _self.paymentBreakdown : paymentBreakdown // ignore: cast_nullable_to_non_nullable
as PharmacyPaymentBreakdownEntity?,paymentProviders: null == paymentProviders ? _self._paymentProviders : paymentProviders // ignore: cast_nullable_to_non_nullable
as List<PaymentProviderEntity>,paymentProvidersStatus: null == paymentProvidersStatus ? _self.paymentProvidersStatus : paymentProvidersStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,paymentProvidersErrorMessage: freezed == paymentProvidersErrorMessage ? _self.paymentProvidersErrorMessage : paymentProvidersErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,selectedPaymentProviderCode: freezed == selectedPaymentProviderCode ? _self.selectedPaymentProviderCode : selectedPaymentProviderCode // ignore: cast_nullable_to_non_nullable
as String?,cartMessages: freezed == cartMessages ? _self.cartMessages : cartMessages // ignore: cast_nullable_to_non_nullable
as PharmacyCartMessagesEntity?,checkoutInvalidItems: null == checkoutInvalidItems ? _self._checkoutInvalidItems : checkoutInvalidItems // ignore: cast_nullable_to_non_nullable
as List<PharmacyCartInvalidItemEntity>,prescriptionScan: null == prescriptionScan ? _self.prescriptionScan : prescriptionScan // ignore: cast_nullable_to_non_nullable
as PrescriptionScanState,
  ));
}


}

// dart format on
