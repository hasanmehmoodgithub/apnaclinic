import 'package:equatable/equatable.dart';

class MainNavigationState extends Equatable {
  const MainNavigationState({this.currentIndex = 2});

  final int currentIndex;

  MainNavigationState copyWith({int? currentIndex}) {
    return MainNavigationState(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object?> get props => [currentIndex];
}

