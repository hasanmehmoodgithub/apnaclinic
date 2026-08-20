import 'package:equatable/equatable.dart';

import 'lab_test_item_entity.dart';
import 'lab_test_partner_entity.dart';
import 'lab_test_pricing_entity.dart';
import 'lab_test_vendor_entity.dart';

class LabTestCatalogEntity extends Equatable {
  const LabTestCatalogEntity({
    required this.cities,
    required this.items,
    required this.requirementLines,
    required this.partners,
    required this.vendors,
    this.pricing,
    this.page = 1,
    this.limit = 20,
    this.total = 0,
    this.totalPages = 1,
  });

  final List<String> cities;
  final List<LabTestItemEntity> items;
  final List<String> requirementLines;
  final List<LabTestPartnerEntity> partners;
  final List<LabTestVendorEntity> vendors;
  final LabTestPricingEntity? pricing;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  bool get hasMore => page < totalPages;

  @override
  List<Object?> get props => [
    cities,
    items,
    requirementLines,
    partners,
    vendors,
    pricing,
    page,
    limit,
    total,
    totalPages,
  ];
}
