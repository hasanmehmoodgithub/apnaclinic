import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/enums/state_status.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/utils/auth_guard.dart';
import '../../../../core/utils/phone_format_utils.dart';
import '../../domain/use_cases/get_instant_doctor_content_params.dart';
import '../../domain/use_cases/get_instant_doctor_content_use_case.dart';
import 'instant_doctor_state.dart';

class InstantDoctorCubit extends Cubit<InstantDoctorState> {
  InstantDoctorCubit({
    required this.getContentUseCase,
    required this.appPref,
  }) : super(const InstantDoctorState()) {
    loadContent();
  }

  final GetInstantDoctorContentUseCase getContentUseCase;
  final AppPref appPref;

  Future<void> loadContent() async {
    if (!AuthGuard.isLoggedIn(appPref)) {
      emit(
        state.copyWith(
          loadingStateStatus: StateStatus.idle,
          content: null,
          errorMessage: null,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        loadingStateStatus: StateStatus.loading,
        errorMessage: null,
      ),
    );

    final phone = appPref.getUserLocalModel()?.phone ?? '';
    final msisdn = PhoneFormatUtils.toMsisdn(phone);
    if (msisdn.isEmpty) {
      emit(
        state.copyWith(
          loadingStateStatus: StateStatus.error,
          errorMessage: 'Phone number is required for instant doctor.',
        ),
      );
      return;
    }

    final result = await getContentUseCase(
      GetInstantDoctorContentParams(msisdn: msisdn),
    );
    result.fold(
      (error) => emit(
        state.copyWith(
          loadingStateStatus: StateStatus.error,
          errorMessage: error,
        ),
      ),
      (content) => emit(
        state.copyWith(
          loadingStateStatus: content.bulletPoints.isEmpty
              ? StateStatus.empty
              : StateStatus.success,
          content: content,
          errorMessage: null,
        ),
      ),
    );
  }

  Future<bool> openConsultationPage() async {
    final redirectUrl = state.content?.redirectUrl ?? '';
    if (redirectUrl.isEmpty) {
      return false;
    }

    emit(state.copyWith(isOpeningApp: true));
    try {
      final uri = Uri.parse(redirectUrl);
      return await launchUrl(uri, mode: LaunchMode.inAppWebView);
    } catch (_) {
      return false;
    } finally {
      emit(state.copyWith(isOpeningApp: false));
    }
  }
}
