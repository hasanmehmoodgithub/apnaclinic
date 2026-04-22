import '../../domain/entities/lab_test_catalog_entity.dart';
import '../../domain/entities/lab_test_item_entity.dart';
import '../../domain/entities/lab_test_partner_entity.dart';
import '../../domain/entities/lab_test_pricing_entity.dart';
import '../../domain/entities/lab_test_vendor_entity.dart';
import '../models/lab_test_catalog_model.dart';

class LabTestCatalogMapper {
  static LabTestCatalogEntity toEntity(LabTestCatalogResponseModel model) {
    return LabTestCatalogEntity(
      cities: model.cities,
      items: model.items.map(_toItemEntity).toList(growable: false),
      requirementLines: model.requirementLines,
      partners: model.partners.map(_toPartnerEntity).toList(growable: false),
      vendors: model.vendors.map(_toVendorEntity).toList(growable: false),
      pricing: _toPricingEntity(model.pricing),
    );
  }

  static LabTestItemEntity _toItemEntity(LabTestItemModel model) {
    return LabTestItemEntity(
      id: model.id,
      title: model.title,
      sampleType: model.sampleType,
      labsSummary: model.labsSummary,
      requirement: model.requirement,
      discountedFee: model.discountedFee,
      originalFee: model.originalFee,
    );
  }

  static LabTestPartnerEntity _toPartnerEntity(LabTestPartnerModel model) {
    return LabTestPartnerEntity(
      id: model.id,
      name: model.name,
      logoUrl: model.logoUrl,
    );
  }

  static LabTestVendorEntity _toVendorEntity(LabTestVendorModel model) {
    return LabTestVendorEntity(
      id: model.id,
      name: model.name,
      logoUrl: model.logoUrl,
      markUrl: model.markUrl,
    );
  }

  static LabTestPricingEntity _toPricingEntity(LabTestPricingModel model) {
    return LabTestPricingEntity(
      discountedFee: model.discountedFee,
      originalFee: model.originalFee,
      discountPercent: model.discountPercent,
      discountAmount: model.discountAmount,
      discountCode: model.discountCode,
      totalAmount: model.totalAmount,
    );
  }
}
