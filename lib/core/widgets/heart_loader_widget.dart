import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../extensions/screen_util_extensions.dart';

class HeartLoaderWidget extends StatelessWidget {
  const HeartLoaderWidget({super.key, this.size = 250});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/images/dashboard_loader.json',
        width: size.w,
        height: size.h,
        fit: BoxFit.contain,
        repeat: true,
      ),
    );
  }
}

class _HeartLoaderDialogEntry {
  const _HeartLoaderDialogEntry({
    required this.navigatorState,
    required this.route,
  });

  final NavigatorState navigatorState;
  final DialogRoute<void> route;
}

class HeartLoaderDialogController {
  HeartLoaderDialogController._();

  static final Map<String, _HeartLoaderDialogEntry> _activeDialogs = {};

  static bool isOpen(String id) => _activeDialogs.containsKey(id);

  static void close(String id) {
    final entry = _activeDialogs.remove(id);
    if (entry == null) return;
    entry.navigatorState.removeRoute(entry.route);
  }
}

Future<void> showHeartLoaderDialog(
  BuildContext context, {
  String id = 'default_heart_loader',
  bool barrierDismissible = false,
  double barrierOpacity = 0.1,
  double size = 250,
}) {
  if (HeartLoaderDialogController.isOpen(id)) {
    return Future<void>.value();
  }

  final navigatorState = Navigator.of(context, rootNavigator: true);
  final route = DialogRoute<void>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: Colors.black.withValues(alpha: barrierOpacity),
    builder: (_) => HeartLoaderWidget(size: size),
    settings: RouteSettings(name: 'heart_loader_$id'),
  );

  HeartLoaderDialogController._activeDialogs[id] = _HeartLoaderDialogEntry(
    navigatorState: navigatorState,
    route: route,
  );

  return navigatorState.push(route).whenComplete(() {
    HeartLoaderDialogController._activeDialogs.remove(id);
  });
}
