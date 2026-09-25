import 'dart:developer';

import '../../../../core/functional/functional_export.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/utils/error_handler.dart';
import '../../domain/entities/instant_doctor_booking_entity.dart';
import '../../domain/entities/instant_doctor_entity.dart';
import '../../domain/entities/instant_doctor_verify_otp_entity.dart';
import '../../domain/repositories/instant_doctor_repository.dart';
import '../../domain/use_cases/get_instant_doctor_bookings_params.dart';
import '../../domain/use_cases/get_instant_doctor_content_params.dart';
import '../../domain/use_cases/log_instant_doctor_session_params.dart';
import '../../domain/use_cases/send_instant_doctor_otp_params.dart';
import '../../domain/use_cases/verify_instant_doctor_otp_params.dart';
import '../data_sources/instant_doctor_remote_data_source.dart';
import '../mappers/instant_doctor_booking_mapper.dart';
import '../mappers/instant_doctor_mapper.dart';

class InstantDoctorRepositoryImpl implements InstantDoctorRepository {
  InstantDoctorRepositoryImpl({required this.remoteDataSource});

  final InstantDoctorRemoteDataSource remoteDataSource;

  @override
  Future<Either<ErrorMsg, InstantDoctorEntity>> getInstantDoctorContent(
    GetInstantDoctorContentParams params,
  ) async {
    try {
      final model = await remoteDataSource.getInstantDoctorContent(
        msisdn: params.msisdn,
      );
      return Right(InstantDoctorMapper.toEntity(model));
    } catch (e) {
      log('getInstantDoctorContent repository error: $e');
      return Left(
        ErrorHandler.handleExceptions(
          e,
          endpoint: AppUrls.instantDoctorConsultation(params.msisdn),
        ),
      );
    }
  }

  @override
  Future<Either<ErrorMsg, InstantDoctorBookingsPageEntity>> getBookings(
    GetInstantDoctorBookingsParams params,
  ) async {
    try {
      final model = await remoteDataSource.getBookings(params);
      return Right(InstantDoctorBookingMapper.toPageEntity(model));
    } catch (e) {
      log('getInstantDoctorBookings repository error: $e');
      return Left(
        ErrorHandler.handleExceptions(
          e,
          endpoint: AppUrls.instantDoctorBookings(
            page: params.page,
            limit: params.limit,
          ),
        ),
      );
    }
  }

  @override
  Future<Either<ErrorMsg, void>> sendSubscriptionOtp(
    SendInstantDoctorOtpParams params,
  ) async {
    try {
      await remoteDataSource.sendSubscriptionOtp(
        msisdn: params.msisdn,
        productId: params.productId,
        uuid: params.uuid,
        action: params.action.apiValue,
      );
      return const Right(null);
    } catch (e) {
      log('sendSubscriptionOtp repository error: $e');
      return Left(
        ErrorHandler.handleExceptions(
          e,
          endpoint: AppUrls.instantDoctorSendOtp,
        ),
      );
    }
  }

  @override
  Future<Either<ErrorMsg, InstantDoctorVerifyOtpEntity>> verifySubscriptionOtp(
    VerifyInstantDoctorOtpParams params,
  ) async {
    try {
      final model = await remoteDataSource.verifySubscriptionOtp(
        msisdn: params.msisdn,
        productId: params.productId,
        otp: params.otp,
        uuid: params.uuid,
        action: params.action.apiValue,
      );
      return Right(InstantDoctorMapper.toVerifyOtpEntity(model));
    } catch (e) {
      log('verifySubscriptionOtp repository error: $e');
      return Left(
        ErrorHandler.handleExceptions(
          e,
          endpoint: AppUrls.instantDoctorVerifyOtp,
        ),
      );
    }
  }

  @override
  Future<Either<ErrorMsg, void>> logSession(
    LogInstantDoctorSessionParams params,
  ) async {
    try {
      await remoteDataSource.logSession(
        startTime: params.startTime,
        endTime: params.endTime,
        instantDocLog: params.instantDocLog,
        providerName: params.providerName,
      );
      return const Right(null);
    } catch (e) {
      log('logInstantDoctorSession repository error: $e');
      return Left(
        ErrorHandler.handleExceptions(
          e,
          endpoint: AppUrls.instantDoctorSessionLog,
        ),
      );
    }
  }
}
