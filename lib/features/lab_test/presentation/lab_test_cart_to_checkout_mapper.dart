import '../domain/entities/lab_test_cart_item.dart';
import 'lab_test_route_args.dart';

/// Maps first cart line to checkout args (single-item checkout flow).
LabTestCheckoutArgs labTestCartItemToCheckoutArgs(LabTestCartItem item) {
  return LabTestCheckoutArgs(
    city: item.city,
    testTitle: item.testTitle,
    labDisplayName: item.labDisplayName,
    labLogoUrl: item.labLogoUrl,
    partnerLogoUrl: item.partnerLogoUrl,
    sampleType: item.sampleType,
    requirementLabel: item.requirementLabel,
    discountedFee: item.discountedFee,
    originalFee: item.originalFee,
    discountPercent: item.discountPercent,
    discountAmount: item.discountAmount,
    discountCode: item.discountCode,
    totalAmount: item.totalAmount,
    bookingMethodIsHomeSample: item.bookingMethodIsHomeSample,
    requirementLines: item.requirementLines,
  );
}
