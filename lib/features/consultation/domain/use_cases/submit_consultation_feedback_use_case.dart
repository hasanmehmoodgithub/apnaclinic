import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../repositories/consultation_repository.dart';

class SubmitConsultationFeedbackParams {
  const SubmitConsultationFeedbackParams({
    required this.refNo,
    required this.rating,
    required this.review,
  });

  final String refNo;
  final double rating;
  final String review;
}

class SubmitConsultationFeedbackUseCase
    implements UseCase<void, SubmitConsultationFeedbackParams> {
  SubmitConsultationFeedbackUseCase({required this.repository});

  final ConsultationRepository repository;

  @override
  Future<Either<ErrorMsg, void>> call(
    SubmitConsultationFeedbackParams params,
  ) {
    return repository.submitFeedback(params);
  }
}
