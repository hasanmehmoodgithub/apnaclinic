import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/widgets/user_profile_avatar.dart';

class ProfileSetupAvatarPicker extends StatelessWidget {
  const ProfileSetupAvatarPicker({
    super.key,
    this.imageUrl,
    this.selectedImageFile,
    required this.onPickImage,
  });

  final String? imageUrl;
  final File? selectedImageFile;
  final VoidCallback onPickImage;

  static const double _avatarSize = 112;

  @override
  Widget build(BuildContext context) {
    final hasLocalImage = selectedImageFile != null;

    return GestureDetector(
      onTap: onPickImage,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (hasLocalImage)
            CircleAvatar(
              radius: 56.r,
              backgroundColor: AppColors.clrWhite.withValues(alpha: 0.95),
              backgroundImage: FileImage(selectedImageFile!),
            )
          else
            UserProfileAvatar(
              imageUrl: imageUrl,
              size: _avatarSize.r,
            ),
          Positioned(
            right: 2.w,
            bottom: 4.h,
            child: Container(
              padding: EdgeInsets.all(6.r),
              decoration: const BoxDecoration(
                color: AppColors.clrDDF3EE,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.camera_alt_outlined,
                size: 16.r,
                color: AppColors.clr0FAA9A,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
