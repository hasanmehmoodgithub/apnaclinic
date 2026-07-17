import 'dart:developer';

import '../../../../core/cities/domain/repositories/cities_repository.dart';
import '../../../../core/functional/functional_export.dart';
import '../../domain/entities/surgery_booking_request_entity.dart';
import '../../domain/entities/surgery_doctor_entity.dart';
import '../../domain/entities/surgery_lead_entity.dart';
import '../../domain/entities/surgery_patient_form_entity.dart';
import '../../domain/entities/surgery_procedure_entity.dart';
import '../../domain/entities/surgery_provider_details_entity.dart';
import '../../domain/repositories/surgery_repository.dart';
import '../../domain/use_cases/book_surgery_use_case.dart';
import '../data_sources/surgery_remote_data_source.dart';
import '../mappers/surgery_doctors_mapper.dart';
import '../mappers/surgery_leads_mapper.dart';
import '../mappers/surgery_mapper.dart';
import '../mappers/surgery_patient_form_mapper.dart';
import '../mappers/surgery_provider_details_mapper.dart';

class SurgeryRepositoryImpl implements SurgeryRepository {
  SurgeryRepositoryImpl({
    required this.remoteDataSource,
    required this.citiesRepository,
  });

  final SurgeryRemoteDataSource remoteDataSource;
  final CitiesRepository citiesRepository;

  @override
  Future<Either<ErrorMsg, SurgeryContentEntity>> getSurgeryContent({
    String? city,
  }) async {
    try {
      String? cityId;
      if (city != null && city.trim().isNotEmpty) {
        await citiesRepository.loadCities();
        cityId = citiesRepository.cityIdForName(city.trim());
        if (cityId == null || cityId.isEmpty) {
          return const Left('Please select a valid city.');
        }
      }

      final model = await remoteDataSource.getSurgeryContent(cityId: cityId);
      final entity = SurgeryMapper.toEntity(model);
      await citiesRepository.loadCities();
      final cityNames = citiesRepository.cityNames;
      final defaultCity = citiesRepository.defaultCityName;
      log('Mapped surgery procedures count: ${entity.procedures.length}');
      return Right(
        SurgeryContentEntity(
          cities: cityNames.isNotEmpty ? cityNames : entity.cities,
          defaultCity: defaultCity.isNotEmpty ? defaultCity : entity.defaultCity,
          procedures: entity.procedures,
        ),
      );
    } catch (e) {
      log('getSurgeryContent repository error: $e');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, SurgeryDoctorsEntity>> getSurgeryDoctors({
    required String surgeryId,
    required String procedureName,
    required String city,
  }) async {
    try {
      await citiesRepository.loadCities();
      final cityId = citiesRepository.cityIdForName(city);
      if (cityId == null || cityId.isEmpty) {
        return Left('Please select a valid city.');
      }

      final model = await remoteDataSource.getSurgeryDoctors(
        surgeryId: surgeryId,
        procedureName: procedureName,
        city: city,
        cityId: cityId,
      );
      return Right(SurgeryDoctorsMapper.toEntity(model));
    } catch (e) {
      log('getSurgeryDoctors repository error: $e');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, SurgeryProviderDetailsEntity>> getSurgeryProviderDetails({
    required String surgeryId,
    required String cityId,
    required String doctorId,
  }) async {
    try {
      if (surgeryId.trim().isEmpty ||
          cityId.trim().isEmpty ||
          doctorId.trim().isEmpty) {
        return const Left('Missing surgery booking details. Please try again.');
      }

      final model = await remoteDataSource.getSurgeryProviderDetails(
        surgeryId: surgeryId,
        cityId: cityId,
        doctorId: doctorId,
      );
      return Right(SurgeryProviderDetailsMapper.toEntity(model));
    } catch (e) {
      log('getSurgeryProviderDetails repository error: $e');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, SurgeryPatientFormEntity>> getSurgeryPatientForm({
    required String doctorId,
  }) async {
    try {
      final model = await remoteDataSource.getSurgeryPatientForm(
        doctorId: doctorId,
      );
      return Right(SurgeryPatientFormMapper.toEntity(model));
    } catch (e) {
      log('getSurgeryPatientForm repository error: $e');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, SurgeryLeadsPageEntity>> getSurgeryLeads({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final model = await remoteDataSource.getSurgeryLeads(
        page: page,
        limit: limit,
      );
      return Right(SurgeryLeadsMapper.toPageEntity(model));
    } catch (e) {
      log('getSurgeryLeads repository error: $e');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, SurgeryLeadEntity>> getSurgeryLead({
    required int leadId,
  }) async {
    try {
      final model = await remoteDataSource.getSurgeryLead(leadId: leadId);
      return Right(SurgeryLeadsMapper.toEntity(model));
    } catch (e) {
      log('getSurgeryLead repository error: $e');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, void>> submitSurgeryBooking(
    SurgeryBookingRequestEntity request,
  ) async {
    try {
      await remoteDataSource.submitSurgeryBooking(request);
      return const Right(null);
    } catch (e) {
      log('submitSurgeryBooking repository error: $e');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, void>> bookSurgery(BookSurgeryParams params) async {
    try {
      await remoteDataSource.bookSurgery(
        leadId: params.leadId,
        paymentMethod: params.paymentMethod,
        msisdn: params.msisdn,
      );
      return const Right(null);
    } catch (e) {
      log('bookSurgery repository error: $e');
      return Left(e.toString());
    }
  }
}
