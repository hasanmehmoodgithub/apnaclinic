import '../../../../core/network/api_service.dart';
import '../mock/free_doctor_mock_api.dart';
import '../models/free_doctor_model.dart';
import 'free_doctor_remote_data_source.dart';

class FreeDoctorRemoteDataSourceImpl implements FreeDoctorRemoteDataSource {
  FreeDoctorRemoteDataSourceImpl({
    required this.apiService,
    required this.mockApi,
  });

  final ApiService apiService;
  final FreeDoctorMockApi mockApi;

  @override
  Future<FreeDoctorModel> getFreeDoctorContent() async {
    // TODO: Replace with real API call using apiService.
    final response = await mockApi.getFreeDoctorData();
    return FreeDoctorModel.fromJson(response);
  }
}
