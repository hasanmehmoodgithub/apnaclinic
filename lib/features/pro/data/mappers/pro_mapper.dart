import '../../domain/entities/pro_allowed_actions_entity.dart';
import '../../domain/entities/pro_benefit_entity.dart';
import '../../domain/entities/pro_catalog_entity.dart';
import '../../domain/entities/pro_membership_entity.dart';
import '../../domain/entities/pro_plan_entity.dart';
import '../models/pro_allowed_actions_model.dart';
import '../models/pro_benefit_model.dart';
import '../models/pro_catalog_model.dart';
import '../models/pro_membership_model.dart';
import '../models/pro_plan_model.dart';

class ProMapper {
  ProMapper._();

  static ProCatalogEntity toEntity(ProCatalogModel model) {
    return ProCatalogEntity(
      title: model.title,
      tagline: model.tagline,
      logoUrl: model.logoUrl,
      bannerUrl: model.bannerUrl,
      ctaLabel: model.ctaLabel,
      benefitsTitle: model.benefitsTitle,
      basicColumnLabel: model.basicColumnLabel,
      proColumnLabel: model.proColumnLabel,
      planSectionTitle: model.planSectionTitle,
      benefits: model.benefits.map(_benefitToEntity).toList(),
      plans: model.plans.map(_planToEntity).toList(),
      membership: _membershipToEntity(model.membership),
      allowedActions: _actionsToEntity(model.allowedActions),
    );
  }

  static ProBenefitEntity _benefitToEntity(ProBenefitModel model) {
    return ProBenefitEntity(
      key: model.key,
      title: model.title,
      basicValue: model.basicValue,
      proValue: model.proValue,
      highlightPro: model.highlightPro,
    );
  }

  static ProPlanEntity _planToEntity(ProPlanModel model) {
    return ProPlanEntity(
      planId: model.planId,
      price: model.price,
      currency: model.currency,
      currencySymbol: model.currencySymbol,
      durationValue: model.durationValue,
      durationUnit: model.durationUnit,
      priceDisplay: model.priceDisplay,
      durationDisplay: model.durationDisplay,
      isRecommended: model.isRecommended,
      isCurrent: model.isCurrent,
    );
  }

  static ProMembershipEntity _membershipToEntity(ProMembershipModel model) {
    return ProMembershipEntity(
      isPro: model.isPro,
      status: model.status,
      planId: model.planId,
      planName: model.planName,
      startedAt: model.startedAt,
      expiresAt: model.expiresAt,
      autoRenew: model.autoRenew,
    );
  }

  static ProAllowedActionsEntity _actionsToEntity(
    ProAllowedActionsModel model,
  ) {
    return ProAllowedActionsEntity(
      canSubscribe: model.canSubscribe,
      canUnsubscribe: model.canUnsubscribe,
      canResubscribe: model.canResubscribe,
      canChangePlan: model.canChangePlan,
      canAbandon: model.canAbandon,
    );
  }
}
