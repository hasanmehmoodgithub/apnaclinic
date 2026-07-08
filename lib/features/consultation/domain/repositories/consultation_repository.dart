import '../../../../core/functional/functional_export.dart';
import '../../presentation/widgets/results_doctor_item.dart';
import '../entities/consultation_category_entity.dart';
import '../entities/consultation_doctor_slots_entity.dart';

abstract class ConsultationRepository {
  Future<Either<ErrorMsg, List<ConsultationCategoryEntity>>> getCategories();
  Future<Either<ErrorMsg, List<ResultsDoctorItem>>> getDoctors({
    required String mainCategoryId,
  });
  Future<Either<ErrorMsg, ConsultationDoctorSlotsEntity>> getDoctorSlots({
    required String doctorId,
    String? hospitalId,
  });
}
