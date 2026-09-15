import 'package:equatable/equatable.dart';

class ProAllowedActionsEntity extends Equatable {
  const ProAllowedActionsEntity({
    required this.canSubscribe,
    required this.canUnsubscribe,
    required this.canResubscribe,
    required this.canChangePlan,
    required this.canAbandon,
  });

  final bool canSubscribe;
  final bool canUnsubscribe;
  final bool canResubscribe;
  final bool canChangePlan;
  final bool canAbandon;

  @override
  List<Object?> get props => [
        canSubscribe,
        canUnsubscribe,
        canResubscribe,
        canChangePlan,
        canAbandon,
      ];
}
