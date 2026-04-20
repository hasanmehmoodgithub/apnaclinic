import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

class ProfileSetupAvatarPicker extends StatelessWidget {
  const ProfileSetupAvatarPicker({
    super.key,
    required this.avatarProvider,
    required this.onPickImage,
    required this.onImageError,
  });

  final ImageProvider? avatarProvider;
  final VoidCallback onPickImage;
  final VoidCallback onImageError;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 56.r,
          backgroundColor: Colors.white.withValues(alpha: 0.95),
          backgroundImage: avatarProvider,
          onBackgroundImageError: avatarProvider == null
              ? null
              : (_, _) => onImageError(),
          child: avatarProvider == null
              ? Icon(
                  Icons.account_circle_rounded,
                  size: 56.r,
                  color: const Color(0xFFBFD5D9),
                )
              : null,
        ),
        Positioned(
          right: 2.w,
          bottom: 4.h,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16.r),
              onTap: onPickImage,
              child: Container(
                padding: EdgeInsets.all(6.r),
                decoration: const BoxDecoration(
                  color: Color(0xFFDDF3EE),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt_outlined,
                  size: 16.r,
                  color: const Color(0xFF0FAA9A),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
