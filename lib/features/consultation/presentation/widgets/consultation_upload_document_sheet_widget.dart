import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'upload_option_tile.dart';

class ConsultationUploadDocumentSheetWidget extends StatelessWidget {
  const ConsultationUploadDocumentSheetWidget({
    super.key,
    required this.onCameraTap,
    required this.onGalleryTap,
    required this.onFileTap,
  });

  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;
  final VoidCallback onFileTap;

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
                color: const Color(0xFFD5D9DE),
                borderRadius: BorderRadius.circular(99.r),
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              l10n.consultationUploadDocumentTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color(0xFF061E40),
                fontSize: 30.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 14.h),
            UploadOptionTile(
              icon: Icons.camera_alt_outlined,
              label: l10n.consultationUseCamera,
              onTap: onCameraTap,
            ),
            UploadOptionTile(
              icon: Icons.photo_library_outlined,
              label: l10n.consultationUploadFromGallery,
              onTap: onGalleryTap,
            ),
            UploadOptionTile(
              icon: Icons.folder_open_outlined,
              label: l10n.consultationUploadFromFile,
              onTap: onFileTap,
            ),
          ],
        ),
      ),
    );
  }
}
