import 'package:equatable/equatable.dart';

import '../../domain/entities/lab_test_cart_item.dart';

class LabTestCartState extends Equatable {
  const LabTestCartState({this.items = const []});

  final List<LabTestCartItem> items;

  LabTestCartState copyWith({List<LabTestCartItem>? items}) {
    return LabTestCartState(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items];
}
