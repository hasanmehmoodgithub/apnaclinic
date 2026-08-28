import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dashboard/presentation/constants/main_navigation_tabs.dart';
import '../../../dashboard/presentation/cubit/main_navigation_cubit.dart';
import '../../../dashboard/presentation/cubit/main_navigation_state.dart';

/// Calls [onVisible] only when My Bookings is the bottom-nav tab and this
/// inner tab is selected. Prevents adjacent TabBarView pages from fetching.
class BookingsTabVisibilityListener extends StatefulWidget {
  const BookingsTabVisibilityListener({
    super.key,
    required this.tabIndex,
    required this.onVisible,
    required this.child,
  });

  final int tabIndex;
  final VoidCallback onVisible;
  final Widget child;

  @override
  State<BookingsTabVisibilityListener> createState() =>
      _BookingsTabVisibilityListenerState();
}

class _BookingsTabVisibilityListenerState
    extends State<BookingsTabVisibilityListener> {
  TabController? _tabs;
  MainNavigationCubit? _nav;
  bool _isActive = false;
  bool _notifyScheduled = false;

  @override
  void initState() {
    super.initState();
    _isActive = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _nav = context.read<MainNavigationCubit>();
    final tabs = DefaultTabController.maybeOf(context);
    if (tabs != _tabs) {
      _tabs?.removeListener(_onTab);
      _tabs = tabs;
      _tabs?.addListener(_onTab);
    }
    _scheduleNotify();
  }

  @override
  void activate() {
    super.activate();
    _isActive = true;
  }

  @override
  void deactivate() {
    _isActive = false;
    super.deactivate();
  }

  @override
  void dispose() {
    _tabs?.removeListener(_onTab);
    super.dispose();
  }

  void _onTab() {
    if (_tabs?.indexIsChanging ?? false) return;
    _scheduleNotify();
  }

  void _scheduleNotify() {
    if (_notifyScheduled) return;
    _notifyScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyScheduled = false;
      _notifyIfVisible();
    });
  }

  void _notifyIfVisible() {
    if (!mounted || !_isActive) return;
    if (_tabs != null && _tabs!.index != widget.tabIndex) return;
    final nav = _nav;
    if (nav == null) return;
    if (nav.state.currentIndex != MainNavigationTabs.bookings) return;
    widget.onVisible();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainNavigationCubit, MainNavigationState>(
      listenWhen: (previous, current) =>
          previous.currentIndex != current.currentIndex,
      listener: (_, __) => _scheduleNotify(),
      child: widget.child,
    );
  }
}
