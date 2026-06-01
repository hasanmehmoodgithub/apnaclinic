import 'package:equatable/equatable.dart';

class CustomerSupportContactEntity extends Equatable {
  const CustomerSupportContactEntity({
    required this.cardTitle,
    required this.dialogTitle,
    required this.dialogMessage,
    required this.dialNumber,
    this.email = '',
    this.buttonText = '',
  });

  final String cardTitle;
  final String dialogTitle;
  final String dialogMessage;
  final String dialNumber;
  final String email;
  final String buttonText;

  bool get hasEmail => email.trim().isNotEmpty;

  bool get hasPhone => dialNumber.trim().isNotEmpty;

  @override
  List<Object?> get props => [
    cardTitle,
    dialogTitle,
    dialogMessage,
    dialNumber,
    email,
    buttonText,
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
  List<Object?> get props => [helpCentreTitle, helpCentreSubtitle, contacts];
}
