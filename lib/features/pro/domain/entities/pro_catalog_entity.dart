import 'package:equatable/equatable.dart';

import 'pro_allowed_actions_entity.dart';
import 'pro_benefit_entity.dart';
import 'pro_membership_entity.dart';
import 'pro_plan_entity.dart';

class ProCatalogEntity extends Equatable {
  const ProCatalogEntity({
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
  final List<ProBenefitEntity> benefits;
  final List<ProPlanEntity> plans;
  final ProMembershipEntity membership;
  final ProAllowedActionsEntity allowedActions;

  String? get defaultSelectedPlanId {
    for (final plan in plans) {
      if (plan.isCurrent) return plan.planId;
    }
    for (final plan in plans) {
      if (plan.isRecommended) return plan.planId;
    }
    return plans.isEmpty ? null : plans.first.planId;
  }

  @override
  List<Object?> get props => [
        title,
        tagline,
        logoUrl,
        bannerUrl,
        ctaLabel,
        benefitsTitle,
        basicColumnLabel,
        proColumnLabel,
        planSectionTitle,
        benefits,
        plans,
        membership,
        allowedActions,
      ];
}
