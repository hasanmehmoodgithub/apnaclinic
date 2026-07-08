import '../../presentation/widgets/results_doctor_item.dart';

class ConsultationBookingUtils {
  ConsultationBookingUtils._();

  static int? parsePositiveInt(String? value) {
    final parsed = int.tryParse(value?.trim() ?? '');
    if (parsed == null || parsed <= 0) return null;
    return parsed;
  }

  static int resolveDoctorId(ResultsDoctorItem doctor) {
    return parsePositiveInt(doctor.apiDoctorId) ??
        parsePositiveInt(doctor.id) ??
        0;
  }

  static int resolveConsultationFee(ResultsDoctorItem doctor) {
    final fee = doctor.fee.trim().toLowerCase();
    if (fee.contains('free')) return 0;

    final match = RegExp(r'(\d+)').firstMatch(doctor.fee.replaceAll(',', ''));
    return int.tryParse(match?.group(1) ?? '') ?? 0;
  }

  static (int consultationFee, int discount) resolveBilling(ResultsDoctorItem doctor) {
    final payable = resolveConsultationFee(doctor);
    final oldMatch =
        RegExp(r'(\d+)').firstMatch(doctor.oldFee.replaceAll(',', ''));
    final original = int.tryParse(oldMatch?.group(1) ?? '') ?? payable;
    final consultationFee = original > 0 ? original : payable;
    final discount = consultationFee > payable ? consultationFee - payable : 0;
    return (consultationFee, discount);
  }

  static bool isJazzCashCode(String code) =>
      code.trim().toUpperCase() == 'JAZZCASH';

  static String paymentMethodApiValue(String paymentMethodCode) =>
      paymentMethodCode.trim().toUpperCase();
}
