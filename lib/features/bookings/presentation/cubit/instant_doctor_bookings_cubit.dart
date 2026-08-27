import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../instant_doctor/domain/use_cases/get_instant_doctor_bookings_params.dart';
import '../../../instant_doctor/domain/use_cases/get_instant_doctor_bookings_use_case.dart';
import 'instant_doctor_bookings_state.dart';

class InstantDoctorBookingsCubit extends Cubit<InstantDoctorBookingsState> {
  InstantDoctorBookingsCubit({
    required this.getBookingsUseCase,
  }) : super(const InstantDoctorBookingsState());

  final GetInstantDoctorBookingsUseCase getBookingsUseCase;

  static const int _pageLimit = 20;

  Future<void> load({bool refresh = false}) async {
    emit(
      state.copyWith(
        isLoading: true,
        isLoadingMore: false,
        clearError: true,
        items: refresh ? state.items : const [],
        page: 1,
        hasMore: refresh ? state.hasMore : false,
      ),
    );
    await _fetchPage(page: 1, append: false);
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;
    emit(state.copyWith(isLoadingMore: true, clearError: true));
    await _fetchPage(page: state.page + 1, append: true);
  }

  Future<void> _fetchPage({
    required int page,
    required bool append,
  }) async {
    final result = await getBookingsUseCase.call(
      GetInstantDoctorBookingsParams(page: page, limit: _pageLimit),
    );
    if (isClosed) return;

    result.fold(
      (error) => emit(
        state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          errorMessage: error,
        ),
      ),
      (pageData) {
        final items = append
            ? [...state.items, ...pageData.items]
            : pageData.items;
        emit(
          state.copyWith(
            isLoading: false,
            isLoadingMore: false,
            items: items,
            page: pageData.page,
            hasMore: pageData.hasMore,
            clearError: true,
          ),
        );
      },
    );
  }
}
