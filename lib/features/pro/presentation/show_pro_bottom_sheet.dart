import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../core/extensions/screen_util_extensions.dart';
import '../domain/entities/pro_plan_entity.dart';
import 'cubit/pro_cubit.dart';
import 'widgets/pro_bottom_sheet.dart';
import 'widgets/pro_subscribe_success_dialog.dart';

/// Result returned when the user taps the Pro CTA.
class ProSheetResult {
  const ProSheetResult({
    required this.planId,
    required this.plan,
  });

  final String planId;
  final ProPlanEntity? plan;
}

/// Opens the ApnaClinic Pro catalog bottom sheet (content from API).
///
/// When [showSuccessDialog] is true (default), the subscribe-success dialog
/// is shown after the sheet closes with a selected plan.
Future<ProSheetResult?> showApnaClinicProSheet(
  BuildContext context, {
  bool showSuccessDialog = true,
}) async {
  final result = await showModalBottomSheet<ProSheetResult>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
    ),
    builder: (sheetContext) {
      return BlocProvider(
        create: (_) => sl<ProCubit>()..loadCatalog(),
        child: Builder(
          builder: (providerContext) {
            return ProBottomSheet(
              onSubscribe: (planId) {
                final catalog = providerContext.read<ProCubit>().state.catalog;
                ProPlanEntity? plan;
                if (catalog != null) {
                  for (final item in catalog.plans) {
                    if (item.planId == planId) {
                      plan = item;
                      break;
                    }
                  }
                }
                sheetContext.pop(ProSheetResult(planId: planId, plan: plan));
              },
            );
          },
        ),
      );
    },
  );

  if (showSuccessDialog &&
      result != null &&
      context.mounted) {
    await showProSubscribeSuccessDialog(context);
  }

  return result;
}
