import '../../presentation/widgets/results_doctor_item.dart';

class ConsultationDoctorsPageEntity {
  const ConsultationDoctorsPageEntity({
    required this.doctors,
    required this.page,
    required this.limit,
    required this.total,
  });

  final List<ResultsDoctorItem> doctors;
  final int page;
  final int limit;
  final int total;

  bool get hasMore => page * limit < total;
}
