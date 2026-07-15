import '../models/surgery_booking_list_item_model.dart';

/// Legacy local mock. Bookings list now uses `GetSurgeryLeadsUseCase`.
class SurgeryBookingsMockApi {
  Future<List<SurgeryBookingListItemModel>> getBookings() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return const [];
  }
}
