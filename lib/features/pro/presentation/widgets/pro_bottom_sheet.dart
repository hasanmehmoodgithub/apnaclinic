import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/session/auth_session_refresh.dart';
import '../../../../core/utils/auth_guard.dart';
import '../../../../core/widgets/app_button_widget.dart';
import '../../../lab_test/presentation/cubit/lab_test_cart_cubit.dart';
import '../../domain/entities/pro_catalog_entity.dart';
import '../cubit/pro_cubit.dart';
import '../cubit/pro_state.dart';
import 'pro_active_member_content.dart';
import 'pro_benefits_table_widget.dart';
import 'pro_cancel_subscription_dialog.dart';
import 'pro_plan_cards_widget.dart';
import 'pro_sheet_header_widget.dart';
import 'pro_sheet_shimmer_widget.dart';

class ProBottomSheet extends StatelessWidget {
  const ProBottomSheet({
    super.key,
    this.onSubscribe,
    this.onUnsubscribed,
    this.onRequestClose,
  });

  /// Starts JazzCash checkout for [planId] while this sheet stays open.
  /// [suppressSuccessDialog] is reserved for callers that already showed success.
  final void Function(String planId, {bool suppressSuccessDialog})? onSubscribe;

  /// Closes the sheet after unsubscribe succeeds so the cancel dialog can show.
  final VoidCallback? onUnsubscribed;

  /// Drag-handle dismiss (pops the outer Pro modal, not the nested navigator).
  final VoidCallback? onRequestClose;

  @override
  Widget build(BuildContext context) {
    return _ProSheetAuthRefresh(
      child: BlocBuilder<ProCubit, ProState>(
        builder: (context, state) {
          final media = MediaQuery.of(context);
          // Leave a little headroom so the sheet reads as draggable, not a page.
          final maxHeight = media.size.height * 0.94;
          final shrinkWrap = _shouldShrinkWrap(state);
          return Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              bottom: false,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxHeight),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.clrWhite,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24.r),
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: shrinkWrap
                      ? _shrinkWrappedSheet(context, state)
                      : _expandedSheet(context, state, maxHeight),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Active / error: height follows content (no empty white footer).
  static bool _shouldShrinkWrap(ProState state) {
    final status = state.loadingStateStatus;
    if (status == StateStatus.loading ||
        status == StateStatus.idle ||
        (status == StateStatus.refreshing && state.catalog == null)) {
      return false;
    }
    if (status == StateStatus.error || state.catalog == null) return true;
    return state.catalog!.membership.isActivePro;
  }

  Widget _shrinkWrappedSheet(BuildContext context, ProState state) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ProSheetDragHandle(onDismiss: onRequestClose),
          _body(context, state),
        ],
      ),
    );
  }

  Widget _expandedSheet(
    BuildContext context,
    ProState state,
    double maxHeight,
  ) {
    return SizedBox(
      height: maxHeight,
      child: Column(
        children: [
          _ProSheetDragHandle(onDismiss: onRequestClose),
          Expanded(child: _body(context, state)),
        ],
      ),
    );
  }

  Widget _body(BuildContext context, ProState state) {
    final status = state.loadingStateStatus;
    if (status == StateStatus.loading ||
        status == StateStatus.idle ||
        (status == StateStatus.refreshing && state.catalog == null)) {
      return const ProSheetShimmerWidget();
    }
    if (status == StateStatus.error || state.catalog == null) {
      return _ProSheetError(
        message: state.errorMessage,
        onRetry: () => context.read<ProCubit>().loadCatalog(),
      );
    }

    final catalog = state.catalog!;
    if (catalog.membership.isActivePro) {
      final isCancelling = state.subscribeStateStatus == StateStatus.loading;
      return Stack(
        alignment: Alignment.center,
        children: [
          AbsorbPointer(
            absorbing: isCancelling,
            child: ProActiveMemberContent(
              catalog: catalog,
              onCancelSubscription: () => _onCancelSubscription(context),
            ),
          ),
          if (isCancelling) const CircularProgressIndicator(),
        ],
      );
    }

    return _ProSubscribeContent(
      catalog: catalog,
      selectedPlanId: state.selectedPlanId,
      onPlanSelected: context.read<ProCubit>().selectPlan,
      onSubscribe: () => _submitSubscribe(context),
    );
  }

  Future<void> _submitSubscribe(BuildContext context) async {
    if (!context.requireLogin()) return;
    final planId = context.read<ProCubit>().state.selectedPlanId;
    if (planId == null || planId.isEmpty) return;
    onSubscribe?.call(planId, suppressSuccessDialog: true);
  }

  void _showSubscribeMessage(BuildContext context, String? message) {
    final text = message?.trim();
    if (!context.mounted || text == null || text.isEmpty) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _onCancelSubscription(BuildContext context) async {
    final confirmed = await showProCancelSubscriptionDialog(context);
    if (!confirmed || !context.mounted) return;
    final cubit = context.read<ProCubit>();
    final cancellation = await cubit.unsubscribe();
    if (!context.mounted) return;
    if (cancellation == null) {
      if (cubit.state.subscribeStateStatus == StateStatus.loading) return;
      _showSubscribeMessage(context, cubit.state.subscribeErrorMessage);
      return;
    }

    await LabTestCartCubit.clearAfterProMembershipChange();
    if (!context.mounted) return;
    sl<AuthSessionRefresh>().notifyProMembershipChanged(isActive: false);
    if (!context.mounted) return;
    if (onUnsubscribed != null) {
      onUnsubscribed!();
    } else {
      context.pop();
    }
  }
}

