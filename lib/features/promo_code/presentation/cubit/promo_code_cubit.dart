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

  Future<void> validate({
    required PromoCodeService service,
    required int amount,
    String? code,
  }) async {
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
      ),
    );

    final result = await _validateUseCase(
      ValidatePromoCodeParams(
        code: submitted,
        service: service,
        amount: amount < 0 ? 0 : amount,
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
          ),
        );
      },
      (entity) {
        PromoCodeAnalytics.logApplied(result: entity, service: service);
        emit(
          state.copyWith(
            status: PromoCodeStatus.applied,
            draftCode: entity.code,
            displayCode: entity.code,
            result: entity,
            needsApply: false,
          ),
        );
      },
    );
  }

  void clear() {
    emit(const PromoCodeState());
  }
}
