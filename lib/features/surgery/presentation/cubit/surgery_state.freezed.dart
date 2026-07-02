// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'surgery_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SurgeryState {

 StateStatus get loadingStateStatus; SurgeryContentEntity get content; String get selectedCity; String get searchQuery; Set<String> get selectedProcedureIds; String? get errorMessage; StateStatus get doctorsLoadingStateStatus; SurgeryDoctorsEntity get doctorsContent; String? get doctorsErrorMessage; StateStatus get patientFormLoadingStateStatus; SurgeryPatientFormEntity get patientForm; String? get patientFormErrorMessage; StateStatus get providerDetailsLoadingStateStatus; SurgeryProviderDetailsEntity get providerDetails; String? get providerDetailsErrorMessage;
/// Create a copy of SurgeryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SurgeryStateCopyWith<SurgeryState> get copyWith => _$SurgeryStateCopyWithImpl<SurgeryState>(this as SurgeryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SurgeryState&&(identical(other.loadingStateStatus, loadingStateStatus) || other.loadingStateStatus == loadingStateStatus)&&(identical(other.content, content) || other.content == content)&&(identical(other.selectedCity, selectedCity) || other.selectedCity == selectedCity)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&const DeepCollectionEquality().equals(other.selectedProcedureIds, selectedProcedureIds)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.doctorsLoadingStateStatus, doctorsLoadingStateStatus) || other.doctorsLoadingStateStatus == doctorsLoadingStateStatus)&&(identical(other.doctorsContent, doctorsContent) || other.doctorsContent == doctorsContent)&&(identical(other.doctorsErrorMessage, doctorsErrorMessage) || other.doctorsErrorMessage == doctorsErrorMessage)&&(identical(other.patientFormLoadingStateStatus, patientFormLoadingStateStatus) || other.patientFormLoadingStateStatus == patientFormLoadingStateStatus)&&(identical(other.patientForm, patientForm) || other.patientForm == patientForm)&&(identical(other.patientFormErrorMessage, patientFormErrorMessage) || other.patientFormErrorMessage == patientFormErrorMessage)&&(identical(other.providerDetailsLoadingStateStatus, providerDetailsLoadingStateStatus) || other.providerDetailsLoadingStateStatus == providerDetailsLoadingStateStatus)&&(identical(other.providerDetails, providerDetails) || other.providerDetails == providerDetails)&&(identical(other.providerDetailsErrorMessage, providerDetailsErrorMessage) || other.providerDetailsErrorMessage == providerDetailsErrorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,loadingStateStatus,content,selectedCity,searchQuery,const DeepCollectionEquality().hash(selectedProcedureIds),errorMessage,doctorsLoadingStateStatus,doctorsContent,doctorsErrorMessage,patientFormLoadingStateStatus,patientForm,patientFormErrorMessage,providerDetailsLoadingStateStatus,providerDetails,providerDetailsErrorMessage);

@override
String toString() {
  return 'SurgeryState(loadingStateStatus: $loadingStateStatus, content: $content, selectedCity: $selectedCity, searchQuery: $searchQuery, selectedProcedureIds: $selectedProcedureIds, errorMessage: $errorMessage, doctorsLoadingStateStatus: $doctorsLoadingStateStatus, doctorsContent: $doctorsContent, doctorsErrorMessage: $doctorsErrorMessage, patientFormLoadingStateStatus: $patientFormLoadingStateStatus, patientForm: $patientForm, patientFormErrorMessage: $patientFormErrorMessage, providerDetailsLoadingStateStatus: $providerDetailsLoadingStateStatus, providerDetails: $providerDetails, providerDetailsErrorMessage: $providerDetailsErrorMessage)';
}


}

