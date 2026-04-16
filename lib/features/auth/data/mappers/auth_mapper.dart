import '../../domain/entities/auth_entity.dart';
import '../models/auth_response_model.dart';

class AuthMapper {
  static AuthEntity toEntity(AuthResponseModel model) {
    return AuthEntity(
      success: model.success,
      message: model.message,
      isOnboardingCompleted: model.isOnboardingCompleted,
      token: model.token,
      userId: model.userId,
      firstName: model.firstName,
      lastName: model.lastName,
      gender: model.gender,
      email: model.email,
      address: model.address,
      dateOfBirth: model.dateOfBirth,
    );
  }
}
