/// Aggregator `service` values for promo-code validate.
enum PromoCodeService {
  consultation('CONSULTATION'),
  lab('LAB'),
  pharmacy('PHARMACY');

  const PromoCodeService(this.apiValue);

  final String apiValue;
}
