import 'dart:developer';

import '../../../../core/functional/functional_export.dart';
import '../../domain/entities/instant_doctor_entity.dart';
import '../../domain/repositories/instant_doctor_repository.dart';
import '../../domain/use_cases/cancel_instant_doctor_subscription_params.dart';
import '../../domain/use_cases/get_instant_doctor_content_params.dart';
import '../../domain/use_cases/send_instant_doctor_otp_params.dart';
import '../../domain/use_cases/verify_instant_doctor_otp_params.dart';
import '../data_sources/instant_doctor_remote_data_source.dart';
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
      return Left(e.toString());
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
      );
      return const Right(null);
    } catch (e) {
      log('sendSubscriptionOtp repository error: $e');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, void>> verifySubscriptionOtp(
    VerifyInstantDoctorOtpParams params,
  ) async {
    try {
      await remoteDataSource.verifySubscriptionOtp(
        msisdn: params.msisdn,
        productId: params.productId,
        otp: params.otp,
        uuid: params.uuid,
      );
      return const Right(null);
    } catch (e) {
      log('verifySubscriptionOtp repository error: $e');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, void>> cancelSubscription(
    CancelInstantDoctorSubscriptionParams params,
  ) async {
    try {
      await remoteDataSource.cancelSubscription(
        msisdn: params.msisdn,
        productId: params.productId,
      );
      return const Right(null);
    } catch (e) {
      log('cancelSubscription repository error: $e');
      return Left(e.toString());
    }
  }
}
