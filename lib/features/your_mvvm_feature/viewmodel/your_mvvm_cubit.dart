import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/your_mvvm_repository.dart';
import 'your_mvvm_state.dart';

/// Cubit for managing Your MVVM Feature state (ViewModel layer)
/// Simple example: GET list and POST create
class YourMvvmCubit extends Cubit<YourMvvmState> {
  final YourMvvmRepository repository;

  YourMvvmCubit({required this.repository}) : super(const YourMvvmState()) {
    loadItems();
  }

  /// GET: Load all items
  Future<void> loadItems() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await repository.getItems();

    result.fold(
      (error) {
        emit(state.copyWith(isLoading: false, errorMessage: error));
      },
      (items) {
        emit(
          state.copyWith(
            items: items,
            isLoading: false,
            errorMessage: null,
          ),
        );
      },
    );
  }

  /// POST: Create a new item
  Future<void> createItem({
    required String title,
    required String description,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await repository.createItem(
      title: title,
      description: description,
    );

    result.fold(
      (error) {
        emit(state.copyWith(isLoading: false, errorMessage: error));
      },
      (item) {
        final updatedItems = [item, ...state.items];
        emit(
          state.copyWith(
            items: updatedItems,
            isLoading: false,
            errorMessage: null,
          ),
        );
      },
    );
  }
}
