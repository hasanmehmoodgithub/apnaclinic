import 'package:flutter/material.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../core/l10n/app_localizations.dart';
import '../domain/repositories/lab_test_cart_repository.dart';
import 'lab_test_navigation.dart';
import 'widgets/lab_test_cart_change_warning_dialog_widget.dart';

/// If the cart has items, warns that changing city / provider / lab clears it.
///
/// - Empty cart → runs [onProceed] immediately.
/// - Continue → clears cart storage, then [onProceed].
/// - View Cart → opens cart (or [onViewCart] if provided) and does not run [onProceed].
Future<void> labTestGuardCartClearingChange(
  BuildContext context, {
  required Future<void> Function() onProceed,
  Future<void> Function()? onCartCleared,
  Future<void> Function()? onViewCart,
}) async {
  final repository = sl<LabTestCartRepository>();
  final items = await repository.readCart();
  if (items.isEmpty) {
    await onProceed();
    return;
  }

  if (!context.mounted) return;
  final l10n = AppLocalizations.of(context)!;
  final action = await showDialog<LabTestCartChangeDialogAction>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => LabTestCartChangeWarningDialogWidget(
      title: l10n.labTestCartChangeWarningTitle,
      body: l10n.labTestCartChangeWarningBody,
      viewCartLabel: l10n.labTestCartChangeViewCart,
      continueLabel: l10n.labTestCartChangeContinue,
    ),
  );

  if (!context.mounted || action == null) return;

  if (action == LabTestCartChangeDialogAction.viewCart) {
    if (onViewCart != null) {
      await onViewCart();
    } else {
      await labTestOpenCart(context);
    }
    return;
  }

  await repository.writeCart(const []);
  await onCartCleared?.call();
  if (!context.mounted) return;
  await onProceed();
}
