import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';

/// Non-cancellable modal dialog informing the user about JazzCash payment authorization
/// steps (for both Jazz SIM users and other networks), matching the official design.
class JazzCashPaymentVerificationDialog extends StatelessWidget {
  const JazzCashPaymentVerificationDialog({
    super.key,
    this.title,
  });

  final String? title;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.88,
          ),
          decoration: BoxDecoration(
            color: AppColors.clrWhite,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 24.r,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(18.w, 22.h, 18.w, 22.h),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: "Waiting for payment\nconfirmation"
                Text(
                  title ??
                      l10n.jazzCashWaitingForPaymentConfirmationTitle,
                  style: TextStyle(
                    color: const Color(0xFF101828),
                    fontSize: 21.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 16.h),

                // Card 1: Status Card with loader and "Waiting for approval..."
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.jazzCashStatusTitle,
                        style: TextStyle(
                          color: const Color(0xFF101828),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        l10n.jazzCashStatusWaitingMessage,
                        style: TextStyle(
                          color: const Color(0xFF475467),
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16.r,
                            height: 16.r,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.2,
                              color: Color(0xFFD92D20),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            l10n.jazzCashWaitingForApproval,
                            style: TextStyle(
                              color: const Color(0xFFD92D20),
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),

                // Card 2: For Jazz Users
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        Assets.svgIcJazzLogo,
                        width: 36.r,
                        height: 36.r,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        l10n.jazzCashForJazzUsersTitle,
                        style: TextStyle(
                          color: const Color(0xFF101828),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        l10n.jazzCashForJazzUsersDescription,
                        style: TextStyle(
                          color: const Color(0xFF475467),
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),

                // Card 3: For Other Networks
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        Assets.iconsSatelliteDish,
                        width: 32.r,
                        height: 32.r,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        l10n.jazzCashForOtherNetworksTitle,
                        style: TextStyle(
                          color: const Color(0xFF101828),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        l10n.jazzCashForOtherNetworksSubtitle,
                        style: TextStyle(
                          color: const Color(0xFF344054),
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      _buildStepItem(l10n.jazzCashOtherNetworksStep1),
                      SizedBox(height: 8.h),
                      _buildStepItem(l10n.jazzCashOtherNetworksStep2),
                      SizedBox(height: 8.h),
                      _buildStepItem(l10n.jazzCashOtherNetworksStep3),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.clrWhite,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.2,
        ),
      ),
      child: child,
    );
  }

  Widget _buildStepItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 6.h, right: 8.w),
          child: Container(
            width: 4.r,
            height: 4.r,
            decoration: const BoxDecoration(
              color: Color(0xFF344054),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: const Color(0xFF475467),
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w400,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

class _JazzCashVerificationDialogEntry {
  const _JazzCashVerificationDialogEntry({
    required this.navigatorState,
    required this.route,
  });

  final NavigatorState navigatorState;
  final DialogRoute<void> route;
}

/// Controller to programmatically show and dismiss the non-cancellable JazzCash verification dialog.
class JazzCashPaymentVerificationDialogController {
  JazzCashPaymentVerificationDialogController._();

  static final Map<String, _JazzCashVerificationDialogEntry> _activeDialogs = {};

  static bool isOpen(String id) => _activeDialogs.containsKey(id);

  static Future<void> show(
    BuildContext context, {
    String id = 'default_jazzcash_verification',
    String? title,
  }) {
    if (isOpen(id)) {
      return Future<void>.value();
    }

    final navigatorState = Navigator.of(context, rootNavigator: true);
    final route = DialogRoute<void>(
      context: context,
      builder: (_) => JazzCashPaymentVerificationDialog(
        title: title,
      ),
      barrierDismissible: false,
      barrierColor: Colors.black54,
      useSafeArea: true,
      settings: RouteSettings(name: 'jazzcash_verification_dialog_$id'),
    );

    _activeDialogs[id] = _JazzCashVerificationDialogEntry(
      navigatorState: navigatorState,
      route: route,
    );

    return navigatorState.push(route).whenComplete(() {
      _activeDialogs.remove(id);
    });
  }

  static void close(String id) {
    final entry = _activeDialogs.remove(id);
    if (entry == null) return;
    if (entry.route.isActive) {
      if (entry.route.isCurrent) {
        entry.navigatorState.pop();
      } else {
        entry.navigatorState.removeRoute(entry.route);
      }
    }
  }

  static void closeAll() {
    for (final id in _activeDialogs.keys.toList()) {
      close(id);
    }
  }
}

/// Convenience function to show the JazzCash payment verification dialog.
Future<void> showJazzCashPaymentVerificationDialog(
  BuildContext context, {
  String id = 'default_jazzcash_verification',
  String? title,
}) {
  return JazzCashPaymentVerificationDialogController.show(
    context,
    id: id,
    title: title,
  );
}

// Backward-compatible aliases for existing callers
typedef JazzCashPaymentVerificationSheet = JazzCashPaymentVerificationDialog;
typedef JazzCashPaymentVerificationSheetController = JazzCashPaymentVerificationDialogController;
Future<void> showJazzCashPaymentVerificationSheet(
  BuildContext context, {
  String id = 'default_jazzcash_verification',
  String? title,
}) => showJazzCashPaymentVerificationDialog(context, id: id, title: title);
