import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../generated/assets.dart';

class SearchVoiceListeningLottie extends StatelessWidget {
  const SearchVoiceListeningLottie({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      Assets.imagesVoiceSearchRecord,
      width: size,
      height: size,
      fit: BoxFit.contain,
      repeat: true,
    );
  }
}
