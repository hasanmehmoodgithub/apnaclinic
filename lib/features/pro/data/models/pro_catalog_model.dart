import 'pro_allowed_actions_model.dart';
import 'pro_benefit_model.dart';
import 'pro_details_model.dart';
import 'pro_membership_model.dart';
import 'pro_plan_model.dart';
import 'pro_price_option_model.dart';

class ProCatalogModel {
  const ProCatalogModel({
    required this.title,
    required this.tagline,
    required this.logoUrl,
    required this.bannerUrl,
    required this.ctaLabel,
    required this.benefitsTitle,
    required this.basicColumnLabel,
    required this.proColumnLabel,
    required this.planSectionTitle,
    required this.benefits,
    required this.plans,
    required this.membership,
    required this.allowedActions,
  });

  final String title;
  final String tagline;
  final String? logoUrl;
  final String? bannerUrl;
  final String ctaLabel;
  final String benefitsTitle;
  final String basicColumnLabel;
  final String proColumnLabel;
  final String planSectionTitle;
  final List<ProBenefitModel> benefits;
  final List<ProPlanModel> plans;
  final ProMembershipModel membership;
  final ProAllowedActionsModel allowedActions;

  factory ProCatalogModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final root = data is Map<String, dynamic>
        ? data
        : (data is Map ? Map<String, dynamic>.from(data) : json);

    final isDetailsShape = root.containsKey('isActive') ||
        root.containsKey('priceOptions') ||
        root.containsKey('subtitle');
    if (isDetailsShape) {
      return _fromDetails(ProDetailsModel.fromJson(root));
    }

    final planCode = _nullableText(root['planCode'] ?? root['plan_code']);
    final benefitsRaw = root['benefits'];
    final plansRaw = root['plans'];
    final membershipRaw = root['membership'];
    final actionsRaw = root['allowedActions'] ?? root['allowed_actions'];
    final ctaRaw = (root['ctaLabel'] ?? root['cta_label'] ?? '').toString().trim();

    return ProCatalogModel(
      title: (root['title'] ?? '').toString(),
      tagline: (root['subtitle'] ?? root['tagline'] ?? '').toString(),
      logoUrl: _nullableUrl(root['logoUrl'] ?? root['logo_url']),
      bannerUrl: _nullableUrl(root['bannerUrl'] ?? root['banner_url']),
      ctaLabel: ctaRaw.isNotEmpty ? ctaRaw : 'Subscribe to Pro',
      benefitsTitle:
          (root['benefitsTitle'] ?? root['benefits_title'] ?? 'Benefits')
              .toString(),
      basicColumnLabel:
          (root['basicColumnLabel'] ?? root['basic_column_label'] ?? 'Basic')
              .toString(),
      proColumnLabel:
          (root['proColumnLabel'] ?? root['pro_column_label'] ?? 'Pro')
              .toString(),
      planSectionTitle: (root['planSectionTitle'] ??
              root['plan_section_title'] ??
              'Select a plan')
          .toString(),
      benefits: benefitsRaw is List
          ? benefitsRaw
              .whereType<Map>()
              .map((e) => ProBenefitModel.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
      plans: plansRaw is List
          ? plansRaw
              .whereType<Map>()
              .map(
                (e) => ProPlanModel.fromJson(
                  _planJson(Map<String, dynamic>.from(e), currentPlanCode: planCode),
                ),
              )
              .toList()
          : const [],
      membership: membershipRaw is Map
          ? ProMembershipModel.fromJson(Map<String, dynamic>.from(membershipRaw))
          : const ProMembershipModel(isPro: false, status: 'none'),
      allowedActions: actionsRaw is Map
          ? ProAllowedActionsModel.fromJson(Map<String, dynamic>.from(actionsRaw))
          : const ProAllowedActionsModel(
              canSubscribe: true,
              canUnsubscribe: false,
              canResubscribe: false,
              canChangePlan: false,
              canAbandon: false,
            ),
    );
  }

