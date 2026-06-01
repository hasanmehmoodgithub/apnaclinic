import '../../../dashboard/domain/entities/support_settings_entity.dart';
import '../../domain/entities/customer_support_entity.dart';

class CustomerSupportMapper {
  static CustomerSupportEntity fromSupportSettings(
    SupportSettingsEntity settings,
  ) {
    final hasContactData =
        settings.hasPhone || settings.hasEmail || settings.description.isNotEmpty;

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
