import '../models/consultation_category_model.dart';
import '../models/consultation_doctor_model.dart';

abstract class ConsultationRemoteDataSource {
  Future<List<ConsultationCategoryModel>> getCategories();
  Future<List<ConsultationDoctorModel>> getDoctors({
    required String mainCategoryId,
  });
}
