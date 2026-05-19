import 'package:apnaclinic/generated/assets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserProfileAvatar extends StatelessWidget {
  const UserProfileAvatar({
    super.key,
    this.imageUrl,
    required this.size,
    this.fit = BoxFit.cover,
  });

  final String? imageUrl;
  final double size;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim() ?? '';
    final hasNetworkImage =
        url.isNotEmpty &&
        (url.startsWith('http://') || url.startsWith('https://'));

    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: hasNetworkImage
            ? CachedNetworkImage(
                imageUrl: url,
                fit: fit,
                placeholder: (_, _) => _placeholder(),
                errorWidget: (_, _, _) => _placeholder(),
              )
            : _placeholder(),
      ),
    );
  }

  Widget _placeholder() {
    return Image.asset(
      Assets.imgPlaceHolderPerson,
      width: size,
      height: size,
      fit: fit,
    );
  }
}
