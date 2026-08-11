import 'dart:developer';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/preference/user_local_model.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/utils/phone_format_utils.dart';
import '../mock/account_mock_api.dart';
import '../models/account_item_model.dart';
import '../models/user_phone_model.dart';
import 'account_remote_data_source.dart';

class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  AccountRemoteDataSourceImpl({
    required this.apiService,
    required this.mockApi,
    required this.appPref,
  });

  final ApiService apiService;
  final AccountMockApi mockApi;
  final AppPref appPref;

  static bool _isSuccessResponse(Map<String, dynamic> response) {
    if (response['success'] == true) return true;
    final code = response['code'];
    return code is num && code.toInt() == 200;
  }

  static bool _isNumericId(String value) => RegExp(r'^\d+$').hasMatch(value);

  @override
  Future<List<AccountItemModel>> getAccountsList() async {
    try {
      final Map<String, dynamic> response;
      if (AccountMockApi.useMockResponses) {
        response = await mockApi.getUserProfileResponse();
      } else {
        final userId = await _resolveApiUserId();
        if (userId.isEmpty) {
          return Future.error(AppStrings.profileSetupLoadError);
        }
        response = await apiService.get(AppUrls.userProfileById(userId));
        log('getAccountsList profile response: $response');
      }

      if (!_isSuccessResponse(response)) {
        return Future.error(
          (response['message'] ?? AppStrings.genericErrorMessage).toString(),
        );
      }

      final data = response['data'];
      if (data is! Map<String, dynamic>) return const [];

      await _cacheProfileUserMeta(data);
      final phones = parseUserPhones(data['phones']);
      return phones.map((phone) => phone.toAccountItem()).toList(growable: false);
    } catch (e) {
      log('getAccountsList error: $e');
      return Future.error(ErrorHandler.handleExceptions(e));
    }
  }

  @override
  Future<void> addUserPhone({required String phone}) async {
    final msisdn = PhoneFormatUtils.toMsisdn(phone);
    try {
      final Map<String, dynamic> response;
      if (AccountMockApi.useMockResponses) {
        response = await mockApi.addUserPhoneResponse(phone: msisdn);
      } else {
        final userId = await _resolveApiUserId();
        if (userId.isEmpty || !_isNumericId(userId)) {
          return Future.error(AppStrings.profileSetupLoadError);
        }
        final endpoint = AppUrls.userPhone(userId);
        log('addUserPhone POST $endpoint phone=$msisdn userId=$userId');
        response = await apiService.post(
          endpoint,
          data: <String, dynamic>{'phone': msisdn},
        );
        log('addUserPhone response: $response');
      }

      if (_isSuccessResponse(response)) return;

      return Future.error(
        (response['message'] ?? AppStrings.genericErrorMessage).toString(),
      );
    } catch (e) {
      log('addUserPhone error: $e');
      return Future.error(ErrorHandler.handleExceptions(e));
    }
  }

  @override
  Future<void> deleteUserPhone({required String phoneId}) async {
    final trimmedPhoneId = phoneId.trim();
    try {
      final Map<String, dynamic> response;
      if (AccountMockApi.useMockResponses) {
        response = await mockApi.deleteUserPhoneResponse(phoneId: trimmedPhoneId);
      } else {
        final userId = await _resolveApiUserId();
        if (userId.isEmpty || !_isNumericId(userId)) {
          return Future.error(AppStrings.profileSetupLoadError);
        }
        if (trimmedPhoneId.isEmpty || !_isNumericId(trimmedPhoneId)) {
          return Future.error(AppStrings.genericErrorMessage);
        }
        final endpoint = AppUrls.deleteUserPhone(userId, trimmedPhoneId);
        log('deleteUserPhone DELETE $endpoint userId=$userId phoneId=$trimmedPhoneId');
        response = await apiService.delete(endpoint);
        log('deleteUserPhone response: $response');
      }

      if (_isSuccessResponse(response)) return;

      return Future.error(
        (response['message'] ?? AppStrings.genericErrorMessage).toString(),
      );
    } catch (e) {
      log('deleteUserPhone error: $e');
      return Future.error(ErrorHandler.handleExceptions(e));
    }
  }

  /// Resolves numeric profile id (`data.id`) required by `/users/{id}/phone`.
  Future<String> _resolveApiUserId() async {
    final local = appPref.getUserLocalModel();
    final cached = local?.apiUserId.trim() ?? '';
    if (_isNumericId(cached)) return cached;

    final sessionUserId = appPref.getUserId().trim();
    if (sessionUserId.isEmpty) return '';

    if (_isNumericId(sessionUserId)) {
      await _cacheApiUserId(sessionUserId);
      return sessionUserId;
    }

    try {
      final response = await apiService.get(
        AppUrls.userProfileById(sessionUserId),
      );
      if (!_isSuccessResponse(response)) return sessionUserId;

      final data = response['data'];
      if (data is! Map<String, dynamic>) return sessionUserId;

      await _cacheProfileUserMeta(data);
      final apiUserId = (data['id'] ?? '').toString().trim();
      if (apiUserId.isNotEmpty) return apiUserId;
    } catch (e) {
      log('_resolveApiUserId profile fetch failed: $e');
    }

    return sessionUserId;
  }

  Future<void> _cacheApiUserId(String apiUserId) async {
    final existing = appPref.getUserLocalModel() ?? const UserLocalModel();
    if (existing.apiUserId == apiUserId) return;
    await appPref.setUserLocalModel(
      existing.copyWith(apiUserId: apiUserId),
    );
  }

  Future<void> _cacheProfileUserMeta(Map<String, dynamic> data) async {
    final apiUserId = (data['id'] ?? '').toString().trim();
    if (apiUserId.isEmpty) return;

    final phones = parseUserPhones(data['phones']);
    String? primaryMsisdn;
    for (final phone in phones) {
      if (phone.primary) {
        primaryMsisdn = phone.msisdn;
        break;
      }
    }
    primaryMsisdn ??= phones.isNotEmpty ? phones.first.msisdn : null;

    final firstName = (data['firstName'] ?? '').toString().trim();
    final lastName = (data['lastName'] ?? '').toString().trim();
    final email = (data['email'] ?? '').toString().trim();
    final gender = (data['gender'] ?? '').toString().trim();
    final address = (data['address'] ?? '').toString().trim();
    final dateOfBirth =
        (data['dateOfBirth'] ?? data['dob'] ?? '').toString().trim();
    final imageUrl =
        (data['image'] ?? data['imageUrl'] ?? '').toString().trim();

    final existing = appPref.getUserLocalModel() ?? const UserLocalModel();
    await appPref.setUserLocalModel(
      existing.copyWith(
        apiUserId: apiUserId,
        firstName: firstName.isNotEmpty ? firstName : existing.firstName,
        lastName: lastName.isNotEmpty ? lastName : existing.lastName,
        email: email.isNotEmpty ? email : existing.email,
        gender: gender.isNotEmpty ? gender : existing.gender,
        address: address.isNotEmpty ? address : existing.address,
        dateOfBirth:
            dateOfBirth.isNotEmpty ? dateOfBirth : existing.dateOfBirth,
        imageUrl: imageUrl.isNotEmpty ? imageUrl : existing.imageUrl,
        phone: primaryMsisdn != null && primaryMsisdn.isNotEmpty
            ? PhoneFormatUtils.toLocalDisplay(primaryMsisdn)
            : existing.phone,
      ),
    );
  }
}
