import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/widgets/pro_user_avatar.dart';

class ProfileAvatarSection extends StatelessWidget {
  const ProfileAvatarSection({
    super.key,
    this.imageUrl,
    this.isPro = false,
  });

  final String? imageUrl;
  final bool isPro;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, -0.96),
      child: ProUserAvatar(
        imageUrl: imageUrl,
        size: 126.r,
        isPro: isPro,
      ),
    );
  }
}
