class UnsubscribeProParams {
  const UnsubscribeProParams({required this.planCode});

  /// Same product code as subscribe.
  static const String productPlanCode = 'PRO';

  final String planCode;

  Map<String, dynamic> toJson() => {
        'planCode': planCode,
      };
}
