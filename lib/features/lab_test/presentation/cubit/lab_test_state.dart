import 'package:equatable/equatable.dart';

import '../../../../core/enums/state_status.dart';
import '../../domain/entities/lab_test_item_entity.dart';
import '../../domain/entities/lab_test_partner_entity.dart';
import '../../domain/entities/lab_test_pricing_entity.dart';
import '../../domain/entities/lab_test_vendor_entity.dart';

class LabTestState extends Equatable {
  const LabTestState({
    this.catalogLoadingStateStatus = StateStatus.idle,
    this.labsLoadingStateStatus = StateStatus.idle,
    this.cities = const [],
    this.items = const [],
    this.filteredItems = const [],
    this.requirementLines = const [],
    this.partners = const [],
    this.vendors = const [],
    this.labs = const [],
    this.pricing,
    this.searchQuery = '',
    this.selectedCity,
    this.selectedLab,
    this.errorMessage,
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.isLoadingMore = false,
  });

  final StateStatus catalogLoadingStateStatus;
  final StateStatus labsLoadingStateStatus;
  final List<String> cities;
  final List<LabTestItemEntity> items;
  final List<LabTestItemEntity> filteredItems;
  final List<String> requirementLines;
  final List<LabTestPartnerEntity> partners;
  final List<LabTestVendorEntity> vendors;
  final List<LabTestVendorEntity> labs;
  final LabTestPricingEntity? pricing;
  final String searchQuery;
  final String? selectedCity;
  final LabTestVendorEntity? selectedLab;
  final String? errorMessage;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool isLoadingMore;

  bool get hasMoreItems => currentPage < totalPages;

  LabTestState copyWith({
    StateStatus? catalogLoadingStateStatus,
    StateStatus? labsLoadingStateStatus,
    List<String>? cities,
    List<LabTestItemEntity>? items,
    List<LabTestItemEntity>? filteredItems,
    List<String>? requirementLines,
    List<LabTestPartnerEntity>? partners,
    List<LabTestVendorEntity>? vendors,
    List<LabTestVendorEntity>? labs,
    LabTestPricingEntity? pricing,
    String? searchQuery,
    String? selectedCity,
    LabTestVendorEntity? selectedLab,
    String? errorMessage,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    bool? isLoadingMore,
    bool clearSelectedCity = false,
    bool clearSelectedLab = false,
    bool clearErrorMessage = false,
  }) {
    return LabTestState(
      catalogLoadingStateStatus:
          catalogLoadingStateStatus ?? this.catalogLoadingStateStatus,
      labsLoadingStateStatus:
          labsLoadingStateStatus ?? this.labsLoadingStateStatus,
      cities: cities ?? this.cities,
      items: items ?? this.items,
      filteredItems: filteredItems ?? this.filteredItems,
      requirementLines: requirementLines ?? this.requirementLines,
      partners: partners ?? this.partners,
      vendors: vendors ?? this.vendors,
      labs: labs ?? this.labs,
      pricing: pricing ?? this.pricing,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCity: clearSelectedCity
          ? null
          : (selectedCity ?? this.selectedCity),
      selectedLab: clearSelectedLab ? null : (selectedLab ?? this.selectedLab),
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    catalogLoadingStateStatus,
    labsLoadingStateStatus,
    cities,
    items,
    filteredItems,
    requirementLines,
    partners,
    vendors,
    labs,
    pricing,
    searchQuery,
    selectedCity,
    selectedLab,
    errorMessage,
    currentPage,
    totalPages,
    totalItems,
    isLoadingMore,
  ];
}
