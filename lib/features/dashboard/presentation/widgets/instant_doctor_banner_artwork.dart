import 'dart:convert';

import 'package:apnaclinic/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../constants/dashboard_ui_config.dart';

/// Renders `instant_doc.svg` (24 badge behind doctor) from embedded raster layers.
class InstantDoctorBannerArtwork extends StatefulWidget {
  const InstantDoctorBannerArtwork({super.key});

  @override
  State<InstantDoctorBannerArtwork> createState() =>
      _InstantDoctorBannerArtworkState();
}

class _InstantDoctorBannerArtworkState extends State<InstantDoctorBannerArtwork> {
  static Future<_InstantDoctorArtworkLayers>? _layersFuture;

  static const _doctorWidth = 78.7622;
  static const _doctorHeight = 94.3506;
  static const _badgeX = 41.0469;
  static const _badgeY = 4.32471;
  static const _badgeSize = 63.1739;
  static const _viewBoxWidth = 105.0;
  static const _viewBoxHeight = 95.0;

  static Future<_InstantDoctorArtworkLayers> _loadLayers() async {
    final svgText = await rootBundle.loadString(Assets.svgInstantDoc);
    final matches = RegExp(
      r'data:image/(?:png|jpeg|jpg|webp);base64,([A-Za-z0-9+/=\s]+)',
      caseSensitive: false,
    ).allMatches(svgText);

    Uint8List? decodeAt(int index) {
      if (index >= matches.length) return null;
      try {
        final normalized =
            matches.elementAt(index).group(1)!.replaceAll(RegExp(r'\s'), '');
        return base64Decode(normalized);
      } catch (_) {
        return null;
      }
    }

    return _InstantDoctorArtworkLayers(
      badgeBytes: decodeAt(0),
      doctorBytes: decodeAt(1),
    );
  }

  @override
  Widget build(BuildContext context) {
    _layersFuture ??= _loadLayers();

    final width = DashboardUiConfig.instantDoctorArtworkWidth.w;
    final height = DashboardUiConfig.instantDoctorArtworkHeight.h;

    return SizedBox(
      width: width,
      height: height,
      child: FutureBuilder<_InstantDoctorArtworkLayers>(
        future: _layersFuture,
        builder: (context, snapshot) {
          final layers = snapshot.data;
          if (layers == null) {
            return const SizedBox.shrink();
          }

          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomLeft,
            children: [
              if (layers.badgeBytes != null)
                Positioned(
                  left: width * (_badgeX / _viewBoxWidth),
                  top: height * (_badgeY / _viewBoxHeight),
                  width: width * (_badgeSize / _viewBoxWidth),
                  height: height * (_badgeSize / _viewBoxHeight),
                  child: Image.memory(
                    layers.badgeBytes!,
                    fit: BoxFit.contain,
                  ),
                ),
              if (layers.doctorBytes != null)
                Positioned(
                  left: 0,
                  bottom: 0,
                  width: width * (_doctorWidth / _viewBoxWidth),
                  height: height * (_doctorHeight / _viewBoxHeight),
                  child: Image.memory(
                    layers.doctorBytes!,
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _InstantDoctorArtworkLayers {
  const _InstantDoctorArtworkLayers({
    required this.badgeBytes,
    required this.doctorBytes,
  });

  final Uint8List? badgeBytes;
  final Uint8List? doctorBytes;
}
