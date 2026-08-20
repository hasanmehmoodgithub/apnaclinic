import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'profile_image_source_option_tile.dart';

Future<ImageSource?> showProfileImageSourceSheet(BuildContext context) {
  return showModalBottomSheet<ImageSource>(
    context: context,
    backgroundColor: AppColors.clrWhite,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
    ),
    builder: (sheetContext) {
      return ProfileImageSourceSheet(
        onCameraTap: () => sheetContext.pop(ImageSource.camera),
        onGalleryTap: () => sheetContext.pop(ImageSource.gallery),
      );
    },
  );
}

class ProfileImageSourceSheet extends StatelessWidget {
  const ProfileImageSourceSheet({
    super.key,
    required this.onCameraTap,
    required this.onGalleryTap,
  });

  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                color: AppColors.clrD4D9E1,
                borderRadius: BorderRadius.circular(99.r),
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              l10n.profileImageSourceTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.clr060,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 14.h),
            ProfileImageSourceOptionTile(
              icon: Icons.camera_alt_outlined,
              label: l10n.profileUseCamera,
              onTap: onCameraTap,
            ),
            ProfileImageSourceOptionTile(
              icon: Icons.photo_library_outlined,
              label: l10n.profileChooseFromGallery,
              onTap: onGalleryTap,
            ),
          ],
        ),
      ),
    );
  }
}
