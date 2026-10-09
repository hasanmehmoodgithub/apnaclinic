class SubscribeProParams {
  const SubscribeProParams({
    required this.planCode,
    required this.planPriceCode,
    required this.msisdn,
    required this.channel,
  });

  /// Product code sent on subscribe. Price option code is [planPriceCode].
  static const String productPlanCode = 'PRO';

  final String planCode;
  final String planPriceCode;
  final String msisdn;
  final String channel;

  Map<String, dynamic> toJson() => {
        'planCode': planCode,
        'planPriceCode': planPriceCode,
        'msisdn': msisdn,
        'channel': channel,
      };
}
