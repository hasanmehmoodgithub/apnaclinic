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
    emit(state.copyWith(draftCode: value));
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
          ),
        );
      },
    );
  }

  /// Applies a pending draft code, or keeps an already-applied code.
  /// Returns false when the current chip is invalid.
  Future<bool> ensureValidated({
    required PromoCodeService service,
    required int amount,
  }) async {
    if (state.isApplied) return true;
    if (state.isInvalid) return false;
    if (state.isValidating) return false;

    final draft = state.draftCode.trim();
    if (draft.isEmpty) return true;

    await validate(service: service, amount: amount, code: draft);
    return state.isApplied;
  }

  void clear() {
    emit(const PromoCodeState());
  }
}
