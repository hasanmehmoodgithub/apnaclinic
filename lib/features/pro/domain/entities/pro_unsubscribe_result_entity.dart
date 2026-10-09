import 'package:equatable/equatable.dart';

class ProUnsubscribeResultEntity extends Equatable {
  const ProUnsubscribeResultEntity({
    required this.planCode,
    required this.message,
  });

  final String planCode;
  final String message;

  @override
  List<Object?> get props => [planCode, message];
}
