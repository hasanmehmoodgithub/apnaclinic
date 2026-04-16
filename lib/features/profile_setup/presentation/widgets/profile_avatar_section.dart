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
          Container(
            width: 126.r,
            height: 126.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3.r),
            ),
            child: const DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_rounded,
                color: Colors.grey,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 4.h),
            width: 122.w,
            height: 10.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99.r),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(79, 109, 138, 0.35),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
