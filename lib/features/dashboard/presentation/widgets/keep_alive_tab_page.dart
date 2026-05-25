import 'package:flutter/material.dart';

/// Preserves [child] state when used inside [PageView] tab navigation.
class KeepAliveTabPage extends StatefulWidget {
  const KeepAliveTabPage({super.key, required this.child});

  final Widget child;

  @override
  State<KeepAliveTabPage> createState() => _KeepAliveTabPageState();
}

class _KeepAliveTabPageState extends State<KeepAliveTabPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
