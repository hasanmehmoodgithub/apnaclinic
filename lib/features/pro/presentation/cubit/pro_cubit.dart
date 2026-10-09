import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/utils/phone_format_utils.dart';
import '../../domain/entities/pro_subscribe_result_entity.dart';
import '../../domain/entities/pro_unsubscribe_result_entity.dart';
import '../../domain/use_cases/get_pro_catalog_use_case.dart';
import '../../domain/use_cases/subscribe_pro_params.dart';
import '../../domain/use_cases/subscribe_pro_use_case.dart';
import '../../domain/use_cases/unsubscribe_pro_params.dart';
import '../../domain/use_cases/unsubscribe_pro_use_case.dart';
import 'pro_state.dart';

class ProCubit extends Cubit<ProState> {
  ProCubit({
    required this.getCatalogUseCase,
    required this.subscribeProUseCase,
    required this.unsubscribeProUseCase,
  }) : super(const ProState());

  final GetProCatalogUseCase getCatalogUseCase;
  final SubscribeProUseCase subscribeProUseCase;
  final UnsubscribeProUseCase unsubscribeProUseCase;

  Future<void> loadCatalog({bool refresh = false}) async {
    emit(
      state.copyWith(
        loadingStateStatus:
            refresh ? StateStatus.refreshing : StateStatus.loading,
        errorMessage: null,
      ),
    );

    final result = await getCatalogUseCase();
    if (isClosed) return;
    result.fold(
      (error) {
        emit(
          state.copyWith(
            loadingStateStatus: StateStatus.error,
            errorMessage: error,
          ),
        );
      },
      (catalog) {
        final selected = state.selectedPlanId ?? catalog.defaultSelectedPlanId;
        emit(
          state.copyWith(
            loadingStateStatus: StateStatus.success,
            catalog: catalog,
            selectedPlanId: selected,
            errorMessage: null,
          ),
        );
      },
    );
  }

  void selectPlan(String planId) {
    if (planId == state.selectedPlanId) return;
    emit(state.copyWith(selectedPlanId: planId));
  }

  /// Posts `/pro/subscribe`. Null when the request fails.
  ///
  /// A non-null result with [ProSubscribeResultEntity.opensJazzCash] still
  /// needs the JazzCash WebView before the membership is treated as active.
  Future<ProSubscribeResultEntity?> subscribe({
    required String msisdn,
  }) async {
    final planPriceCode = state.selectedPlanId?.trim() ?? '';
    if (planPriceCode.isEmpty) return null;

    final localMsisdn = PhoneFormatUtils.toLocalDisplay(msisdn).trim();
    if (localMsisdn.isEmpty) {
      emit(
        state.copyWith(
          subscribeStateStatus: StateStatus.error,
          subscribeErrorMessage: AppStrings.proPhoneRequiredError,
        ),
      );
      return null;
    }

    emit(
      state.copyWith(
        subscribeStateStatus: StateStatus.loading,
        subscribeErrorMessage: null,
      ),
    );

    final result = await subscribeProUseCase(
      SubscribeProParams(
        planCode: SubscribeProParams.productPlanCode,
        planPriceCode: planPriceCode,
        msisdn: localMsisdn,
        channel: Platform.isIOS ? 'ios' : 'android',
      ),
    );
    if (isClosed) return null;

    return result.fold(
      (error) {
        emit(
          state.copyWith(
            subscribeStateStatus: StateStatus.error,
            subscribeErrorMessage: error,
          ),
        );
        return null;
      },
      (subscription) {
        emit(
          state.copyWith(
            subscribeStateStatus: StateStatus.success,
            subscribeErrorMessage: null,
          ),
        );
        return subscription;
      },
    );
  }

  /// Posts `/pro/unsubscribe` with `{ planCode }`. Null when the request fails.
  ///
  /// Shares [ProState.subscribeStateStatus] with subscribe. The two actions
  /// are never shown at the same time.
  Future<ProUnsubscribeResultEntity?> unsubscribe() async {
    if (state.subscribeStateStatus == StateStatus.loading) return null;

    final membershipCode = state.catalog?.membership.planId?.trim() ?? '';
    final planCode = membershipCode.isEmpty
        ? UnsubscribeProParams.productPlanCode
        : membershipCode;

    emit(
      state.copyWith(
        subscribeStateStatus: StateStatus.loading,
        subscribeErrorMessage: null,
      ),
    );

    final result = await unsubscribeProUseCase(
      UnsubscribeProParams(planCode: planCode),
    );
    if (isClosed) return null;

    return result.fold(
      (error) {
        emit(
          state.copyWith(
            subscribeStateStatus: StateStatus.error,
            subscribeErrorMessage: error,
          ),
        );
        return null;
      },
      (cancellation) {
        emit(
          state.copyWith(
            subscribeStateStatus: StateStatus.success,
            subscribeErrorMessage: null,
          ),
        );
        return cancellation;
      },
    );
  }
}
