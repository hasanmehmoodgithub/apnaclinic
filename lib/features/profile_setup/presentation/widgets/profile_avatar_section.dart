import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/widgets/user_profile_avatar.dart';

class ProfileAvatarSection extends StatelessWidget {
  const ProfileAvatarSection({super.key, this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, -0.96),
      child: UserProfileAvatar(
        imageUrl: imageUrl,
        size: 126.r,
      ),
    );
  }
}
