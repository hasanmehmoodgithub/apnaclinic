class ProAllowedActionsModel {
  const ProAllowedActionsModel({
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

  factory ProAllowedActionsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ProAllowedActionsModel(
        canSubscribe: true,
        canUnsubscribe: false,
        canResubscribe: false,
        canChangePlan: false,
        canAbandon: false,
      );
    }
    return ProAllowedActionsModel(
      canSubscribe: json['canSubscribe'] == true ||
          json['can_subscribe'] == true,
      canUnsubscribe: json['canUnsubscribe'] == true ||
          json['can_unsubscribe'] == true,
      canResubscribe: json['canResubscribe'] == true ||
          json['can_resubscribe'] == true,
      canChangePlan: json['canChangePlan'] == true ||
          json['can_change_plan'] == true,
      canAbandon:
          json['canAbandon'] == true || json['can_abandon'] == true,
    );
  }
}
