import '../../../../core/functional/functional_export.dart';
import '../../../../core/use_case/base_use_case.dart';
import '../entities/surgery_provider_details_entity.dart';
import '../repositories/surgery_repository.dart';

class GetSurgeryProviderDetailsParams {
  const GetSurgeryProviderDetailsParams({
    required this.surgeryId,
    required this.cityId,
    required this.doctorId,
  });

  final String surgeryId;
  final String cityId;
  final String doctorId;
}

class GetSurgeryProviderDetailsUseCase
    implements
        UseCase<SurgeryProviderDetailsEntity, GetSurgeryProviderDetailsParams> {
  GetSurgeryProviderDetailsUseCase({required this.repository});

  final SurgeryRepository repository;

  @override
  Future<Either<ErrorMsg, SurgeryProviderDetailsEntity>> call(
    GetSurgeryProviderDetailsParams params,
  ) async {
    return repository.getSurgeryProviderDetails(
      surgeryId: params.surgeryId,
      cityId: params.cityId,
      doctorId: params.doctorId,
    );
  }
}
