import '../../../../core/preference/support_settings_local_model.dart';
import '../../domain/entities/customer_support_entity.dart';
import '../models/support_settings_model.dart';

class CustomerSupportMapper {
  static CustomerSupportEntity toEntity(SupportSettingsResponseModel model) {
    return fromSettings(model.data);
  }

  static CustomerSupportEntity fromSettings(SupportSettingsLocalModel settings) {
    final contacts = settings.hasContactData
        ? [
            CustomerSupportContactEntity(
              cardTitle: '',
              dialogTitle: '',
              dialogMessage: settings.description,
              dialNumber: settings.phone,
              email: settings.email,
              buttonText: settings.buttonText,
            ),
          ]
        : const <CustomerSupportContactEntity>[];

    return CustomerSupportEntity(
      helpCentreTitle: '',
      helpCentreSubtitle: '',
      contacts: contacts,
    );
  }
}