/// @nodoc
abstract mixin class $SurgeryStateCopyWith<$Res>  {
  factory $SurgeryStateCopyWith(SurgeryState value, $Res Function(SurgeryState) _then) = _$SurgeryStateCopyWithImpl;
@useResult
$Res call({
 StateStatus loadingStateStatus, SurgeryContentEntity content, String selectedCity, String searchQuery, Set<String> selectedProcedureIds, String? errorMessage, StateStatus doctorsLoadingStateStatus, SurgeryDoctorsEntity doctorsContent, String? doctorsErrorMessage, StateStatus patientFormLoadingStateStatus, SurgeryPatientFormEntity patientForm, String? patientFormErrorMessage, StateStatus providerDetailsLoadingStateStatus, SurgeryProviderDetailsEntity providerDetails, String? providerDetailsErrorMessage
});




}
/// @nodoc
class _$SurgeryStateCopyWithImpl<$Res>
    implements $SurgeryStateCopyWith<$Res> {
  _$SurgeryStateCopyWithImpl(this._self, this._then);

  final SurgeryState _self;
  final $Res Function(SurgeryState) _then;

/// Create a copy of SurgeryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loadingStateStatus = null,Object? content = null,Object? selectedCity = null,Object? searchQuery = null,Object? selectedProcedureIds = null,Object? errorMessage = freezed,Object? doctorsLoadingStateStatus = null,Object? doctorsContent = null,Object? doctorsErrorMessage = freezed,Object? patientFormLoadingStateStatus = null,Object? patientForm = null,Object? patientFormErrorMessage = freezed,Object? providerDetailsLoadingStateStatus = null,Object? providerDetails = null,Object? providerDetailsErrorMessage = freezed,}) {
  return _then(_self.copyWith(
loadingStateStatus: null == loadingStateStatus ? _self.loadingStateStatus : loadingStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as SurgeryContentEntity,selectedCity: null == selectedCity ? _self.selectedCity : selectedCity // ignore: cast_nullable_to_non_nullable
as String,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,selectedProcedureIds: null == selectedProcedureIds ? _self.selectedProcedureIds : selectedProcedureIds // ignore: cast_nullable_to_non_nullable
as Set<String>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,doctorsLoadingStateStatus: null == doctorsLoadingStateStatus ? _self.doctorsLoadingStateStatus : doctorsLoadingStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,doctorsContent: null == doctorsContent ? _self.doctorsContent : doctorsContent // ignore: cast_nullable_to_non_nullable
as SurgeryDoctorsEntity,doctorsErrorMessage: freezed == doctorsErrorMessage ? _self.doctorsErrorMessage : doctorsErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,patientFormLoadingStateStatus: null == patientFormLoadingStateStatus ? _self.patientFormLoadingStateStatus : patientFormLoadingStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,patientForm: null == patientForm ? _self.patientForm : patientForm // ignore: cast_nullable_to_non_nullable
as SurgeryPatientFormEntity,patientFormErrorMessage: freezed == patientFormErrorMessage ? _self.patientFormErrorMessage : patientFormErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,providerDetailsLoadingStateStatus: null == providerDetailsLoadingStateStatus ? _self.providerDetailsLoadingStateStatus : providerDetailsLoadingStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,providerDetails: null == providerDetails ? _self.providerDetails : providerDetails // ignore: cast_nullable_to_non_nullable
as SurgeryProviderDetailsEntity,providerDetailsErrorMessage: freezed == providerDetailsErrorMessage ? _self.providerDetailsErrorMessage : providerDetailsErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SurgeryState].
extension SurgeryStatePatterns on SurgeryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SurgeryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SurgeryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SurgeryState value)  $default,){
final _that = this;
switch (_that) {
case _SurgeryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SurgeryState value)?  $default,){
final _that = this;
switch (_that) {
case _SurgeryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StateStatus loadingStateStatus,  SurgeryContentEntity content,  String selectedCity,  String searchQuery,  Set<String> selectedProcedureIds,  String? errorMessage,  StateStatus doctorsLoadingStateStatus,  SurgeryDoctorsEntity doctorsContent,  String? doctorsErrorMessage,  StateStatus patientFormLoadingStateStatus,  SurgeryPatientFormEntity patientForm,  String? patientFormErrorMessage,  StateStatus providerDetailsLoadingStateStatus,  SurgeryProviderDetailsEntity providerDetails,  String? providerDetailsErrorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SurgeryState() when $default != null:
return $default(_that.loadingStateStatus,_that.content,_that.selectedCity,_that.searchQuery,_that.selectedProcedureIds,_that.errorMessage,_that.doctorsLoadingStateStatus,_that.doctorsContent,_that.doctorsErrorMessage,_that.patientFormLoadingStateStatus,_that.patientForm,_that.patientFormErrorMessage,_that.providerDetailsLoadingStateStatus,_that.providerDetails,_that.providerDetailsErrorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StateStatus loadingStateStatus,  SurgeryContentEntity content,  String selectedCity,  String searchQuery,  Set<String> selectedProcedureIds,  String? errorMessage,  StateStatus doctorsLoadingStateStatus,  SurgeryDoctorsEntity doctorsContent,  String? doctorsErrorMessage,  StateStatus patientFormLoadingStateStatus,  SurgeryPatientFormEntity patientForm,  String? patientFormErrorMessage,  StateStatus providerDetailsLoadingStateStatus,  SurgeryProviderDetailsEntity providerDetails,  String? providerDetailsErrorMessage)  $default,) {final _that = this;
switch (_that) {
case _SurgeryState():
return $default(_that.loadingStateStatus,_that.content,_that.selectedCity,_that.searchQuery,_that.selectedProcedureIds,_that.errorMessage,_that.doctorsLoadingStateStatus,_that.doctorsContent,_that.doctorsErrorMessage,_that.patientFormLoadingStateStatus,_that.patientForm,_that.patientFormErrorMessage,_that.providerDetailsLoadingStateStatus,_that.providerDetails,_that.providerDetailsErrorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StateStatus loadingStateStatus,  SurgeryContentEntity content,  String selectedCity,  String searchQuery,  Set<String> selectedProcedureIds,  String? errorMessage,  StateStatus doctorsLoadingStateStatus,  SurgeryDoctorsEntity doctorsContent,  String? doctorsErrorMessage,  StateStatus patientFormLoadingStateStatus,  SurgeryPatientFormEntity patientForm,  String? patientFormErrorMessage,  StateStatus providerDetailsLoadingStateStatus,  SurgeryProviderDetailsEntity providerDetails,  String? providerDetailsErrorMessage)?  $default,) {final _that = this;
switch (_that) {
case _SurgeryState() when $default != null:
return $default(_that.loadingStateStatus,_that.content,_that.selectedCity,_that.searchQuery,_that.selectedProcedureIds,_that.errorMessage,_that.doctorsLoadingStateStatus,_that.doctorsContent,_that.doctorsErrorMessage,_that.patientFormLoadingStateStatus,_that.patientForm,_that.patientFormErrorMessage,_that.providerDetailsLoadingStateStatus,_that.providerDetails,_that.providerDetailsErrorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _SurgeryState implements SurgeryState {
  const _SurgeryState({this.loadingStateStatus = StateStatus.idle, this.content = const SurgeryContentEntity(cities: [], defaultCity: '', procedures: []), this.selectedCity = '', this.searchQuery = '', final  Set<String> selectedProcedureIds = const {}, this.errorMessage, this.doctorsLoadingStateStatus = StateStatus.idle, this.doctorsContent = const SurgeryDoctorsEntity(procedureName: '', city: '', hospitals: [], specialties: [], doctors: []), this.doctorsErrorMessage, this.patientFormLoadingStateStatus = StateStatus.idle, this.patientForm = SurgeryPatientFormEntity.empty, this.patientFormErrorMessage, this.providerDetailsLoadingStateStatus = StateStatus.idle, this.providerDetails = SurgeryProviderDetailsEntity.empty, this.providerDetailsErrorMessage}): _selectedProcedureIds = selectedProcedureIds;
  

@override@JsonKey() final  StateStatus loadingStateStatus;
@override@JsonKey() final  SurgeryContentEntity content;
@override@JsonKey() final  String selectedCity;
@override@JsonKey() final  String searchQuery;
 final  Set<String> _selectedProcedureIds;
@override@JsonKey() Set<String> get selectedProcedureIds {
  if (_selectedProcedureIds is EqualUnmodifiableSetView) return _selectedProcedureIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_selectedProcedureIds);
}

@override final  String? errorMessage;
@override@JsonKey() final  StateStatus doctorsLoadingStateStatus;
@override@JsonKey() final  SurgeryDoctorsEntity doctorsContent;
@override final  String? doctorsErrorMessage;
@override@JsonKey() final  StateStatus patientFormLoadingStateStatus;
@override@JsonKey() final  SurgeryPatientFormEntity patientForm;
@override final  String? patientFormErrorMessage;
@override@JsonKey() final  StateStatus providerDetailsLoadingStateStatus;
@override@JsonKey() final  SurgeryProviderDetailsEntity providerDetails;
@override final  String? providerDetailsErrorMessage;

/// Create a copy of SurgeryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SurgeryStateCopyWith<_SurgeryState> get copyWith => __$SurgeryStateCopyWithImpl<_SurgeryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SurgeryState&&(identical(other.loadingStateStatus, loadingStateStatus) || other.loadingStateStatus == loadingStateStatus)&&(identical(other.content, content) || other.content == content)&&(identical(other.selectedCity, selectedCity) || other.selectedCity == selectedCity)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&const DeepCollectionEquality().equals(other._selectedProcedureIds, _selectedProcedureIds)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.doctorsLoadingStateStatus, doctorsLoadingStateStatus) || other.doctorsLoadingStateStatus == doctorsLoadingStateStatus)&&(identical(other.doctorsContent, doctorsContent) || other.doctorsContent == doctorsContent)&&(identical(other.doctorsErrorMessage, doctorsErrorMessage) || other.doctorsErrorMessage == doctorsErrorMessage)&&(identical(other.patientFormLoadingStateStatus, patientFormLoadingStateStatus) || other.patientFormLoadingStateStatus == patientFormLoadingStateStatus)&&(identical(other.patientForm, patientForm) || other.patientForm == patientForm)&&(identical(other.patientFormErrorMessage, patientFormErrorMessage) || other.patientFormErrorMessage == patientFormErrorMessage)&&(identical(other.providerDetailsLoadingStateStatus, providerDetailsLoadingStateStatus) || other.providerDetailsLoadingStateStatus == providerDetailsLoadingStateStatus)&&(identical(other.providerDetails, providerDetails) || other.providerDetails == providerDetails)&&(identical(other.providerDetailsErrorMessage, providerDetailsErrorMessage) || other.providerDetailsErrorMessage == providerDetailsErrorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,loadingStateStatus,content,selectedCity,searchQuery,const DeepCollectionEquality().hash(_selectedProcedureIds),errorMessage,doctorsLoadingStateStatus,doctorsContent,doctorsErrorMessage,patientFormLoadingStateStatus,patientForm,patientFormErrorMessage,providerDetailsLoadingStateStatus,providerDetails,providerDetailsErrorMessage);

@override
String toString() {
  return 'SurgeryState(loadingStateStatus: $loadingStateStatus, content: $content, selectedCity: $selectedCity, searchQuery: $searchQuery, selectedProcedureIds: $selectedProcedureIds, errorMessage: $errorMessage, doctorsLoadingStateStatus: $doctorsLoadingStateStatus, doctorsContent: $doctorsContent, doctorsErrorMessage: $doctorsErrorMessage, patientFormLoadingStateStatus: $patientFormLoadingStateStatus, patientForm: $patientForm, patientFormErrorMessage: $patientFormErrorMessage, providerDetailsLoadingStateStatus: $providerDetailsLoadingStateStatus, providerDetails: $providerDetails, providerDetailsErrorMessage: $providerDetailsErrorMessage)';
}


}

/// @nodoc
abstract mixin class _$SurgeryStateCopyWith<$Res> implements $SurgeryStateCopyWith<$Res> {
  factory _$SurgeryStateCopyWith(_SurgeryState value, $Res Function(_SurgeryState) _then) = __$SurgeryStateCopyWithImpl;
@override @useResult
$Res call({
 StateStatus loadingStateStatus, SurgeryContentEntity content, String selectedCity, String searchQuery, Set<String> selectedProcedureIds, String? errorMessage, StateStatus doctorsLoadingStateStatus, SurgeryDoctorsEntity doctorsContent, String? doctorsErrorMessage, StateStatus patientFormLoadingStateStatus, SurgeryPatientFormEntity patientForm, String? patientFormErrorMessage, StateStatus providerDetailsLoadingStateStatus, SurgeryProviderDetailsEntity providerDetails, String? providerDetailsErrorMessage
});




}
/// @nodoc
class __$SurgeryStateCopyWithImpl<$Res>
    implements _$SurgeryStateCopyWith<$Res> {
  __$SurgeryStateCopyWithImpl(this._self, this._then);

  final _SurgeryState _self;
  final $Res Function(_SurgeryState) _then;

/// Create a copy of SurgeryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loadingStateStatus = null,Object? content = null,Object? selectedCity = null,Object? searchQuery = null,Object? selectedProcedureIds = null,Object? errorMessage = freezed,Object? doctorsLoadingStateStatus = null,Object? doctorsContent = null,Object? doctorsErrorMessage = freezed,Object? patientFormLoadingStateStatus = null,Object? patientForm = null,Object? patientFormErrorMessage = freezed,Object? providerDetailsLoadingStateStatus = null,Object? providerDetails = null,Object? providerDetailsErrorMessage = freezed,}) {
  return _then(_SurgeryState(
loadingStateStatus: null == loadingStateStatus ? _self.loadingStateStatus : loadingStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as SurgeryContentEntity,selectedCity: null == selectedCity ? _self.selectedCity : selectedCity // ignore: cast_nullable_to_non_nullable
as String,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,selectedProcedureIds: null == selectedProcedureIds ? _self._selectedProcedureIds : selectedProcedureIds // ignore: cast_nullable_to_non_nullable
as Set<String>,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,doctorsLoadingStateStatus: null == doctorsLoadingStateStatus ? _self.doctorsLoadingStateStatus : doctorsLoadingStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,doctorsContent: null == doctorsContent ? _self.doctorsContent : doctorsContent // ignore: cast_nullable_to_non_nullable
as SurgeryDoctorsEntity,doctorsErrorMessage: freezed == doctorsErrorMessage ? _self.doctorsErrorMessage : doctorsErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,patientFormLoadingStateStatus: null == patientFormLoadingStateStatus ? _self.patientFormLoadingStateStatus : patientFormLoadingStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,patientForm: null == patientForm ? _self.patientForm : patientForm // ignore: cast_nullable_to_non_nullable
as SurgeryPatientFormEntity,patientFormErrorMessage: freezed == patientFormErrorMessage ? _self.patientFormErrorMessage : patientFormErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,providerDetailsLoadingStateStatus: null == providerDetailsLoadingStateStatus ? _self.providerDetailsLoadingStateStatus : providerDetailsLoadingStateStatus // ignore: cast_nullable_to_non_nullable
as StateStatus,providerDetails: null == providerDetails ? _self.providerDetails : providerDetails // ignore: cast_nullable_to_non_nullable
as SurgeryProviderDetailsEntity,providerDetailsErrorMessage: freezed == providerDetailsErrorMessage ? _self.providerDetailsErrorMessage : providerDetailsErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
