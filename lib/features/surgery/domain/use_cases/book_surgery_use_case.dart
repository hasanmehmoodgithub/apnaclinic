import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../repositories/surgery_repository.dart';

class BookSurgeryParams {
  const BookSurgeryParams({
    required this.leadId,
    required this.paymentMethod,
    required this.msisdn,
  });

  final int leadId;
  final String paymentMethod;
  final String msisdn;
}

class BookSurgeryUseCase implements UseCaseVoid<BookSurgeryParams> {
  BookSurgeryUseCase({required this.repository});

  final SurgeryRepository repository;

  @override
  Future<Either<ErrorMsg, void>> call(BookSurgeryParams params) {
    return repository.bookSurgery(params);
  }
}
