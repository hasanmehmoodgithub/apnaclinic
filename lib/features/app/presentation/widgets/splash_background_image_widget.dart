import 'package:flutter/material.dart';

import '../../../../generated/assets.dart';

class SplashBackgroundImageWidget extends StatelessWidget {
  const SplashBackgroundImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Image.asset(
        Assets.assetsImgSplash,
        fit: BoxFit.cover,
      ),
    );
  }
}
