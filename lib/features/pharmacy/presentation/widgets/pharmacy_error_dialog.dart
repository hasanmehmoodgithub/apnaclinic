import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/heart_loader_widget.dart';
import '../../../bookings/presentation/widgets/alert_dialog_card.dart';
import '../cubit/pharmacy_cubit.dart';

const _kAbandonLoaderId = 'pharmacy_abandon_order_loader';

Future<void> showPharmacyErrorDialog(
  BuildContext context, {
  required String title,
  required String message,
  bool offerAbandonPayment = false,
}) {
  final text = message.trim();
  final l10n = AppLocalizations.of(context)!;
  final showAbandon = offerAbandonPayment &&
      PharmacyCubit.isPaymentInProgressCartError(text);

  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    useRootNavigator: true,
    builder: (dialogContext) => AlertDialogCard(
      kind: AlertKind.error,
      title: title,
      message: text.isNotEmpty ? text : title,
      closeLabel: l10n.instantDoctorClose,
      secondaryLabel:
          showAbandon ? l10n.pharmacyAbandonUnpaidOrderCta : null,
      onSecondary: showAbandon
          ? () => _onAbandonUnpaidOrder(
                pageContext: context,
                dialogContext: dialogContext,
              )
          : null,
    ),
  );
}

Future<void> _onAbandonUnpaidOrder({
  required BuildContext pageContext,
  required BuildContext dialogContext,
}) async {
  final cubit = pageContext.read<PharmacyCubit>();
  final navigator = Navigator.of(dialogContext, rootNavigator: true);

  if (!HeartLoaderDialogController.isOpen(_kAbandonLoaderId)) {
    showHeartLoaderDialog(dialogContext, id: _kAbandonLoaderId, size: 120);
  }
  final result = await cubit.abandonPendingPaymentOrder();
  HeartLoaderDialogController.close(_kAbandonLoaderId);

  if (navigator.canPop()) navigator.pop();

  await result.fold(
    (error) async {
      if (!pageContext.mounted) return;
      final l10n = AppLocalizations.of(pageContext)!;
      final message = error.trim().isNotEmpty
          ? error.trim()
          : l10n.pharmacyAbandonUnpaidOrderFailed;
      ScaffoldMessenger.of(pageContext)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    },
    (_) async {},
  );
}
