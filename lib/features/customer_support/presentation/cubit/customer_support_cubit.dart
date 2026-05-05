import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/enums/state_status.dart';
import '../../domain/use_cases/get_customer_support_content_use_case.dart';
import 'customer_support_state.dart';

class CustomerSupportCubit extends Cubit<CustomerSupportState> {
  CustomerSupportCubit({required this.getContentUseCase})
    : super(const CustomerSupportState()) {
    loadContent();
  }

  final GetCustomerSupportContentUseCase getContentUseCase;

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
          loadingStateStatus: content.contacts.isEmpty
              ? StateStatus.empty
              : StateStatus.success,
          content: content,
          errorMessage: null,
        ),
      ),
    );
  }

  Future<bool> dialNumber(String rawNumber) async {
    final digits = rawNumber.replaceAll(RegExp(r'[^\d+]'), '');
    if (digits.isEmpty) return false;
    final uri = Uri.parse('tel:$digits');
    try {
      if (await canLaunchUrl(uri)) {
        // Prefer platform default so OS can route to the dialer app naturally.
        final launched = await launchUrl(uri);
        if (launched) return true;
      }
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }
}
