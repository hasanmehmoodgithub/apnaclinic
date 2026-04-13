import 'package:flutter/material.dart';

// TODO: Uncomment when assets.dart is generated (e.g., using flutter_gen)
// import '../../generated/assets.dart';

class AppLogoWidget extends StatelessWidget {
  final double width;
  final double height;
  final String? assetPath; // Optional: provide asset path directly

  const AppLogoWidget({
    super.key,
    this.width = 80, // default width
    this.height = 80, // default height
    this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Uncomment when assets.dart is generated
    // return Image.asset(
    //   Assets.imagesAppLogo,
    //   width: width,
    //   height: height,
    // );
    
    // Fallback: Use a placeholder icon or provided asset path
    if (assetPath != null) {
      return Image.asset(
        assetPath!,
        width: width,
        height: height,
      );
    }
    
    // Default placeholder
    return Icon(
      Icons.image,
      size: width,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}
