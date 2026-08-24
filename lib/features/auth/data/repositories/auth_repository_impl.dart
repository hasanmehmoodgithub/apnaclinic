import '../../../../core/functional/functional_export.dart';
import '../mappers/auth_mapper.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/use_cases/logout_use_case.dart';
import '../../domain/use_cases/request_otp_use_case.dart';
import '../../domain/use_cases/update_fcm_device_token_use_case.dart';
import '../../domain/use_cases/verify_otp_use_case.dart';
import '../data_sources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<Either<ErrorMsg, AuthEntity>> requestOtp(RequestOtpParams params) async {
    try {
      final model = await _remoteDataSource.requestOtp(params);
      return Right(AuthMapper.toEntity(model));
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, AuthEntity>> verifyOtp(VerifyOtpParams params) async {
    try {
      final model = await _remoteDataSource.verifyOtp(params);
      return Right(AuthMapper.toEntity(model));
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, void>> logout(LogoutParams params) async {
    final trimmed = params.userId.trim();
    if (trimmed.isEmpty) {
      return const Right(null);
    }
    try {
      await _remoteDataSource.logout(params);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, void>> updateFcmDeviceToken(
    UpdateFcmDeviceTokenParams params,
  ) async {
    final token = params.fcmToken.trim();
    if (token.isEmpty) {
      return const Right(null);
    }
    try {
      await _remoteDataSource.updateFcmDeviceToken(params);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
