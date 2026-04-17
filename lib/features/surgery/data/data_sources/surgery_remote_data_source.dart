import '../models/surgery_content_model.dart';

abstract class SurgeryRemoteDataSource {
  Future<SurgeryContentModel> getSurgeryContent();
}
