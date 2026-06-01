import '../../domain/entities/customer_support_entity.dart';
import '../models/support_settings_model.dart';

class CustomerSupportMapper {
  static CustomerSupportEntity toEntity(SupportSettingsResponseModel model) {
    final settings = model.data;
    final hasContactData = settings.phone.isNotEmpty ||
        settings.email.isNotEmpty ||
        settings.description.isNotEmpty;

    final contacts = hasContactData
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
