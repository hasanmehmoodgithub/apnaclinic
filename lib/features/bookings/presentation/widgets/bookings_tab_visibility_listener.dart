import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dashboard/presentation/constants/main_navigation_tabs.dart';
import '../../../dashboard/presentation/cubit/main_navigation_cubit.dart';
import '../../../dashboard/presentation/cubit/main_navigation_state.dart';

/// Calls [onVisible] when this inner tab becomes selected while My Bookings
/// is the bottom-nav tab. Adjacent TabBarView pages do not fetch. Switching
/// away and back (inner tab or Bookings bottom nav) notifies again so lists
/// can refresh.
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
  bool _wasVisible = false;
  bool _notifyScheduled = false;

  @override
  void initState() {
    super.initState();
    _isActive = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      _nav = context.read<MainNavigationCubit>();
    } catch (_) {
      _nav = null;
    }
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
    _scheduleNotify();
  }

  @override
  void deactivate() {
    _isActive = false;
    _wasVisible = false;
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

  bool get _isVisible {
    if (!mounted || !_isActive) return false;
    if (_tabs != null && _tabs!.index != widget.tabIndex) return false;
    final nav = _nav;
    if (nav != null && nav.state.currentIndex != MainNavigationTabs.bookings) {
      return false;
    }
    return true;
  }

  void _notifyIfVisible() {
    if (!_isVisible) {
      _wasVisible = false;
      return;
    }
    if (_wasVisible) return;
    _wasVisible = true;
    widget.onVisible();
  }

  @override
  Widget build(BuildContext context) {
    if (_nav == null) {
      return widget.child;
    }
    return BlocListener<MainNavigationCubit, MainNavigationState>(
      listenWhen: (previous, current) =>
          previous.currentIndex != current.currentIndex,
      listener: (_, _) => _scheduleNotify(),
      child: widget.child,
    );
  }
}
