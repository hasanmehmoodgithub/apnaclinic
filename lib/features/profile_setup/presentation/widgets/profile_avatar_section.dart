import 'package:apnaclinic/generated/assets.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

class ProfileAvatarSection extends StatelessWidget {
  const ProfileAvatarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, -0.96),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 126.r,
            height: 126.r,
            child: Image.asset(Assets.imgPlaceHolderPerson),
          ),
        ],
      ),
    );
  }
}
