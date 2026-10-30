import 'dart:math' as math;

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

  /// Finger-follow dismiss (pops the outer Pro modal, not the nested navigator).
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
                child: _ProSheetMotion(
                  onDismiss: onRequestClose,
                  builder: (context, physics) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.clrWhite,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24.r),
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: shrinkWrap
                          ? _shrinkWrappedSheet(context, state, physics)
                          : _expandedSheet(context, state, maxHeight),
                    );
                  },
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

  Widget _shrinkWrappedSheet(
    BuildContext context,
    ProState state,
    ScrollPhysics physics,
  ) {
    return SingleChildScrollView(
      physics: physics,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _ProSheetDragHandle(trackDrag: false),
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
          const _ProSheetDragHandle(),
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
      scrollPhysics: _ProSheetMotion.physicsOf(context),
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

/// Large top grab area. The nested navigator blocks the modal's own drag,
/// so this moves the sheet with the finger and eases it closed.
class _ProSheetDragHandle extends StatelessWidget {
  const _ProSheetDragHandle({this.trackDrag = true});

  /// False when the handle sits inside the sheet scroll view, which already
  /// forwards a downward pull into [_ProSheetMotion].
  final bool trackDrag;

  @override
  Widget build(BuildContext context) {
    final motion = _ProSheetMotion.maybeOf(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: trackDrag
          ? (details) => motion?.addDelta(details.delta.dy)
          : null,
      onVerticalDragEnd: trackDrag
          ? (details) => motion?.endDrag(details.primaryVelocity ?? 0)
          : null,
      onVerticalDragCancel: trackDrag ? () => motion?.endDrag(0) : null,
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
    this.scrollPhysics,
  });

  final ProCatalogEntity catalog;
  final String? selectedPlanId;
  final ValueChanged<String> onPlanSelected;
  final VoidCallback onSubscribe;
  final ScrollPhysics? scrollPhysics;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: scrollPhysics,
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

/// Slides the Pro sheet with the finger, then eases it off-screen or back.
///
/// The nested navigator inside the modal blocks [ModalBottomSheetRoute] drag,
/// so the sheet translates itself and only then asks to be popped.
class _ProSheetMotion extends StatefulWidget {
  const _ProSheetMotion({required this.builder, required this.onDismiss});

  final Widget Function(BuildContext context, ScrollPhysics physics) builder;
  final VoidCallback? onDismiss;

  static _ProSheetMotionState? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_SheetDragScope>()
        ?.motion;
  }

  static ScrollPhysics physicsOf(BuildContext context) {
    return maybeOf(context)?.physics ?? const ClampingScrollPhysics();
  }

  @override
  State<_ProSheetMotion> createState() => _ProSheetMotionState();
}

class _ProSheetMotionState extends State<_ProSheetMotion>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<double> _offset = ValueNotifier<double>(0);
  late final AnimationController _settle;
  late final ScrollPhysics physics;
  Animation<double>? _anim;
  int _generation = 0;
  bool _closing = false;
  bool _settling = false;

  @override
  void initState() {
    super.initState();
    _settle = AnimationController(vsync: this);
    physics = _PullToClosePhysics(
      motion: this,
      parent: const AlwaysScrollableScrollPhysics(
        parent: ClampingScrollPhysics(),
      ),
    );
  }

  @override
  void dispose() {
    _clearAnim();
    _settle.dispose();
    _offset.dispose();
    super.dispose();
  }

  double get _limit => MediaQuery.sizeOf(context).height;

  void addDelta(double dy) {
    if (!mounted || _closing) return;
    _generation++;
    _settling = false;
    if (_settle.isAnimating) {
      _settle.stop();
      _clearAnim();
    }
    final next = (_offset.value + dy).clamp(0.0, _limit);
    if (next == _offset.value) return;
    _offset.value = next;
  }

  void endDrag(double velocity) {
    if (!mounted || _closing || _settling) return;
    final current = _offset.value;
    if (current <= 0) return;
    final flungClosed = velocity > 1000;
    final flungOpen = velocity < -300;
    final dismiss = !flungOpen && (flungClosed || current > 120);
    if (dismiss) {
      _animateTo(
        _limit,
        const Duration(milliseconds: 280),
        Curves.easeInCubic,
        _finishDismiss,
      );
    } else {
      _animateTo(0, const Duration(milliseconds: 320), Curves.easeOutCubic, null);
    }
  }

  void _finishDismiss() {
    if (!mounted || _closing) return;
    _closing = true;
    widget.onDismiss?.call();
  }

  void _animateTo(
    double target,
    Duration duration,
    Curve curve,
    VoidCallback? done,
  ) {
    final generation = ++_generation;
    _settling = true;
    final tween = Tween<double>(begin: _offset.value, end: target);
    _settle.duration = duration;
    _clearAnim();
    final anim = tween.animate(CurvedAnimation(parent: _settle, curve: curve));
    _anim = anim;
    anim.addListener(_tick);
    _settle.forward(from: 0).whenComplete(() {
      if (!mounted || generation != _generation) return;
      _settling = false;
      _clearAnim();
      done?.call();
    });
  }

  void _tick() {
    final anim = _anim;
    if (anim == null) return;
    _offset.value = anim.value;
  }

  void _clearAnim() {
    _anim?.removeListener(_tick);
    _anim = null;
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification is! ScrollEndNotification) return false;
    if (notification.metrics.axis != Axis.vertical) return false;
    endDrag(notification.dragDetails?.primaryVelocity ?? 0);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _onScroll,
      child: _SheetDragScope(
        motion: this,
        child: ValueListenableBuilder<double>(
          valueListenable: _offset,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, value),
              child: child,
            );
          },
          child: Builder(
            builder: (context) => widget.builder(context, physics),
          ),
        ),
      ),
    );
  }
}

class _SheetDragScope extends InheritedWidget {
  const _SheetDragScope({required this.motion, required super.child});

  final _ProSheetMotionState motion;

  @override
  bool updateShouldNotify(_SheetDragScope oldWidget) =>
      oldWidget.motion != motion;
}

class _PullToClosePhysics extends ScrollPhysics {
  const _PullToClosePhysics({required this.motion, super.parent});

  final _ProSheetMotionState motion;

  @override
  _PullToClosePhysics applyTo(ScrollPhysics? ancestor) {
    return _PullToClosePhysics(motion: motion, parent: buildParent(ancestor));
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (motion._closing) {
      return super.applyBoundaryConditions(position, value);
    }
    if (motion._offset.value > 0 && value > position.pixels) {
      final delta = value - position.pixels;
      final consume = math.min(delta, motion._offset.value);
      motion.addDelta(-consume);
      return consume;
    }
    final atTop = position.pixels <= position.minScrollExtent;
    if (atTop && value < position.pixels) {
      motion.addDelta(position.pixels - value);
      return value - position.pixels;
    }
    return super.applyBoundaryConditions(position, value);
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
