import 'package:flutter/material.dart';

import '../extensions/screen_util_extensions.dart';

/// Defines which action buttons appear in [AppInfoDialog].
///
/// - [okOnly]   → Single neutral "OK" button (default).
/// - [success]  → Single green confirmation button (e.g. "Confirm", "Continue").
/// - [cancel]   → Single red cancel button (e.g. "Cancel", "Discard").
/// - [confirm]  → Two buttons: red cancel + green success (destructive/confirm flows).
enum AppInfoDialogActions { okOnly, success, cancel, confirm }


class AppInfoDialog extends StatelessWidget {
  final String title;
  final String description;
  final AppInfoDialogActions actions;

  final String okLabel;
  final String successLabel;
  final String cancelLabel;

  final VoidCallback? onOk;
  final VoidCallback? onSuccess;
  final VoidCallback? onCancel;

  /// Optional icon shown above the title.
  final IconData? icon;
  final Color? iconColor;

  const AppInfoDialog({
    super.key,
    required this.title,
    required this.description,
    this.actions = AppInfoDialogActions.okOnly,
    this.okLabel = 'OK',
    this.successLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.onOk,
    this.onSuccess,
    this.onCancel,
    this.icon,
    this.iconColor,
  });

  /// Convenience launcher. Returns:
  /// - `true`  → success button tapped
  /// - `false` → cancel button tapped
  /// - `null`  → dismissed / OK tapped (no semantic result)
  static Future<T?> show<T>(
      BuildContext context, {
        required String title,
        required String description,
        AppInfoDialogActions actions = AppInfoDialogActions.okOnly,
        String okLabel = 'OK',
        String successLabel = 'Confirm',
        String cancelLabel = 'Cancel',
        bool barrierDismissible = true,
        IconData? icon,
        Color? iconColor,
      }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => AppInfoDialog(
        title: title,
        description: description,
        actions: actions,
        okLabel: okLabel,
        successLabel: successLabel,
        cancelLabel: cancelLabel,
        icon: icon,
        iconColor: iconColor,
      ),
    );
  }

  // ─── Colors ───
  static const Color _navy = Color(0xFF061E40);
  static const Color _success = Color(0xFF1AB6A1); // teal-green
  static const Color _danger = Color(0xFFE5484D);  // red

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 24.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.75,
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 44.r,
                  color: iconColor ?? _navy,
                ),
                SizedBox(height: 12.h),
              ],
              Text(
                title,
                textAlign: TextAlign.center,
                style: textTheme.titleLarge?.copyWith(
                  color: _navy,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10.h),
              Flexible(
                child: SingleChildScrollView(
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: _navy.withOpacity(0.75),
                      fontSize: 14.sp,
                      height: 1.4,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 22.h),
              _buildActions(context, textTheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context, TextTheme textTheme) {
    switch (actions) {
      case AppInfoDialogActions.okOnly:
        return _DialogButton(
          label: okLabel,
          color: _navy,
          onPressed: () {
            onOk?.call();
            Navigator.of(context).pop();
          },
        );

      case AppInfoDialogActions.success:
        return _DialogButton(
          label: successLabel,
          color: _success,
          onPressed: () {
            onSuccess?.call();
            Navigator.of(context).pop(true);
          },
        );

      case AppInfoDialogActions.cancel:
        return _DialogButton(
          label: cancelLabel,
          color: _danger,
          onPressed: () {
            onCancel?.call();
            Navigator.of(context).pop(false);
          },
        );

      case AppInfoDialogActions.confirm:
        return Row(
          children: [
            Expanded(
              child: _DialogButton(
                label: cancelLabel,
                color: _danger,
                onPressed: () {
                  onCancel?.call();
                  Navigator.of(context).pop(false);
                },
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _DialogButton(
                label: successLabel,
                color: _success,
                onPressed: () {
                  onSuccess?.call();
                  Navigator.of(context).pop(true);
                },
              ),
            ),
          ],
        );
    }
  }
}

class _DialogButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _DialogButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}