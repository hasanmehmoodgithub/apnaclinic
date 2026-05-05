import '../../domain/entities/customer_support_entity.dart';
import '../models/customer_support_model.dart';

class CustomerSupportMapper {
  static CustomerSupportEntity toEntity(CustomerSupportResponseModel model) {
    final p = model.payload;
    var contacts = p.contacts
        .map(
          (c) => CustomerSupportContactEntity(
            cardTitle: c.cardTitle,
            dialogTitle: c.dialogTitle.isNotEmpty
                ? c.dialogTitle
                : 'Customer Support',
            dialogMessage: c.dialogMessage,
            dialNumber: c.dialNumber,
          ),
        )
        .toList();

    if (contacts.isEmpty) {
      contacts = const [
        CustomerSupportContactEntity(
          cardTitle: 'Apna Clinic Support',
          dialogTitle: 'Customer Support',
          dialogMessage:
              'Or further support please contact us 24/7 on\n042-111-333-033.',
          dialNumber: '042111333033',
        ),
      ];
    }

    return CustomerSupportEntity(
      helpCentreTitle: p.helpCentreTitle.isNotEmpty
          ? p.helpCentreTitle
          : 'Help Centre',
      helpCentreSubtitle: p.helpCentreSubtitle.isNotEmpty
          ? p.helpCentreSubtitle
          : 'Reach out to Apna Clinic for any support.',
      contacts: contacts,
    );
  }
}
