import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/lab_test_cart_item.dart';
import '../../domain/repositories/lab_test_cart_repository.dart';
import '../lab_test_cart_to_checkout_mapper.dart';
import '../lab_test_route_args.dart';
import 'lab_test_cart_state.dart';

/// Cart list backed by [LabTestCartRepository] (same storage as booking flow).
class LabTestCartCubit extends Cubit<LabTestCartState> {
  LabTestCartCubit(this._repository) : super(const LabTestCartState());

  final LabTestCartRepository _repository;

  Future<void> load() async {
    final items = await _repository.readCart();
    emit(state.copyWith(items: items));
  }

  Future<void> removeAt(int index) async {
    if (index < 0 || index >= state.items.length) return;
    final next = List<LabTestCartItem>.from(state.items)..removeAt(index);
    await _repository.writeCart(next);
    emit(state.copyWith(items: next));
  }

  /// First line maps to checkout; null when cart is empty.
  LabTestCheckoutArgs? checkoutArgsForFirstItem() {
    if (state.items.isEmpty) return null;
    return labTestCartItemToCheckoutArgs(state.items.first);
  }
}
