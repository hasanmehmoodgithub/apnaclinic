import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';

class ProfileSetupTopBackground extends StatelessWidget {
  const ProfileSetupTopBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260.h,
      child: const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF87DDD3), Color(0xFFF4F5F7)],
          ),
        ),
      ),
    );
  }
}
