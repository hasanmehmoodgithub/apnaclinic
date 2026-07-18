import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/preference/app_pref.dart';
import '../../../../core/utils/auth_api_utils.dart';
import '../../../../core/utils/jwt_utils.dart';
import '../../data/models/doctor_consultation_checkout_model.dart';
import '../../data/utils/consultation_booking_utils.dart';
import '../../domain/use_cases/get_payment_providers_use_case.dart';
import '../../domain/use_cases/submit_consultation_booking_use_case.dart';
import '../doctor_consultation_checkout_args.dart';
import 'doctor_consultation_checkout_state.dart';

class DoctorConsultationCheckoutCubit extends Cubit<DoctorConsultationCheckoutState> {
  DoctorConsultationCheckoutCubit({
    required GetPaymentProvidersUseCase getPaymentProvidersUseCase,
    required SubmitConsultationBookingUseCase submitBookingUseCase,
    required AppPref appPref,
  })  : _getPaymentProvidersUseCase = getPaymentProvidersUseCase,
        _submitBookingUseCase = submitBookingUseCase,
        _appPref = appPref,
        super(const DoctorConsultationCheckoutState(isLoading: true));

  final GetPaymentProvidersUseCase _getPaymentProvidersUseCase;
  final SubmitConsultationBookingUseCase _submitBookingUseCase;
  final AppPref _appPref;

  Future<void> load(DoctorConsultationCheckoutArgs args) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final providersResult = await _getPaymentProvidersUseCase(
      const GetPaymentProvidersParams(module: PaymentProviderModule.consultation),
    );
    providersResult.fold(
      (error) => emit(
        state.copyWith(
          isLoading: false,
          errorMessage: error,
        ),
      ),
      (providers) {
        final paymentOptions = providers
            .map(
              (provider) => DoctorConsultationPaymentOptionModel(
                code: provider.code,
                name: provider.name,
                iconUrl: provider.iconUrl,
              ),
            )
            .toList(growable: false);
        final billing = ConsultationBookingUtils.resolveBilling(args.doctor);

        emit(
          state.copyWith(
            isLoading: false,
            data: DoctorConsultationCheckoutModel(
              consultationFee: billing.$1,
              discount: billing.$2,
              paymentOptions: paymentOptions,
            ),
            selectedPaymentMethodId: paymentOptions.isNotEmpty
                ? paymentOptions.first.code
                : null,
            clearError: true,
          ),
        );
      },
    );
  }

  void selectPaymentMethod(String code) {
    emit(state.copyWith(selectedPaymentMethodId: code));
  }

  Future<bool> submitBooking({
    required DoctorConsultationCheckoutArgs args,
    required String paymentMethodCode,
    required String msisdn,
  }) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));

    final doctorId = ConsultationBookingUtils.resolveDoctorId(args.doctor);
    // Booking API expects the doctor's partner tenantId, not the logged-in user's JWT tenant.
    final tenantId = ConsultationBookingUtils.parsePositiveInt(
          args.doctor.tenantId,
        ) ??
        0;
    final patientId = _resolvePatientId();
    final normalizedMsisdn = AuthApiUtils.normalizeMsisdn(msisdn);

    if (doctorId <= 0 || tenantId <= 0 || patientId <= 0) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: 'invalid_booking_context',
        ),
      );
      return false;
    }

    if (normalizedMsisdn.isEmpty) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: 'missing_msisdn',
        ),
      );
      return false;
    }

    final result = await _submitBookingUseCase(
      SubmitConsultationBookingParams(
        doctorId: doctorId,
        tenantId: tenantId,
        consultationFee:
            ConsultationBookingUtils.resolveConsultationFee(args.doctor),
        patientId: patientId,
        patientRelation: 'self',
        slotDate: args.selectedSlot.date,
        slotStartTime: args.selectedSlot.startTime,
        slotEndTime: args.selectedSlot.endTime,
        paymentMethod:
            ConsultationBookingUtils.paymentMethodApiValue(paymentMethodCode),
        msisdn: normalizedMsisdn,
        issue: args.issueDescription.trim(),
        attachments: args.attachments,
      ),
    );

    return result.fold(
      (error) {
        emit(
          state.copyWith(
            isSubmitting: false,
            errorMessage: error,
          ),
        );
        return false;
      },
      (_) {
        emit(state.copyWith(isSubmitting: false, clearError: true));
        return true;
      },
    );
  }

  int _resolvePatientId() {
    final token = _appPref.getToken();
    final claim = JwtUtils.claim<dynamic>(token, 'sub') ??
        JwtUtils.claim<dynamic>(token, 'userId');
    return ConsultationBookingUtils.parsePositiveInt(claim?.toString()) ??
        ConsultationBookingUtils.parsePositiveInt(_appPref.getUserId()) ??
        0;
  }
}
