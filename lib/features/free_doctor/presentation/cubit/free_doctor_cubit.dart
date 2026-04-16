import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/enums/state_status.dart';
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

  Future<bool> openFikrfreeApp() async {
    final content = state.content;
    if (content == null) return false;

    emit(state.copyWith(isOpeningApp: true));
    try {
      if (Platform.isAndroid) {
        final packageName = content.fikrfreeAndroidPackage.trim();
        if (packageName.isNotEmpty) {
          final directAppUri = Uri.parse('android-app://$packageName');
          if (await launchUrl(
            directAppUri,
            mode: LaunchMode.externalNonBrowserApplication,
          )) {
            return true;
          }
        }

        final appUri = Uri.parse(
          'market://details?id=${content.fikrfreeAndroidPackage}',
        );
        if (await launchUrl(
          appUri,
          mode: LaunchMode.externalNonBrowserApplication,
        )) {
          return true;
        }
      }

      if (Platform.isIOS) {
        final iosUri = Uri.parse(content.fikrfreeIosAppStoreUrl);
        if (await launchUrl(iosUri, mode: LaunchMode.externalApplication)) {
          return true;
        }
      }

      final webUri = Uri.parse(content.fikrfreeWebUrl);
      return await launchUrl(webUri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    } finally {
      emit(state.copyWith(isOpeningApp: false));
    }
  }
}
