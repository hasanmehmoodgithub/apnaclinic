import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/enums/state_status.dart';
import '../../domain/constants/free_doctor_constants.dart';
import '../../domain/use_cases/get_free_doctor_content_use_case.dart';
import 'free_doctor_state.dart';

class FreeDoctorCubit extends Cubit<FreeDoctorState> {
  FreeDoctorCubit({required this.getContentUseCase})
    : super(const FreeDoctorState()) {
    loadContent();
  }

  final GetFreeDoctorContentUseCase getContentUseCase;

  Future<void> loadContent() async {
    emit(
      state.copyWith(
        loadingStateStatus: StateStatus.loading,
        errorMessage: null,
      ),
    );
    final result = await getContentUseCase.call();
    result.fold(
      (error) => emit(
        state.copyWith(
          loadingStateStatus: StateStatus.error,
          errorMessage: error,
        ),
      ),
      (content) => emit(
        state.copyWith(
          loadingStateStatus: content.descriptionPoints.isEmpty
              ? StateStatus.empty
              : StateStatus.success,
          content: content,
          errorMessage: null,
        ),
      ),
    );
  }

  Future<bool> openSubscribePage() async {
    emit(state.copyWith(isOpeningApp: true));
    try {
      final uri = Uri.parse(FreeDoctorConstants.mHealthSubscribeUrl);
      return await launchUrl(uri, mode: LaunchMode.inAppWebView);
    } catch (_) {
      return false;
    } finally {
      emit(state.copyWith(isOpeningApp: false));
    }
  }
}
