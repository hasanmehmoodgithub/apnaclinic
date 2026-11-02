import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/promo_code_service.dart';
import '../../domain/use_cases/validate_promo_code_use_case.dart';
import '../promo_code_analytics.dart';
import 'promo_code_state.dart';

class PromoCodeCubit extends Cubit<PromoCodeState> {
  PromoCodeCubit({required ValidatePromoCodeUseCase validateUseCase})
      : _validateUseCase = validateUseCase,
        super(const PromoCodeState());

  final ValidatePromoCodeUseCase _validateUseCase;

  /// Latest known Pro membership, used when a checkout revalidates a code.
  bool isPro = false;

  void onInputChanged(String value) {
    emit(state.copyWith(draftCode: value, needsApply: false));
  }

  /// Checkout may continue when no code is typed, or one is already applied.
  /// A typed code that was not submitted blocks checkout and asks the user to apply it.
  bool allowCheckout() {
    if (state.isValidating || state.isInvalid) return false;
    if (state.isApplied || state.draftCode.trim().isEmpty) return true;
    if (!state.needsApply) {
      emit(state.copyWith(needsApply: true));
    }
    return false;
  }

  void setIsPro(bool value) {
    isPro = value;
  }

  Future<void> validate({
    required PromoCodeService service,
    required int amount,
    bool? isPro,
    String? code,
  }) async {
    final member = isPro ?? this.isPro;
    this.isPro = member;
    final submitted = (code ?? state.draftCode).trim().toUpperCase();
    if (submitted.isEmpty || state.isValidating) return;

    PromoCodeAnalytics.logEntered(code: submitted, service: service);

    emit(
      state.copyWith(
        status: PromoCodeStatus.validating,
        draftCode: submitted,
        displayCode: submitted,
        clearResult: true,
        needsApply: false,
        clearErrorMessage: true,
      ),
    );

    final result = await _validateUseCase(
      ValidatePromoCodeParams(
        code: submitted,
        service: service,
        amount: amount < 0 ? 0 : amount,
        isPro: member,
      ),
    );

    if (isClosed) return;
    result.fold(
      (error) {
        PromoCodeAnalytics.logRejected(
          code: submitted,
          service: service,
          reason: PromoCodeAnalytics.reasonFromMessage(error),
        );
        emit(
          state.copyWith(
            status: PromoCodeStatus.invalid,
            displayCode: submitted,
            clearResult: true,
            needsApply: false,
            errorMessage: error.trim(),
          ),
        );
      },
      (entity) {
        PromoCodeAnalytics.logApplied(
          result: entity,
          service: service,
          isPro: member,
        );
        emit(
          state.copyWith(
            status: PromoCodeStatus.applied,
            draftCode: entity.code,
            displayCode: entity.code,
            result: entity,
            needsApply: false,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }

  void clear() {
    emit(const PromoCodeState());
  }
}
