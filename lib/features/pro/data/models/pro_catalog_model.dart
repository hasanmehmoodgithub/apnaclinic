import 'pro_allowed_actions_model.dart';
import 'pro_benefit_model.dart';
import 'pro_membership_model.dart';
import 'pro_plan_model.dart';

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

    final benefitsRaw = root['benefits'];
    final plansRaw = root['plans'];
    final membershipRaw = root['membership'];
    final actionsRaw = root['allowedActions'] ?? root['allowed_actions'];

    return ProCatalogModel(
      title: (root['title'] ?? '').toString(),
      tagline: (root['tagline'] ?? '').toString(),
      logoUrl: _nullableUrl(root['logoUrl'] ?? root['logo_url']),
      bannerUrl: _nullableUrl(root['bannerUrl'] ?? root['banner_url']),
      ctaLabel: (root['ctaLabel'] ?? root['cta_label'] ?? '').toString(),
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
              .map((e) => ProPlanModel.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
      membership: ProMembershipModel.fromJson(
        membershipRaw is Map
            ? Map<String, dynamic>.from(membershipRaw)
            : null,
      ),
      allowedActions: ProAllowedActionsModel.fromJson(
        actionsRaw is Map ? Map<String, dynamic>.from(actionsRaw) : null,
      ),
    );
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
