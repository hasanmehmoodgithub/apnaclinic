// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'your_mvvm_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$YourMvvmState {
  List<YourMvvmModel> get items => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of YourMvvmState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $YourMvvmStateCopyWith<YourMvvmState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $YourMvvmStateCopyWith<$Res> {
  factory $YourMvvmStateCopyWith(
    YourMvvmState value,
    $Res Function(YourMvvmState) then,
  ) = _$YourMvvmStateCopyWithImpl<$Res, YourMvvmState>;
  @useResult
  $Res call({List<YourMvvmModel> items, bool isLoading, String? errorMessage});
}

/// @nodoc
class _$YourMvvmStateCopyWithImpl<$Res, $Val extends YourMvvmState>
    implements $YourMvvmStateCopyWith<$Res> {
  _$YourMvvmStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of YourMvvmState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<YourMvvmModel>,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$YourMvvmStateImplCopyWith<$Res>
    implements $YourMvvmStateCopyWith<$Res> {
  factory _$$YourMvvmStateImplCopyWith(
    _$YourMvvmStateImpl value,
    $Res Function(_$YourMvvmStateImpl) then,
  ) = __$$YourMvvmStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<YourMvvmModel> items, bool isLoading, String? errorMessage});
}

/// @nodoc
class __$$YourMvvmStateImplCopyWithImpl<$Res>
    extends _$YourMvvmStateCopyWithImpl<$Res, _$YourMvvmStateImpl>
    implements _$$YourMvvmStateImplCopyWith<$Res> {
  __$$YourMvvmStateImplCopyWithImpl(
    _$YourMvvmStateImpl _value,
    $Res Function(_$YourMvvmStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of YourMvvmState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$YourMvvmStateImpl(
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<YourMvvmModel>,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$YourMvvmStateImpl extends _YourMvvmState {
  const _$YourMvvmStateImpl({
    final List<YourMvvmModel> items = const [],
    this.isLoading = false,
    this.errorMessage,
  }) : _items = items,
       super._();

  final List<YourMvvmModel> _items;
  @override
  @JsonKey()
  List<YourMvvmModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'YourMvvmState(items: $items, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$YourMvvmStateImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_items),
    isLoading,
    errorMessage,
  );

  /// Create a copy of YourMvvmState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$YourMvvmStateImplCopyWith<_$YourMvvmStateImpl> get copyWith =>
      __$$YourMvvmStateImplCopyWithImpl<_$YourMvvmStateImpl>(this, _$identity);
}

abstract class _YourMvvmState extends YourMvvmState {
  const factory _YourMvvmState({
    final List<YourMvvmModel> items,
    final bool isLoading,
    final String? errorMessage,
  }) = _$YourMvvmStateImpl;
  const _YourMvvmState._() : super._();

  @override
  List<YourMvvmModel> get items;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;

  /// Create a copy of YourMvvmState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$YourMvvmStateImplCopyWith<_$YourMvvmStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
