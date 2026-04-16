import '../../../../core/failure/exceptions.dart';
import '../../../../core/functional/functional_export.dart';
import '../mappers/auth_mapper.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/use_cases/request_otp_use_case.dart';
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
}
