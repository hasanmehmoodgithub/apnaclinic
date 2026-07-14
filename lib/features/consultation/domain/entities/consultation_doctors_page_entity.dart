import '../../presentation/constants/consultation_partner_filter_defaults.dart';
import '../../presentation/widgets/results_doctor_item.dart';

class ConsultationDoctorsPageEntity {
  const ConsultationDoctorsPageEntity({
    required this.doctors,
    required this.page,
    required this.limit,
    required this.total,
    this.partners = const [],
  });

  final List<ResultsDoctorItem> doctors;
  final int page;
  final int limit;
  final int total;
  final List<ConsultationPartnerFilterOption> partners;

  bool get hasMore => page * limit < total;
}
