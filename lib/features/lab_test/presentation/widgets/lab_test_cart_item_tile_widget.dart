import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';
import '../../domain/entities/lab_test_cart_item.dart';
import '../../domain/utils/lab_test_media_url_resolver.dart';
import 'lab_test_figma_image.dart';
import 'lab_test_info_pill_widget.dart';

/// One test row: lab logo, title, fulfilled-by, sample/requirement.
///
/// Shared by the cart (with remove) and checkout (read-only) screens.
class LabTestCartItemTileWidget extends StatelessWidget {
  const LabTestCartItemTileWidget({
    super.key,
    required this.testTitle,
    required this.labLogoUrl,
    required this.partnerName,
    required this.partnerLogoUrl,
    required this.sampleType,
    this.requirementLabel = '',
    this.onRemove,
  });

  /// Tile for a persisted cart line; pass [onRemove] to show the trash icon.
  LabTestCartItemTileWidget.fromCartItem({
    Key? key,
    required LabTestCartItem item,
    VoidCallback? onRemove,
  }) : this(
         key: key,
         testTitle: item.testTitle,
         labLogoUrl: item.labLogoUrl,
         partnerName: item.displayPartnerName,
         partnerLogoUrl: item.partnerLogoUrl,
         sampleType: item.sampleType,
         requirementLabel: item.requirementLabel ?? '',
         onRemove: onRemove,
       );

  final String testTitle;
  final String labLogoUrl;
  final String partnerName;
  final String partnerLogoUrl;
  final String sampleType;
  final String requirementLabel;

  /// Null hides the remove action (checkout).
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final requirement = requirementLabel.trim();
    final partnerLogo = LabTestMediaUrlResolver.resolvePartnerLogo(
      partnerName: partnerName,
      raw: partnerLogoUrl,
    );
    final showPartner = partnerName.isNotEmpty || partnerLogo.isNotEmpty;
    final radius = 14.r;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.clrWhite,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.clrEDEDED),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 68.w,
                  height: 68.w,
                  decoration: BoxDecoration(
                    color: AppColors.clrF4F4F4,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  alignment: Alignment.center,
                  child: LabTestFigmaImage(
                    url: labLogoUrl,
                    width: 48.w,
                    height: 48.w,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              testTitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: AppColors.clr061E40,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                height: 1.0,
                              ),
                            ),
                          ),
                          if (onRemove != null) ...[
                            SizedBox(width: 4.w),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: onRemove,
                                borderRadius: BorderRadius.circular(16.r),
                                child: SvgPicture.asset(
                                  Assets.labTestDeleteTrash,
                                  width: 26.r,
                                  height: 26.r,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.clr061E40,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (showPartner) ...[
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            if (partnerLogo.isNotEmpty) ...[
                              Container(
                                width: 22.w,
                                height: 22.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.clrWhite,
                                  border: Border.all(
                                    color: AppColors.clrD6DCE2,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: LabTestFigmaImage(
                                  url: partnerLogo,
                                  width: 14.w,
                                  height: 14.w,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(width: 6.w),
                            ],
                            if (partnerName.isNotEmpty)
                              Expanded(
                                child: Text.rich(
                                  _fulfilledBySpans(
                                    l10n.labTestCartFulfilledBy(partnerName),
                                    partnerName,
                                    theme,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Divider(height: 1, thickness: 1, color: AppColors.clrE4E4E4),
            SizedBox(height: 10.h),
            Wrap(
              spacing: 14.w,
              runSpacing: 8.h,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.labTestSampleTypeLabel,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.clr303D4F,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    LabTestInfoPillWidget(value: sampleType),
                  ],
                ),
                if (requirement.isNotEmpty)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.labTestRequirementLabel,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.clr303D4F,
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      LabTestInfoPillWidget(
                        value: requirement,
                        highlight: true,
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

TextSpan _fulfilledBySpans(
  String fullText,
  String partnerName,
  ThemeData theme,
) {
  final base =
      theme.textTheme.bodySmall?.copyWith(
        color: AppColors.clr667B99,
        fontWeight: FontWeight.w400,
        fontSize: 12.sp,
        height: 1.2,
      ) ??
      const TextStyle();
  final bold = base.copyWith(fontWeight: FontWeight.w700);
  final index = fullText.indexOf(partnerName);
  if (index < 0) {
    return TextSpan(text: fullText, style: base);
  }
  return TextSpan(
    style: base,
    children: [
      TextSpan(text: fullText.substring(0, index)),
      TextSpan(text: partnerName, style: bold),
      TextSpan(text: fullText.substring(index + partnerName.length)),
    ],
  );
}
