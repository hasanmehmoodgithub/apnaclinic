import 'dart:developer';

import '../../../../core/functional/functional_export.dart';
import '../../domain/entities/promo_code_validation_entity.dart';
import '../../domain/repositories/promo_code_repository.dart';
import '../../domain/use_cases/validate_promo_code_use_case.dart';
import '../data_sources/promo_code_remote_data_source.dart';
import '../mappers/promo_code_mapper.dart';

class PromoCodeRepositoryImpl implements PromoCodeRepository {
  PromoCodeRepositoryImpl({required this.remoteDataSource});

  final PromoCodeRemoteDataSource remoteDataSource;

  @override
  Future<Either<ErrorMsg, PromoCodeValidationEntity>> validate(
    ValidatePromoCodeParams params,
  ) async {
    try {
      final model = await remoteDataSource.validate(params);
      return Right(PromoCodeMapper.toEntity(model));
    } catch (e) {
      log('validatePromoCode repository error: $e');
      if (e is String && e.trim().isNotEmpty) {
        return Left(e.trim());
      }
      return Left(e.toString());
    }
  }
}