  static ProCatalogModel _fromDetails(ProDetailsModel details) {
    final statusRaw = details.status;
    final status = statusRaw ?? (details.isActive ? 'active' : 'none');
    final normalized = status.toLowerCase();
    return ProCatalogModel(
      title: details.title,
      tagline: details.subtitle,
      logoUrl: null,
      bannerUrl: details.bannerUrl,
      ctaLabel: details.isActive ? 'Manage plan' : 'Subscribe to Pro',
      benefitsTitle: 'Benefits',
      basicColumnLabel: 'Basic',
      proColumnLabel: 'Pro',
      planSectionTitle: 'Select a plan',
      benefits: details.benefits,
      plans: details.priceOptions
          .map((option) => _planFromPriceOption(option, details.planCode))
          .toList(),
      membership: ProMembershipModel(
        isPro: details.isActive,
        status: status,
        planId: details.planCode,
        planName: details.planName,
        expiresAt: details.renewsOn,
        autoRenew: details.isActive &&
            details.renewsOn != null &&
            normalized != 'cancelled',
      ),
      allowedActions: ProAllowedActionsModel(
        canSubscribe: !details.isActive,
        canUnsubscribe: details.isActive,
        canResubscribe: false,
        canChangePlan: false,
        canAbandon: false,
      ),
    );
  }

  static ProPlanModel _planFromPriceOption(
    ProPriceOptionModel option,
    String? currentPlanCode,
  ) {
    final currency = option.currency.isEmpty ? 'PKR' : option.currency;
    final symbol = currency.toUpperCase() == 'PKR' ? 'Rs.' : currency;
    return ProPlanModel(
      planId: option.code,
      price: double.tryParse(option.amount) ?? 0,
      currency: currency,
      currencySymbol: symbol,
      durationValue: option.durationDays,
      durationUnit: 'days',
      priceDisplay: _priceDisplay(symbol, option.amount),
      durationDisplay: option.durationLabel.trim().isNotEmpty
          ? option.durationLabel
          : option.title,
      isRecommended: false,
      isCurrent: currentPlanCode != null &&
          currentPlanCode.isNotEmpty &&
          option.code == currentPlanCode,
    );
  }

  /// Accepts legacy plan objects and `priceOptions` items (`code`, `amount`, …).
  static Map<String, dynamic> _planJson(
    Map<String, dynamic> json, {
    required String? currentPlanCode,
  }) {
    if (!json.containsKey('code') && !json.containsKey('amount')) return json;

    final code = (json['code'] ?? '').toString();
    final currency = (json['currency'] ?? 'PKR').toString();
    final amount = json['amount'];
    final durationLabel =
        (json['durationLabel'] ?? json['duration_label'] ?? json['title'] ?? '')
            .toString();
    return {
      'planId': code,
      'price': amount,
      'currency': currency,
      'currencySymbol': currency.toUpperCase() == 'PKR' ? 'Rs.' : currency,
      'durationValue': json['durationDays'] ?? json['duration_days'],
      'durationUnit': 'days',
      'priceDisplay': _priceDisplay(currency, amount),
      'durationDisplay': durationLabel,
      'isCurrent': currentPlanCode != null &&
          currentPlanCode.isNotEmpty &&
          code == currentPlanCode,
    };
  }

  static String _priceDisplay(String currency, Object? amount) {
    final symbol = currency.toUpperCase() == 'PKR' ? 'Rs.' : currency;
    final parsed = amount is num
        ? amount.toDouble()
        : double.tryParse(amount?.toString() ?? '');
    if (parsed == null) return symbol;
    final text = parsed == parsed.roundToDouble()
        ? parsed.toInt().toString()
        : parsed.toStringAsFixed(2);
    return '$symbol $text';
  }

  static String? _nullableText(Object? value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static String? _nullableUrl(Object? value) {
    if (value == null) return null;
    final text = value.toString().trim();
    if (text.isEmpty) return null;
    if (!text.startsWith('http://') && !text.startsWith('https://')) {
      return null;
    }
    return text;
  }
}
