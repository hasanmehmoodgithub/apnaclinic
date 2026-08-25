import '../../../../core/utils/auth_api_utils.dart';

class AuthResponseModel {
  const AuthResponseModel({
    required this.success,
    required this.message,
    required this.isOnboardingCompleted,
    this.msisdn,
    this.expiresInSeconds,
    this.generationAttemptCount,
    this.token,
    this.refreshToken,
    this.accessTokenExpiresIn,
    this.refreshTokenExpiresIn,
    this.userId,
    this.firstName,
    this.lastName,
    this.gender,
    this.email,
    this.address,
    this.dateOfBirth,
  });

  final bool success;
  final String message;
  final bool isOnboardingCompleted;
  final String? msisdn;
  final int? expiresInSeconds;
  final int? generationAttemptCount;
  final String? token;
  final String? refreshToken;
  final int? accessTokenExpiresIn;
  final int? refreshTokenExpiresIn;
  final String? userId;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? email;
  final String? address;
  final String? dateOfBirth;

  static int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.toLowerCase().trim();
      return normalized == 'true' || normalized == '1';
    }
    return false;
  }

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final dataMap = data is Map
        ? Map<String, dynamic>.from(data)
        : <String, dynamic>{};
    final accessToken = dataMap['accessToken'];
    final refreshToken = dataMap['refreshToken'];
    final accessTokenMap = accessToken is Map<String, dynamic>
        ? accessToken
        : <String, dynamic>{};
    final refreshTokenMap = refreshToken is Map<String, dynamic>
        ? refreshToken
        : <String, dynamic>{};
    final user = dataMap['user'];
    final userMap = user is Map
        ? Map<String, dynamic>.from(user)
        : <String, dynamic>{};
    return AuthResponseModel(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
      // Backend now sends userOnboarding=true when profile setup is still pending.
      isOnboardingCompleted:
          dataMap.containsKey('userOnboarding') ||
              json.containsKey('userOnboarding')
          ? !_toBool(dataMap['userOnboarding'] ?? json['userOnboarding'])
          : _toBool(
              dataMap['isOnboardingCompleted'] ?? json['isOnboardingCompleted'],
            ),
      msisdn: (dataMap['msisdn'] ?? json['msisdn'])?.toString(),
      expiresInSeconds: _toInt(
        dataMap['expiresIn'] ??
            dataMap['expriesIn'] ??
            json['expiresIn'] ??
            json['expriesIn'],
      ),
      generationAttemptCount: _toInt(
        dataMap['generationAttemptCount'] ?? json['generationAttemptCount'],
      ),
      token: (dataMap['token'] ?? accessTokenMap['token'] ?? json['token'])
          ?.toString(),
      refreshToken:
          (dataMap['refreshTokenValue'] ??
                  refreshTokenMap['token'] ??
                  json['refreshToken'])
              ?.toString(),
      accessTokenExpiresIn: _toInt(
        dataMap['accessTokenExpiresIn'] ??
            accessTokenMap['expiresIn'] ??
            json['accessTokenExpiresIn'],
      ),
      refreshTokenExpiresIn: _toInt(
        dataMap['refreshTokenExpiresIn'] ??
            refreshTokenMap['expiresIn'] ??
            json['refreshTokenExpiresIn'],
      ),
      userId:
          (dataMap['userId'] ?? json['userId'])?.toString() ??
          AuthApiUtils.extractUserIdFromAuthResponse(json),
      firstName: _userField(userMap['firstName'] ?? dataMap['firstName']),
      lastName: _userField(userMap['lastName'] ?? dataMap['lastName']),
      gender: _userField(userMap['gender'] ?? dataMap['gender']),
      email: _userField(userMap['email'] ?? dataMap['email']),
      address: _userField(userMap['address'] ?? dataMap['address']),
      dateOfBirth: _userField(
        userMap['dateOfBirth'] ??
            userMap['dob'] ??
            dataMap['dateOfBirth'] ??
            dataMap['dob'],
      ),
    );
  }

  /// Treats JSON null, blank, `"null"`, and `"[NULL]"` as absent.
  static String? _userField(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    if (text.isEmpty) return null;
    final lower = text.toLowerCase();
    if (lower == 'null' || lower == '[null]') return null;
    return text;
  }
}
