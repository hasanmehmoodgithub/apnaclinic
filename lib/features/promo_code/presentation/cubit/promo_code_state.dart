import 'package:equatable/equatable.dart';

import '../../domain/entities/promo_code_validation_entity.dart';

enum PromoCodeStatus { idle, validating, applied, invalid }

class PromoCodeState extends Equatable {
  const PromoCodeState({
    this.status = PromoCodeStatus.idle,
    this.draftCode = '',
    this.displayCode = '',
    this.result,
    this.needsApply = false,
  });

  final PromoCodeStatus status;
  final String draftCode;
  final String displayCode;
  final PromoCodeValidationEntity? result;

  /// True when a code was typed but not applied, and checkout was attempted.
  final bool needsApply;

  bool get isValidating => status == PromoCodeStatus.validating;
  bool get isApplied =>
      status == PromoCodeStatus.applied && result != null;
  bool get isInvalid => status == PromoCodeStatus.invalid;
  bool get showsChip =>
      status == PromoCodeStatus.applied || status == PromoCodeStatus.invalid;

  int payableTotal(int fallbackTotal) {
    if (isApplied) return result!.payableAmount;
    return fallbackTotal;
  }

  int displayDiscount(int fallbackDiscount) {
    if (isApplied) return result!.discountAmount;
    return fallbackDiscount;
  }

  String? get appliedCode => isApplied ? result!.code : null;

  PromoCodeState copyWith({
    PromoCodeStatus? status,
    String? draftCode,
    String? displayCode,
    PromoCodeValidationEntity? result,
    bool clearResult = false,
    bool? needsApply,
  }) {
    return PromoCodeState(
      status: status ?? this.status,
      draftCode: draftCode ?? this.draftCode,
      displayCode: displayCode ?? this.displayCode,
      result: clearResult ? null : (result ?? this.result),
      needsApply: needsApply ?? this.needsApply,
    );
  }

  @override
  List<Object?> get props => [status, draftCode, displayCode, result, needsApply];
}
