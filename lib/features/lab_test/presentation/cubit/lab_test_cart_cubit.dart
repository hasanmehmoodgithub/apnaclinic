import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../domain/entities/lab_test_cart_item.dart';
import '../../domain/repositories/lab_test_cart_repository.dart';
import '../lab_test_cart_to_checkout_mapper.dart';
import '../lab_test_route_args.dart';
import 'lab_test_cart_state.dart';

/// Shared cart list for all lab-test screens (listing / booking / cart).
/// Registered as a lazy singleton so badge counts stay in sync app-wide.
class LabTestCartCubit extends Cubit<LabTestCartState> {
  LabTestCartCubit(this._repository) : super(const LabTestCartState());

  final LabTestCartRepository _repository;

  int get count => state.items.length;

  Future<void> load() async {
    final items = await _repository.readCart();
    emit(state.copyWith(items: items));
  }

  /// Updates in-memory state after another layer already wrote prefs.
  void replaceItems(List<LabTestCartItem> items) {
    emit(state.copyWith(items: List<LabTestCartItem>.from(items)));
  }

  Future<void> removeAt(int index) async {
    if (index < 0 || index >= state.items.length) return;
    final next = List<LabTestCartItem>.from(state.items)..removeAt(index);
    await _repository.writeCart(next);
    emit(state.copyWith(items: next));
  }

  Future<void> clear() async {
    await _repository.writeCart(const <LabTestCartItem>[]);
    emit(state.copyWith(items: const <LabTestCartItem>[]));
  }

  /// Clears the persisted lab cart after Pro subscribe or unsubscribe.
  static Future<void> clearAfterProMembershipChange() {
    return sl<LabTestCartCubit>().clear();
  }

  /// Cart maps to checkout (all test ids booked together); null when empty.
  LabTestCheckoutArgs? checkoutArgsForCart() {
    if (state.items.isEmpty) return null;
    return labTestCartToCheckoutArgs(state.items);
  }
}
