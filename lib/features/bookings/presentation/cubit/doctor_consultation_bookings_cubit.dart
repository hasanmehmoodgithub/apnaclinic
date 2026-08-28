import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../consultation/domain/use_cases/get_consultation_bookings_use_case.dart';
import '../../data/mappers/doctor_consultation_booking_mapper.dart';
import 'doctor_consultation_bookings_state.dart';

class DoctorConsultationBookingsCubit
    extends Cubit<DoctorConsultationBookingsState> {
  DoctorConsultationBookingsCubit({
    required this.getBookingsUseCase,
  }) : super(const DoctorConsultationBookingsState());

  final GetConsultationBookingsUseCase getBookingsUseCase;

  static const int _pageLimit = 20;

  Future<void> load({bool refresh = false}) async {
    if (state.isLoading) return;
    if (!refresh && state.hasLoaded && !state.hasError) return;
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
      GetConsultationBookingsParams(page: page, limit: _pageLimit),
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
        final mappedItems = pageData.items
            .map(DoctorConsultationBookingMapper.fromEntity)
            .toList(growable: false);
        final items = append ? [...state.items, ...mappedItems] : mappedItems;

        emit(
          state.copyWith(
            isLoading: false,
            isLoadingMore: false,
            hasLoaded: true,
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
