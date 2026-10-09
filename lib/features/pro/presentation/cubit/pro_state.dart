import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/state_status.dart';
import '../../domain/entities/pro_catalog_entity.dart';
import '../../domain/entities/pro_membership_entity.dart';

part 'pro_state.freezed.dart';

@freezed
abstract class ProState with _$ProState {
  const factory ProState({
    @Default(StateStatus.idle) StateStatus loadingStateStatus,
    ProCatalogEntity? catalog,
    String? selectedPlanId,
    String? errorMessage,
    @Default(StateStatus.idle) StateStatus subscribeStateStatus,
    String? subscribeErrorMessage,
  }) = _ProState;

  const ProState._();

  bool get hasCatalog => catalog != null;

  ProMembershipEntity? get membership => catalog?.membership;

  bool get isCatalogLoading =>
      loadingStateStatus == StateStatus.loading ||
      (loadingStateStatus == StateStatus.refreshing && catalog == null);
}
