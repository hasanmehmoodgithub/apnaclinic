import '../../../../core/functional/functional_export.dart';
import '../../domain/entities/consultation_booking_list_entity.dart';
import '../../domain/entities/consultation_category_entity.dart';
import '../../domain/entities/consultation_doctor_slots_entity.dart';
import '../../domain/repositories/consultation_repository.dart';
import '../../domain/entities/payment_provider_entity.dart';
import '../../domain/use_cases/submit_consultation_booking_use_case.dart';
import '../../domain/use_cases/submit_consultation_feedback_use_case.dart';
import '../../domain/entities/consultation_doctors_page_entity.dart';
import '../data_sources/consultation_remote_data_source.dart';
import '../utils/consultation_slots_error_utils.dart';

class ConsultationRepositoryImpl implements ConsultationRepository {
  ConsultationRepositoryImpl({required this.remoteDataSource});

  final ConsultationRemoteDataSource remoteDataSource;

  @override
  Future<Either<ErrorMsg, List<ConsultationCategoryEntity>>>
  getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Right(categories);
    } catch (e) {
      if (e is String && e.trim().isNotEmpty) {
        return Left(e.trim());
      }
      return const Left('Unable to load consultation categories.');
    }
  }

  @override
  Future<Either<ErrorMsg, ConsultationDoctorsPageEntity>> getDoctors({
    required String mainCategoryId,
    String? partnerId,
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final pageModel = await remoteDataSource.getDoctors(
        mainCategoryId: mainCategoryId,
        partnerId: partnerId,
        search: search,
        page: page,
        limit: limit,
      );
      return Right(pageModel.toPageEntity());
    } catch (e) {
      if (e is String && e.trim().isNotEmpty) {
        return Left(e.trim());
      }
      return const Left('Unable to load doctors right now.');
    }
  }

  @override
  Future<Either<ErrorMsg, ConsultationDoctorSlotsEntity>> getDoctorSlots({
    required String doctorId,
    String? hospitalId,
  }) async {
    try {
      if (doctorId.trim().isEmpty) {
        return const Left('Doctor not found. Please try again.');
      }

      final model = await remoteDataSource.getDoctorSlots(
        doctorId: doctorId,
        hospitalId: hospitalId,
      );
      return Right(model.toEntity());
    } catch (e) {
      final raw = e is String && e.trim().isNotEmpty
          ? e.trim()
          : 'Unable to load availability right now.';
      return Left(ConsultationSlotsErrorUtils.toUserMessage(raw));
    }
  }

  @override
  Future<Either<ErrorMsg, List<PaymentProviderEntity>>> getPaymentProviders({
    required String module,
  }) async {
    try {
      final providers = await remoteDataSource.getPaymentProviders(
        module: module,
      );
      return Right(
        providers
            .map(
              (provider) => PaymentProviderEntity(
                name: provider.name,
                code: provider.code,
                iconUrl: provider.iconUrl,
              ),
            )
            .toList(growable: false),
      );
    } catch (e) {
      if (e is String && e.trim().isNotEmpty) {
        return Left(e.trim());
      }
      return const Left('Unable to load payment methods right now.');
    }
  }

  @override
  Future<Either<ErrorMsg, ConsultationBookingsPageEntity>> getBookings({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final pageModel = await remoteDataSource.getBookings(
        page: page,
        limit: limit,
      );
      return Right(pageModel.toEntity());
    } catch (e) {
      if (e is String && e.trim().isNotEmpty) {
        return Left(e.trim());
      }
      return const Left('Unable to load consultation bookings right now.');
    }
  }

  @override
  Future<Either<ErrorMsg, ConsultationBookingListItemEntity>> getBooking({
    required int appointmentId,
  }) async {
    try {
      final model = await remoteDataSource.getBooking(
        appointmentId: appointmentId,
      );
      return Right(model.toEntity());
    } catch (e) {
      if (e is String && e.trim().isNotEmpty) {
        return Left(e.trim());
      }
      return const Left('Unable to load consultation booking right now.');
    }
  }

  @override
  Future<Either<ErrorMsg, void>> submitBooking(
    SubmitConsultationBookingParams params,
  ) async {
    try {
      await remoteDataSource.submitBooking(params);
      return const Right(null);
    } catch (e) {
      if (e is String && e.trim().isNotEmpty) {
        return Left(e.trim());
      }
      return const Left('Unable to book consultation right now.');
    }
  }

  @override
  Future<Either<ErrorMsg, void>> submitFeedback(
    SubmitConsultationFeedbackParams params,
  ) async {
    try {
      await remoteDataSource.submitFeedback(params);
      return const Right(null);
    } catch (e) {
      if (e is String && e.trim().isNotEmpty) {
        return Left(e.trim());
      }
      return const Left('Unable to submit feedback right now.');
    }
  }
}
