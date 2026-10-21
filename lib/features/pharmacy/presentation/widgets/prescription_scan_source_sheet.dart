import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';

Future<ImageSource?> showPrescriptionScanSourceSheet(BuildContext context) {
  return showModalBottomSheet<ImageSource>(
    context: context,
    backgroundColor: AppColors.clrWhite,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
    ),
    builder: (sheetContext) {
      final l10n = AppLocalizations.of(sheetContext)!;
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 46.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: AppColors.clrD6DCE2,
                  borderRadius: BorderRadius.circular(99.r),
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                l10n.pharmacyScanSourceTitle,
                style: Theme.of(sheetContext).textTheme.titleMedium?.copyWith(
                  color: AppColors.clr060,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 14.h),
              _SourceTile(
                icon: Icons.camera_alt_outlined,
                label: l10n.pharmacyScanUseCamera,
                onTap: () => sheetContext.pop(ImageSource.camera),
              ),
              _SourceTile(
                icon: Icons.photo_library_outlined,
                label: l10n.pharmacyScanChooseGallery,
                onTap: () => sheetContext.pop(ImageSource.gallery),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _SourceTile extends StatelessWidget {
  const _SourceTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: AppColors.clrE0F7F6,
        child: Icon(icon, color: AppColors.clr00897B),
      ),
      title: Text(
        label,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: AppColors.clr060,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }
}
