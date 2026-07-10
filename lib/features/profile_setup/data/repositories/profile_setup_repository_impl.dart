import 'dart:developer';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/functional/functional_export.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/preference/user_local_model.dart';
import '../../../../core/session/profile_session_sync.dart';
import '../../../../core/utils/phone_format_utils.dart';
import '../../domain/entities/profile_setup_entity.dart';
import '../../domain/models/profile_setup_data.dart';
import '../../domain/repositories/profile_setup_repository.dart';
import '../data_sources/profile_setup_remote_data_source.dart';
import '../mappers/profile_phones_mapper.dart';
import '../mappers/profile_setup_mapper.dart';

class ProfileSetupRepositoryImpl implements ProfileSetupRepository {
  ProfileSetupRepositoryImpl({
    required ProfileSetupRemoteDataSource remoteDataSource,
    ProfileSessionSync? profileSessionSync,
  })  : _remoteDataSource = remoteDataSource,
        _profileSessionSync = profileSessionSync ?? sl<ProfileSessionSync>();

  final appPref = sl<AppPref>();
  final ProfileSetupRemoteDataSource _remoteDataSource;
  final ProfileSessionSync _profileSessionSync;

  @override
  Future<Either<ErrorMsg, ProfileSetupEntity>> getProfileSetupContent() async {
    try {
      final model = await _remoteDataSource.getProfileSetupContent();
      final entity = ProfileSetupMapper.toEntity(model);
      await _persistEntityLocally(
        entity,
        apiUserId: model.content.apiUserId,
        primaryMsisdn: model.content.primaryMsisdn,
      );
      _profileSessionSync.markSynced(
        mapProfilePhonesToAccountItems(model.content.phones),
      );
      return Right(entity);
    } catch (e) {
      log('getProfileSetupContent repository error: $e');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<ErrorMsg, void>> saveProfile(ProfileSetupData data) async {
    try {
      await _remoteDataSource.saveProfile(data);
      await _persistDataLocally(data);
      _profileSessionSync.invalidate();
      return const Right(null);
    } catch (e) {
      log('saveProfile repository error: $e');
      return Left(e.toString());
    }
  }

  Future<void> _persistEntityLocally(
    ProfileSetupEntity entity, {
    String apiUserId = '',
    String? primaryMsisdn,
  }) async {
    final existing = appPref.getUserLocalModel() ?? const UserLocalModel();
    final resolvedPhone = primaryMsisdn?.trim();
    await appPref.setUserLocalModel(
      existing.copyWith(
        firstName: entity.firstName,
        lastName: entity.lastName,
        gender: entity.gender,
        email: entity.email,
        address: entity.address,
        dateOfBirth: entity.dateOfBirth?.toIso8601String() ?? '',
        imageUrl: entity.imageUrl ?? '',
        apiUserId: apiUserId.isNotEmpty ? apiUserId : existing.apiUserId,
        phone: resolvedPhone != null && resolvedPhone.isNotEmpty
            ? PhoneFormatUtils.toLocalDisplay(resolvedPhone)
            : existing.phone,
      ),
    );
  }

  Future<void> _persistDataLocally(ProfileSetupData data) async {
    final existing = appPref.getUserLocalModel() ?? const UserLocalModel();
    await appPref.setUserLocalModel(
      existing.copyWith(
        firstName: data.firstName,
        lastName: data.lastName,
        gender: data.gender,
        email: data.email,
        address: data.address,
        dateOfBirth: data.dateOfBirth.toIso8601String(),
      ),
    );
    await appPref.setProfileCompleted(true);
  }
}
