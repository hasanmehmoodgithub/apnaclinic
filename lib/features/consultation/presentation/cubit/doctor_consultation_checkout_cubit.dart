import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/mock/doctor_consultation_checkout_mock_api.dart';
import 'doctor_consultation_checkout_state.dart';

class DoctorConsultationCheckoutCubit extends Cubit<DoctorConsultationCheckoutState> {
  DoctorConsultationCheckoutCubit({
    required DoctorConsultationCheckoutMockApi api,
  })  : _api = api,
        super(const DoctorConsultationCheckoutState(isLoading: true));

  final DoctorConsultationCheckoutMockApi _api;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final result = await _api.getCheckout();
      emit(
        state.copyWith(
          isLoading: false,
          data: result,
          selectedPaymentMethodId: result.selectedPaymentMethodId,
          clearError: true,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLoading: false, errorMessage: 'load_error'));
    }
  }

  void selectPaymentMethod(String id) {
    emit(state.copyWith(selectedPaymentMethodId: id));
  }
}
