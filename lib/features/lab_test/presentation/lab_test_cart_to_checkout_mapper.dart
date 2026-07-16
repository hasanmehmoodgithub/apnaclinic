import '../domain/entities/lab_test_cart_item.dart';
import 'lab_test_route_args.dart';

/// Builds checkout args from the cart: first line drives display + partner/lab,
/// and every line contributes its `testId` so multiple tests book together.
LabTestCheckoutArgs labTestCartToCheckoutArgs(List<LabTestCartItem> items) {
  final first = items.first;
  final testIds = items
      .map((e) => e.testId)
      .where((id) => id > 0)
      .toSet()
      .toList(growable: false);

  return LabTestCheckoutArgs(
    city: first.city,
    testTitle: first.testTitle,
    labDisplayName: first.labDisplayName,
    labLogoUrl: first.labLogoUrl,
    partnerLogoUrl: first.partnerLogoUrl,
    sampleType: first.sampleType,
    requirementLabel: first.requirementLabel,
    discountedFee: first.discountedFee,
    originalFee: first.originalFee,
    discountPercent: first.discountPercent,
    discountAmount: first.discountAmount,
    discountCode: first.discountCode,
    totalAmount: first.totalAmount,
    bookingMethodIsHomeSample: first.bookingMethodIsHomeSample,
    requirementLines: first.requirementLines,
    testIds: testIds,
    partnerId: first.partnerId,
    labId: first.labId,
  );
}
