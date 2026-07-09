import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/state_status.dart';
import '../../../account/domain/entities/account_item_entity.dart';

part 'profile_state.freezed.dart';

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(StateStatus.loading) StateStatus accountsStatus,
    @Default(<AccountItemEntity>[]) List<AccountItemEntity> accounts,
    String? accountsError,
    @Default(0) int profileRevision,
  }) = _ProfileState;
}
