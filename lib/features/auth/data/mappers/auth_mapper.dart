import '../../domain/entities/auth_entity.dart';
import '../models/auth_response_model.dart';

class AuthMapper {
  static AuthEntity toEntity(AuthResponseModel model) {
    return AuthEntity(
      success: model.success,
      message: model.message,
      token: model.token,
      userId: model.userId,
    );
  }
}
