import 'package:flutter/material.dart';

import '../lab_test_route_args.dart';
import 'lab_test_figma_image.dart';

/// Vendor mark + logo stack or single logo.
class LabTestBookingVendorLogoWidget extends StatelessWidget {
  const LabTestBookingVendorLogoWidget({
    super.key,
    required this.vendor,
    required this.size,
  });

  final LabTestBookingVendorOption vendor;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (vendor.markUrl != null) {
      return SizedBox(
        width: size,
        height: size * 0.55,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: 0,
              child: LabTestFigmaImage(
                url: vendor.logoUrl,
                width: size * 0.95,
                height: size * 0.2,
              ),
            ),
            LabTestFigmaImage(
              url: vendor.markUrl!,
              width: size * 0.22,
              height: size * 0.29,
            ),
          ],
        ),
      );
    }
    return LabTestFigmaImage(
      url: vendor.logoUrl,
      width: size * 0.85,
      height: size * 0.80,
      fit: BoxFit.contain,
    );
  }
}
