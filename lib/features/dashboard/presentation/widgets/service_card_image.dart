import 'dart:convert';
import 'dart:typed_data';

import 'package:apnaclinic/core/constants/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../constants/dashboard_ui_config.dart';
import 'service_icon_fallbacks.dart';

enum _ServiceImageKind { asset, rasterBytes, svgText, failed }

class _ResolvedServiceImage {
  const _ResolvedServiceImage._({
    required this.kind,
    this.assetPath,
    this.bytes,
    this.svgText,
  });

  const _ResolvedServiceImage.asset(String path)
    : this._(kind: _ServiceImageKind.asset, assetPath: path);

  const _ResolvedServiceImage.raster(Uint8List data)
    : this._(kind: _ServiceImageKind.rasterBytes, bytes: data);

  const _ResolvedServiceImage.svg(String text)
    : this._(kind: _ServiceImageKind.svgText, svgText: text);

  const _ResolvedServiceImage.failed()
    : this._(kind: _ServiceImageKind.failed);

  final _ServiceImageKind kind;
  final String? assetPath;
  final Uint8List? bytes;
  final String? svgText;
}

/// Loads CMS service icons. API "SVG" files often wrap a base64 PNG; those are
/// extracted and shown as raster instead of using [SvgPicture.network].
class ServiceCardImage extends StatefulWidget {
  const ServiceCardImage({
    super.key,
    required this.imageUrl,
    this.fallbackRoute,
    this.width,
    this.height,
  });

  final String imageUrl;
  final String? fallbackRoute;
  final double? width;
  final double? height;

  @override
  State<ServiceCardImage> createState() => _ServiceCardImageState();
}

class _ServiceCardImageState extends State<ServiceCardImage> {
  static final Map<String, _ResolvedServiceImage> _cache = {};
  static final Dio _dio = Dio();

  late Future<_ResolvedServiceImage> _loadFuture;

  @override
  void initState() {
    super.initState();
    _loadFuture = _resolveImage(widget.imageUrl);
  }

