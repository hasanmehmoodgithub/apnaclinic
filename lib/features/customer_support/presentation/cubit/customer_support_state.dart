import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/state_status.dart';
import '../../domain/entities/customer_support_entity.dart';

part 'customer_support_state.freezed.dart';

@freezed
abstract class CustomerSupportState with _$CustomerSupportState {
  const factory CustomerSupportState({
    @Default(StateStatus.idle) StateStatus loadingStateStatus,
    CustomerSupportEntity? content,
    String? errorMessage,
  }) = _CustomerSupportState;
}
