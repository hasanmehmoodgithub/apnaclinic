import 'package:freezed_annotation/freezed_annotation.dart';
import '../model/your_mvvm_model.dart';

part 'your_mvvm_state.freezed.dart';

/// State class for Your MVVM Feature
@freezed
class YourMvvmState with _$YourMvvmState {
  const factory YourMvvmState({
    @Default([]) List<YourMvvmModel> items,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _YourMvvmState;

  const YourMvvmState._();
}