  @override
  void didUpdateWidget(ServiceCardImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _loadFuture = _resolveImage(widget.imageUrl);
    }
  }

  static bool _isSvgPath(String url) {
    final path = Uri.tryParse(url)?.path.toLowerCase() ?? url.toLowerCase();
    return path.endsWith('.svg');
  }

  static bool _looksLikeSvg(Uint8List bytes) {
    if (bytes.length < 5) return false;
    final prefix = utf8.decode(bytes.take(64).toList(), allowMalformed: true);
    return prefix.trimLeft().startsWith('<svg') ||
        prefix.trimLeft().startsWith('<?xml');
  }

  static Uint8List? _extractEmbeddedRaster(String svgText) {
    final match = RegExp(
      r'data:image/(?:png|jpeg|jpg|webp);base64,([A-Za-z0-9+/=\s]+)',
      caseSensitive: false,
    ).firstMatch(svgText);
    if (match == null) return null;

    try {
      final normalized = match.group(1)!.replaceAll(RegExp(r'\s'), '');
      return base64Decode(normalized);
    } catch (_) {
      return null;
    }
  }

  static Future<_ResolvedServiceImage> _resolveImage(String source) async {
    final url = source.trim();
    if (url.isEmpty) {
      return const _ResolvedServiceImage.failed();
    }

    if (!url.startsWith('http')) {
      return _ResolvedServiceImage.asset(url);
    }

    final cached = _cache[url];
    if (cached != null) {
      return cached;
    }

    try {
      final response = await _dio.get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      final bytes = Uint8List.fromList(response.data ?? []);
      if (bytes.isEmpty) {
        return const _ResolvedServiceImage.failed();
      }

      final isSvg = _isSvgPath(url) || _looksLikeSvg(bytes);
      if (isSvg) {
        final svgText = utf8.decode(bytes, allowMalformed: true);
        final embedded = _extractEmbeddedRaster(svgText);
        if (embedded != null) {
          final resolved = _ResolvedServiceImage.raster(embedded);
          _cache[url] = resolved;
          return resolved;
        }

        final resolved = _ResolvedServiceImage.svg(svgText);
        _cache[url] = resolved;
        return resolved;
      }

      final resolved = _ResolvedServiceImage.raster(bytes);
      _cache[url] = resolved;
      return resolved;
    } catch (_) {
      return const _ResolvedServiceImage.failed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final resolvedWidth = widget.width ?? DashboardUiConfig.serviceIconWidth.w;
    final resolvedHeight = widget.height ?? DashboardUiConfig.serviceIconHeight.h;
    final fallbackAsset = serviceIconFallbackAsset(widget.fallbackRoute);

    return SizedBox(
      width: resolvedWidth,
      height: resolvedHeight,
      child: FutureBuilder<_ResolvedServiceImage>(
        future: _loadFuture,
        builder: (context, snapshot) {
          final resolved = snapshot.data;
          if (resolved == null) {
            return _loadingOrFallback(
              resolvedWidth,
              resolvedHeight,
              fallbackAsset,
              loading: snapshot.connectionState != ConnectionState.done,
            );
          }

          return _buildResolved(
            resolved,
            resolvedWidth,
            resolvedHeight,
            fallbackAsset,
          );
        },
      ),
    );
  }

  Widget _buildResolved(
    _ResolvedServiceImage resolved,
    double width,
    double height,
    String? fallbackAsset,
  ) {
    switch (resolved.kind) {
      case _ServiceImageKind.asset:
        return _buildAsset(resolved.assetPath!, width, height, fallbackAsset);
      case _ServiceImageKind.rasterBytes:
        return Image.memory(
          resolved.bytes!,
          width: width,
          height: height,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) =>
              _fallbackOrPlaceholder(width, height, fallbackAsset),
        );
      case _ServiceImageKind.svgText:
        return SvgPicture.string(
          resolved.svgText!,
          width: width,
          height: height,
          fit: BoxFit.contain,
          placeholderBuilder: (_) => _placeholder(width, height),
        );
      case _ServiceImageKind.failed:
        return _fallbackOrPlaceholder(width, height, fallbackAsset);
    }
  }

  Widget _buildAsset(
    String path,
    double width,
    double height,
    String? fallbackAsset,
  ) {
    if (_isSvgPath(path)) {
      return SvgPicture.asset(
        path,
        width: width,
        height: height,
        fit: BoxFit.contain,
        placeholderBuilder: (_) => _placeholder(width, height),
      );
    }

    return Image.asset(
      path,
      width: width,
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) =>
          _fallbackOrPlaceholder(width, height, fallbackAsset),
    );
  }

  Widget _loadingOrFallback(
    double width,
    double height,
    String? fallbackAsset, {
    required bool loading,
  }) {
    if (loading) {
      return _placeholder(width, height);
    }
    return _fallbackOrPlaceholder(width, height, fallbackAsset);
  }

  Widget _fallbackOrPlaceholder(
    double width,
    double height,
    String? fallbackAsset,
  ) {
    if (fallbackAsset != null && fallbackAsset.isNotEmpty) {
      return Image.asset(
        fallbackAsset,
        width: width,
        height: height,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => _placeholder(width, height),
      );
    }

    final url = widget.imageUrl.trim();
    if (url.startsWith('http') && !_isSvgPath(url)) {
      return CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: BoxFit.contain,
        placeholder: (_, _) => _placeholder(width, height),
        errorWidget: (_, _, _) => _placeholder(width, height),
      );
    }

    return _placeholder(width, height);
  }

  Widget _placeholder(double width, double height) {
    final iconSize = (width < height ? width : height) * 0.45;
    return SizedBox(
      width: width,
      height: height,
      child: Center(
        child: Icon(
          Icons.medical_services_outlined,
          size: iconSize,
          color: AppColors.clr6B7280.withValues(alpha: 0.45),
        ),
      ),
    );
  }
}