/// Large top grab area — nested navigator blocks default modal drag, so this
/// closes the outer Pro sheet on a short downward swipe.
class _ProSheetDragHandle extends StatefulWidget {
  const _ProSheetDragHandle({this.onDismiss});

  final VoidCallback? onDismiss;

  @override
  State<_ProSheetDragHandle> createState() => _ProSheetDragHandleState();
}

class _ProSheetDragHandleState extends State<_ProSheetDragHandle> {
  double _dragDistance = 0;

  void _maybeDismiss({required double velocity}) {
    if (widget.onDismiss == null) return;
    if (_dragDistance > 28 || velocity > 400) {
      widget.onDismiss!();
    }
    _dragDistance = 0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragStart: (_) => _dragDistance = 0,
      onVerticalDragUpdate: (details) {
        if (details.delta.dy > 0) {
          _dragDistance += details.delta.dy;
        } else {
          _dragDistance = (_dragDistance + details.delta.dy).clamp(0, 200);
        }
      },
      onVerticalDragEnd: (details) {
        _maybeDismiss(velocity: details.primaryVelocity ?? 0);
      },
      onVerticalDragCancel: () => _dragDistance = 0,
      child: SizedBox(
        width: double.infinity,
        height: 36.h,
        child: Center(
          child: Container(
            width: 46.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: AppColors.clrDDE1E5,
              borderRadius: BorderRadius.circular(99.r),
            ),
          ),
        ),
      ),
    );
  }
}

/// Reloads Pro details when login or logout happens while the sheet is open.
///
/// A guest catalog would otherwise stay on the plan picker after the user
/// signs back in as an active member.
class _ProSheetAuthRefresh extends StatefulWidget {
  const _ProSheetAuthRefresh({required this.child});

  final Widget child;

  @override
  State<_ProSheetAuthRefresh> createState() => _ProSheetAuthRefreshState();
}

class _ProSheetAuthRefreshState extends State<_ProSheetAuthRefresh> {
  late final AuthSessionRefresh _session;
  late int _epoch;

  @override
  void initState() {
    super.initState();
    _session = sl<AuthSessionRefresh>();
    _epoch = _session.epoch;
    _session.addListener(_onSession);
  }

  @override
  void dispose() {
    _session.removeListener(_onSession);
    super.dispose();
  }

  void _onSession() {
    final epoch = _session.epoch;
    if (epoch == _epoch || !mounted) return;
    _epoch = epoch;
    context.read<ProCubit>().loadCatalog(refresh: true);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _ProSubscribeContent extends StatelessWidget {
  const _ProSubscribeContent({
    required this.catalog,
    required this.selectedPlanId,
    required this.onPlanSelected,
    required this.onSubscribe,
  });

  final ProCatalogEntity catalog;
  final String? selectedPlanId;
  final ValueChanged<String> onPlanSelected;
  final VoidCallback onSubscribe;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ProSheetHeaderWidget(
                  logoUrl: catalog.logoUrl,
                  bannerUrl: catalog.bannerUrl,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 16.h),
                      Text(
                        catalog.title,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: AppColors.clr111827,
                          fontWeight: FontWeight.w800,
                          fontSize: 22.sp,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        catalog.tagline,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: AppColors.clr6B7280,
                          fontWeight: FontWeight.w400,
                          fontSize: 13.sp,
                          height: 1.35,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Divider(height: 1.h, color: AppColors.clrE3E8EE),
                      ProBenefitsTableWidget(
                        benefitsTitle: catalog.benefitsTitle,
                        basicColumnLabel: catalog.basicColumnLabel,
                        proColumnLabel: catalog.proColumnLabel,
                        benefits: catalog.benefits,
                      ),
                      SizedBox(height: 16.h),
                      Divider(height: 1.h, color: AppColors.clrE3E8EE),
                      SizedBox(height: 16.h),
                      ProPlanCardsWidget(
                        sectionTitle: catalog.planSectionTitle,
                        plans: catalog.plans,
                        selectedPlanId: selectedPlanId,
                        onPlanSelected: onPlanSelected,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            20.w,
            8.h,
            20.w,
            16.h + MediaQuery.paddingOf(context).bottom,
          ),
          child: BlocSelector<ProCubit, ProState, bool>(
            selector: (state) =>
                state.subscribeStateStatus == StateStatus.loading,
            builder: (context, isSubmitting) {
              return AppButtonWidget(
                title: catalog.ctaLabel,
                bgClr: AppColors.clr1FAFA3,
                onTap: isSubmitting ? null : onSubscribe,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ProSheetError extends StatelessWidget {
  const _ProSheetError({required this.message, required this.onRetry});

  final String? message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 48.h, 24.w, 48.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message?.trim().isNotEmpty == true
                ? message!.trim()
                : l10n.proCatalogLoadError,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.clr6B7280, fontSize: 14.sp),
          ),
          SizedBox(height: 16.h),
          TextButton(
            onPressed: onRetry,
            child: Text(
              l10n.proRetry,
              style: const TextStyle(
                color: AppColors.clr1FAFA3,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
