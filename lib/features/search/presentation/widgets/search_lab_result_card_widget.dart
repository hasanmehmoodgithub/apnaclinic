import 'package:flutter/material.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../lab_test/domain/entities/lab_test_item_entity.dart';
import '../../../lab_test/domain/utils/lab_test_price_formatter.dart';
import '../../../lab_test/presentation/widgets/lab_test_browse_item_tile_widget.dart';
import '../../domain/entities/search_entity.dart';

/// Adapts a search lab hit onto the same catalog tile used in lab test browse
/// (grey title header + sample/price pills).
class SearchLabResultCardWidget extends StatelessWidget {
  const SearchLabResultCardWidget({
    super.key,
    required this.item,
    this.onTap,
  });

  final SearchResultEntity item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sampleType = (item.sampleType ?? '').trim();
    final discounted = (item.price ?? item.fee)?.trim();
    final original = item.oldFee?.trim();

    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: LabTestBrowseItemTileWidget(
        item: LabTestItemEntity(
          id: item.id,
          title: item.title,
          sampleType: sampleType.isEmpty ? 'N/A' : sampleType,
          requirement: item.requirement,
          discountedFee: (discounted == null || discounted.isEmpty)
              ? null
              : discounted,
          originalFee:
              (original == null ||
                      original.isEmpty ||
                      LabTestPriceFormatter.isSameFee(original, discounted))
                  ? null
                  : original,
        ),
        onTap: onTap ?? () {},
        requirementLabel: l10n.labTestRequirementLabel,
        sampleTypeLabel: l10n.labTestSampleTypeLabel,
        feeFallbackText: l10n.labTestBrowseItemFeeFallback,
        showLabsSummary: false,
        compactText: true,
      ),
    );
  }
}
