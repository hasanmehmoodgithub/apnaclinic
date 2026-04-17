import '../../../../core/functional/functional_export.dart';
import '../../domain/entities/surgery_procedure_entity.dart';
import '../../domain/repositories/surgery_repository.dart';
import '../data_sources/surgery_remote_data_source.dart';
import '../mappers/surgery_mapper.dart';

class SurgeryRepositoryImpl implements SurgeryRepository {
  SurgeryRepositoryImpl({required this.remoteDataSource});

  final SurgeryRemoteDataSource remoteDataSource;

  @override
  Future<Either<ErrorMsg, SurgeryContentEntity>> getSurgeryContent() async {
    try {
      final model = await remoteDataSource.getSurgeryContent();
      return Right(SurgeryMapper.toEntity(model));
    } catch (e) {
      return Left(e.toString());
    }
  }
}
