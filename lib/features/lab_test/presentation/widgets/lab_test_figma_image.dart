import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Displays a local SVG asset or remote image (PNG/JPG via [CachedNetworkImage],
/// SVG via [SvgPicture.network]) for lab-test UI.
class LabTestFigmaImage extends StatelessWidget {
  const LabTestFigmaImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.borderRadius,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  static final Map<String, Uint8List?> _embeddedPngCache =
      <String, Uint8List?>{};

  @override
  Widget build(BuildContext context) {
    final normalized = url.trim();

    Widget fallback() => Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: borderRadius ?? BorderRadius.circular(6),
      ),
      child: Icon(
        Icons.image_not_supported_outlined,
        size: ((width ?? height ?? 24) * 0.55).clamp(12, 24).toDouble(),
        color: const Color(0xFF9BA6A7),
      ),
    );

    if (normalized.isEmpty) {
      return fallback();
    }

    if (normalized.startsWith('http')) {
      final path = Uri.tryParse(normalized)?.path.toLowerCase() ?? '';
      if (path.endsWith('.svg')) {
        final networkSvg = SvgPicture.network(
          normalized,
          width: width,
          height: height,
          fit: fit,
          placeholderBuilder: (_) => fallback(),
          errorBuilder: (_, _, _) => fallback(),
        );
        if (borderRadius != null) {
          return ClipRRect(borderRadius: borderRadius!, child: networkSvg);
        }
        return networkSvg;
      }

      final networkChild = CachedNetworkImage(
        imageUrl: normalized,
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, _) => fallback(),
        errorWidget: (_, _, _) => fallback(),
      );
      if (borderRadius != null) {
        return ClipRRect(borderRadius: borderRadius!, child: networkChild);
      }
      return networkChild;
    }

    if (!normalized.startsWith('assets/')) {
      return fallback();
    }

    final child = _needsEmbeddedPngFallback(normalized)
        ? FutureBuilder<Uint8List?>(
            future: _loadEmbeddedPng(normalized),
            builder: (context, snapshot) {
              final bytes = snapshot.data;
              if (bytes == null) {
                return fallback();
              }
              return Image.memory(
                bytes,
                width: width,
                height: height,
                fit: fit,
                errorBuilder: (_, _, _) => fallback(),
              );
            },
          )
        : SvgPicture.asset(
            normalized,
            width: width,
            height: height,
            fit: fit,
            placeholderBuilder: (_) => SizedBox(
              width: width,
              height: height,
              child: const Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            errorBuilder: (_, _, _) => fallback(),
          );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: child);
    }
    return child;
  }

  static bool _needsEmbeddedPngFallback(String assetPath) {
    final lower = assetPath.toLowerCase();
    return lower.endsWith('/idc_logo.svg') ||
        lower.endsWith('/naya_lab_logo.svg') ||
        lower.endsWith('/mediq_logo.svg') ||
        lower.endsWith('/oladoc_ogo.svg');
  }

  static Future<Uint8List?> _loadEmbeddedPng(String assetPath) async {
    if (_embeddedPngCache.containsKey(assetPath)) {
      return _embeddedPngCache[assetPath];
    }
    try {
      final svg = await rootBundle.loadString(assetPath);
      final match = RegExp(
        r'(?:xlink:href|href)="data:image\/png;base64,([^"]+)"',
      ).firstMatch(svg);
      final base64 = match?.group(1);
      if (base64 == null || base64.isEmpty) {
        _embeddedPngCache[assetPath] = null;
        return null;
      }
      final bytes = base64Decode(base64);
      _embeddedPngCache[assetPath] = bytes;
      return bytes;
    } catch (_) {
      _embeddedPngCache[assetPath] = null;
      return null;
    }
  }
}
