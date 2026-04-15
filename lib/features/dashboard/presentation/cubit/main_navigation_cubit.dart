import 'package:flutter_bloc/flutter_bloc.dart';

import 'main_navigation_state.dart';

class MainNavigationCubit extends Cubit<MainNavigationState> {
  MainNavigationCubit({int initialIndex = 2})
    : super(MainNavigationState(currentIndex: initialIndex));

  void setIndex(int index) {
    if (state.currentIndex == index) return;
    emit(state.copyWith(currentIndex: index));
  }
}

