import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/main_navigation_tabs.dart';
import 'main_navigation_state.dart';

class MainNavigationCubit extends Cubit<MainNavigationState> {
  MainNavigationCubit({int initialIndex = MainNavigationTabs.home})
    : super(MainNavigationState(currentIndex: initialIndex));

  void setIndex(int index) {
    if (state.currentIndex == index) return;
    emit(state.copyWith(currentIndex: index));
  }
}
