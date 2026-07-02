import '../../../../core/functional/functional_export.dart';
import '../../domain/entities/consultation_category_entity.dart';
import '../../domain/entities/consultation_doctor_slots_entity.dart';
import '../../domain/repositories/consultation_repository.dart';
import '../../presentation/widgets/results_doctor_item.dart';
import '../data_sources/consultation_remote_data_source.dart';
import '../utils/consultation_slots_error_utils.dart';

class ConsultationRepositoryImpl implements ConsultationRepository {
  ConsultationRepositoryImpl({required this.remoteDataSource});

  final ConsultationRemoteDataSource remoteDataSource;

  @override
  Future<Either<ErrorMsg, List<ConsultationCategoryEntity>>>
  getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Right(categories);
    } catch (e) {
      if (e is String && e.trim().isNotEmpty) {
        return Left(e.trim());
      }
      return const Left('Unable to load consultation categories.');
    }
  }

  @override
  Future<Either<ErrorMsg, List<ResultsDoctorItem>>> getDoctors({
    required String mainCategoryId,
  }) async {
    try {
      final doctors = await remoteDataSource.getDoctors(
        mainCategoryId: mainCategoryId,
      );
      return Right(doctors.map((doctor) => doctor.toResultsDoctorItem()).toList());
    } catch (e) {
      if (e is String && e.trim().isNotEmpty) {
        return Left(e.trim());
      }
      return const Left('Unable to load doctors right now.');
    }
  }

  @override
  Future<Either<ErrorMsg, ConsultationDoctorSlotsEntity>> getDoctorSlots({
    required String doctorId,
    String? hospitalId,
  }) async {
    try {
      if (doctorId.trim().isEmpty) {
        return const Left('Doctor not found. Please try again.');
      }

      final model = await remoteDataSource.getDoctorSlots(
        doctorId: doctorId,
        hospitalId: hospitalId,
      );
      return Right(model.toEntity());
    } catch (e) {
      final raw = e is String && e.trim().isNotEmpty
          ? e.trim()
          : 'Unable to load availability right now.';
      return Left(ConsultationSlotsErrorUtils.toUserMessage(raw));
    }
  }
}
