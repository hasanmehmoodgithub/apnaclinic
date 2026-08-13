import 'package:flutter/material.dart';

import '../../../bookings/presentation/widgets/alert_dialog_card.dart';

Future<void> showPharmacyErrorDialog(
  BuildContext context, {
  required String title,
  required String message,
}) {
  final text = message.trim();
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    useRootNavigator: true,
    builder: (_) => AlertDialogCard(
      kind: AlertKind.error,
      title: title,
      message: text.isNotEmpty ? text : title,
    ),
  );
}
