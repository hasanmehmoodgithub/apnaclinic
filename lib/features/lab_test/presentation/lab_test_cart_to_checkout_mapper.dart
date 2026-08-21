import '../domain/entities/lab_test_cart_item.dart';
import '../domain/utils/lab_test_price_formatter.dart';
import 'lab_test_route_args.dart';

/// Builds checkout args from the cart: every line is listed on Payment Details,
/// totals are summed, and all `testId`s book together.
LabTestCheckoutArgs labTestCartToCheckoutArgs(List<LabTestCartItem> items) {
  final first = items.first;
  final testIds = items
      .map((e) => e.testId)
      .where((id) => id > 0)
      .toSet()
      .toList(growable: false);

  final lines = items
      .map(
        (e) => LabTestCheckoutLineArgs(
          testTitle: e.testTitle,
          labDisplayName: e.labDisplayName,
          labLogoUrl: e.labLogoUrl,
          partnerLogoUrl: e.partnerLogoUrl,
          sampleType: e.sampleType,
          discountedFee: e.discountedFee,
          originalFee: e.originalFee,
          bookingMethodIsHomeSample: e.bookingMethodIsHomeSample,
        ),
      )
      .toList(growable: false);

  var feeSum = 0;
  var totalSum = 0;
  var discountSum = 0;
  for (final item in items) {
    final original = LabTestPriceFormatter.parseRsAmount(item.originalFee);
    final discounted = LabTestPriceFormatter.parseRsAmount(item.discountedFee);
    final fromField = LabTestPriceFormatter.parseRsAmount(item.discountAmount);
    feeSum += original;
    totalSum += discounted;
    discountSum += fromField > 0
        ? fromField
        : (original > discounted ? original - discounted : 0);
  }

  // Prefer fee − total when both parse cleanly so the breakdown always adds up.
  if (feeSum >= totalSum && feeSum > 0) {
    discountSum = feeSum - totalSum;
  }

  final discountPercent = feeSum > 0
      ? ((discountSum * 100) / feeSum).round()
      : first.discountPercent;

  return LabTestCheckoutArgs(
    city: first.city,
    testTitle: first.testTitle,
    labDisplayName: first.labDisplayName,
    labLogoUrl: first.labLogoUrl,
    partnerLogoUrl: first.partnerLogoUrl,
    sampleType: first.sampleType,
    requirementLabel: first.requirementLabel,
    discountedFee: LabTestPriceFormatter.formatRs(totalSum),
    originalFee: LabTestPriceFormatter.formatRs(feeSum),
    discountPercent: discountPercent,
    discountAmount: LabTestPriceFormatter.formatRs(discountSum),
    discountCode: first.discountCode,
    totalAmount: LabTestPriceFormatter.formatRs(totalSum),
    bookingMethodIsHomeSample: first.bookingMethodIsHomeSample,
    requirementLines: first.requirementLines,
    testIds: testIds,
    partnerId: first.partnerId,
    labId: first.labId,
    lines: lines,
  );
}
