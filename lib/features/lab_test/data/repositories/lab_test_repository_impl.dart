import '../../../../core/cities/domain/repositories/cities_repository.dart';
import '../../../../core/functional/functional_export.dart';
import '../../domain/entities/lab_order_entity.dart';
import '../../domain/entities/lab_test_catalog_entity.dart';
import '../../domain/entities/lab_test_detail_entity.dart';
import '../../domain/repositories/lab_test_repository.dart';
import '../../domain/use_cases/book_lab_test_use_case.dart';
import '../../domain/use_cases/get_lab_test_catalog_use_case.dart';
import '../../domain/use_cases/get_lab_test_detail_use_case.dart';
import '../constants/lab_test_catalog_defaults.dart';
import '../data_sources/lab_test_remote_data_source.dart';
import '../mappers/lab_orders_mapper.dart';
import '../mappers/lab_test_detail_mapper.dart';
import '../mappers/lab_test_mobile_tests_mapper.dart';

class LabTestRepositoryImpl implements LabTestRepository {
  LabTestRepositoryImpl({
    required this.remoteDataSource,
    required this.citiesRepository,
  });

  final LabTestRemoteDataSource remoteDataSource;
  final CitiesRepository citiesRepository;

  @override
  Future<Either<ErrorMsg, LabTestCatalogEntity>> getLabTestCatalog(
    GetLabTestCatalogParams params,
  ) async {
    try {
      await citiesRepository.loadCities();
      final cityNames = citiesRepository.cityNames;

      if (params.citiesOnly || params.cityName == null) {
        return Right(
          LabTestCatalogEntity(
            cities: cityNames,
            items: const [],
            requirementLines: LabTestCatalogDefaults.requirementLines,
            partners: LabTestCatalogDefaults.partners,
            vendors: const [],
          ),
        );
      }

      final cityId = citiesRepository.cityIdForName(params.cityName!);
      if (cityId == null || cityId.isEmpty) {
        return const Left('Please select a valid city.');
      }

      final model = await remoteDataSource.getLabTests(
        cityId: cityId,
        page: params.page,
        limit: params.limit,
        search: params.search,
        labId: params.labId,
      );
      final mapped = LabTestMobileTestsMapper.toEntity(model);

      return Right(
        LabTestCatalogEntity(
          cities: cityNames.isNotEmpty ? cityNames : mapped.cities,
          items: mapped.items,
          requirementLines: mapped.requirementLines,
          partners: mapped.partners,
          vendors: mapped.vendors,
          pricing: mapped.pricing,
        ),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, LabTestDetailEntity>> getLabTestDetail(
    GetLabTestDetailParams params,
  ) async {
    try {
      await citiesRepository.loadCities();
      final cityId = citiesRepository.cityIdForName(params.cityName);
      if (cityId == null || cityId.isEmpty) {
        return const Left('Please select a valid city.');
      }

      final model = await remoteDataSource.getLabTestDetail(
        testId: params.testId,
        cityId: cityId,
      );
      return Right(LabTestDetailMapper.toEntity(model));
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, LabOrdersPageEntity>> getLabOrders({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final model = await remoteDataSource.getLabOrders(page: page, limit: limit);
      return Right(LabOrdersMapper.toPageEntity(model));
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, LabOrderEntity>> getLabOrderDetail({
    required String orderId,
  }) async {
    try {
      final trimmed = orderId.trim();
      if (trimmed.isEmpty) {
        return const Left('Missing lab order id.');
      }
      final model = await remoteDataSource.getLabOrderDetail(orderId: trimmed);
      return Right(LabOrdersMapper.toEntity(model));
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, void>> bookLabTest(BookLabTestParams params) async {
    try {
      if (params.testIds.isEmpty) {
        return const Left('No lab tests selected to book.');
      }

      await citiesRepository.loadCities();
      final cityId = citiesRepository.cityIdForName(params.cityName);
      if (cityId == null || cityId.isEmpty) {
        return const Left('Please select a valid city.');
      }

      final partnerId = int.tryParse(params.partnerId.trim());
      final labId = int.tryParse(params.labId.trim());
      final resolvedCityId = int.tryParse(cityId.trim());
      if (partnerId == null || labId == null || resolvedCityId == null) {
        return const Left('Missing lab booking details. Please retry.');
      }

      final body = <String, dynamic>{
        'partnerId': partnerId,
        'labId': labId,
        'cityId': resolvedCityId,
        'homeSample': params.homeSample,
        'paymentMethod': params.paymentMethod,
        'msisdn': params.msisdn,
        'patient': {
          'name': params.patient.name,
          'age': params.patient.age,
          'gender': params.patient.gender,
          'phoneNumber': params.patient.phoneNumber,
        },
        'tests': params.testIds
            .map((id) => {'testId': id})
            .toList(growable: false),
      };

      await remoteDataSource.bookLabTest(body);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
