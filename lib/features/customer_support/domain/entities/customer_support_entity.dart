import 'package:equatable/equatable.dart';

class CustomerSupportContactEntity extends Equatable {
  const CustomerSupportContactEntity({
    required this.cardTitle,
    required this.dialogTitle,
    required this.dialogMessage,
    required this.dialNumber,
  });

  final String cardTitle;
  final String dialogTitle;
  final String dialogMessage;
  final String dialNumber;

  @override
  List<Object?> get props => [
        cardTitle,
        dialogTitle,
        dialogMessage,
        dialNumber,
      ];
}

class CustomerSupportEntity extends Equatable {
  const CustomerSupportEntity({
    required this.helpCentreTitle,
    required this.helpCentreSubtitle,
    required this.contacts,
  });

  final String helpCentreTitle;
  final String helpCentreSubtitle;
  final List<CustomerSupportContactEntity> contacts;

  @override
  List<Object?> get props => [
        helpCentreTitle,
        helpCentreSubtitle,
        contacts,
      ];
}
