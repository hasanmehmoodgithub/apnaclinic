// Cart list + checkout CTA; lines and persistence live in LabTestCartCubit.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../cubit/lab_test_cart_cubit.dart';
import '../cubit/lab_test_cart_state.dart';
import '../lab_test_analytics.dart';
import '../widgets/lab_test_cart_bottom_bar_widget.dart';
import '../widgets/lab_test_cart_empty_widget.dart';
import '../widgets/lab_test_cart_header_widget.dart';
import '../widgets/lab_test_cart_item_tile_widget.dart';

class LabTestCartScreen extends StatefulWidget {
  const LabTestCartScreen({super.key});

  @override
  State<LabTestCartScreen> createState() => _LabTestCartScreenState();
}

class _LabTestCartScreenState extends State<LabTestCartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      LabTestAnalytics.logCartViewed();
      context.read<LabTestCartCubit>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffoldGradient(
      child: Column(
        children: [
          LabTestCartHeaderWidget(title: l10n.labTestCartScreenTitle),
          AppScaffoldGradientPanel(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 12.h),
              child: BlocBuilder<LabTestCartCubit, LabTestCartState>(
                buildWhen: (previous, current) =>
                    previous.items != current.items,
                builder: (context, state) {
                  return Column(
                    children: [
                      Expanded(
                        child: state.items.isEmpty
                            ? LabTestCartEmptyWidget(
                                message: l10n.labTestCartEmptyMessage,
                              )
                            : ListView.separated(
                                itemCount: state.items.length,
                                separatorBuilder: (_, _) =>
                                    SizedBox(height: 12.h),
                                itemBuilder: (context, index) {
                                  return LabTestCartItemTileWidget(
                                    item: state.items[index],
                                    sampleTypeLabel: l10n.labTestSampleTypeLabel,
                                    onRemove: () => _onRemoveAt(context, index),
                                  );
                                },
                              ),
                      ),
                      LabTestCartBottomBarWidget(
                        enabled: state.items.isNotEmpty,
                        label: l10n.labTestCartProceedCheckout,
                        onProceed: () => _onProceedCheckout(context),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onRemoveAt(BuildContext context, int index) {
    return context.read<LabTestCartCubit>().removeAt(index);
  }

  void _onProceedCheckout(BuildContext context) {
    final cubit = context.read<LabTestCartCubit>();
    final extra = cubit.checkoutArgsForCart();
    if (extra == null) return;
    context.pushNamed(AppRoutes.labTestCheckout, extra: extra);
  }
}
