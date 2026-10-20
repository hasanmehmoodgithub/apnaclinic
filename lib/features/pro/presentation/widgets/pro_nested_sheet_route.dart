import 'package:flutter/material.dart';

/// Pushes a bottom-sheet-looking route onto [navigator] without touching any
/// outer [showModalBottomSheet] (so the Pro catalog sheet stays open).
Future<T?> pushProNestedSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  return Navigator.of(context).push<T>(
    PageRouteBuilder<T>(
      opaque: false,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 250),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: builder(context),
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offset = Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
        return SlideTransition(position: offset, child: child);
      },
    ),
  );
}
