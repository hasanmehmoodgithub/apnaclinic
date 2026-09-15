import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';
import '../../../promo_code/domain/entities/promo_code_service.dart';
import '../../../promo_code/presentation/cubit/promo_code_cubit.dart';
import '../../../promo_code/presentation/cubit/promo_code_state.dart';
import '../../../promo_code/presentation/widgets/promo_code_field_widget.dart';
import '../../domain/utils/lab_test_price_formatter.dart';
import '../lab_test_route_args.dart';
import 'lab_test_figma_image.dart';

/// Payment Details card: fee, promo, discount, discount code strip and total bar.
class LabTestCheckoutPaymentBreakdownCardWidget extends StatelessWidget {
  const LabTestCheckoutPaymentBreakdownCardWidget({
    super.key,
    required this.args,
  });

  final LabTestCheckoutArgs args;

  int get _originalAmount =>
      LabTestPriceFormatter.parseRsAmount(args.originalFee);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final catalogDiscount =
        LabTestPriceFormatter.parseRsAmount(args.discountAmount) > 0 ||
            args.discountPercent > 0;
    final catalogCode = args.discountCode.trim();

    return BlocBuilder<PromoCodeCubit, PromoCodeState>(
      builder: (context, promo) {
        final hasPromo = promo.isApplied;
        final showCatalogDiscount = catalogDiscount && !hasPromo;
        final totalText = hasPromo
            ? LabTestPriceFormatter.formatRs(promo.result!.payableAmount)
            : args.totalAmount;

        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.clrWhite,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.clrEDEDED),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.labTestCheckoutTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.clr061E40,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _moneyRow(
                      context,
                      l10n.labTestCheckoutFeeLabel,
                      args.originalFee,
                    ),
                    SizedBox(height: 12.h),
                    PromoCodeFieldWidget(
                      status: promo.status,
                      displayCode: promo.displayCode,
                      enabled: !promo.isValidating,
                      onChanged: context.read<PromoCodeCubit>().onInputChanged,
                      onSubmitted: (code) =>
                          context.read<PromoCodeCubit>().validate(
                                service: PromoCodeService.lab,
                                amount: _originalAmount,
                                code: code,
                              ),
                      onCleared: context.read<PromoCodeCubit>().clear,
                    ),
                    if (promo.isInvalid) ...[
                      SizedBox(height: 8.h),
                      Text(
                        l10n.promoCodeInvalid,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.clrC9252C,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    if (hasPromo) ...[
                      SizedBox(height: 10.h),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.clrE4E4E4,
                      ),
                      SizedBox(height: 10.h),
                      _moneyRow(
                        context,
                        l10n.promoCodeDiscountLabel,
                        LabTestPriceFormatter.formatRs(
                          promo.result!.discountAmount,
                        ),
                      ),
                    ] else if (showCatalogDiscount) ...[
                      SizedBox(height: 10.h),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.clrE4E4E4,
                      ),
                      SizedBox(height: 10.h),
                      _moneyRow(
                        context,
                        '${l10n.labTestCheckoutDiscountLabel} (${args.discountPercent}%)',
                        args.discountAmount,
                      ),
                    ],
                    if (catalogCode.isNotEmpty) ...[
                      SizedBox(height: 12.h),
                      _DiscountCodeStrip(code: catalogCode),
                    ],
                  ],
                ),
              ),
              Container(
                color: AppColors.clrF2F2F2,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.labTestCheckoutTotalLabel,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.clr061E40,
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                      ),
                    ),
                    Text(
                      totalText,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.clr110844,
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _moneyRow(BuildContext context, String label, String amount) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.clr667B99,
            fontSize: 14.sp,
          ),
        ),
        Text(
          amount,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.clr061E40,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _DiscountCodeStrip extends StatelessWidget {
  const _DiscountCodeStrip({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
      decoration: BoxDecoration(
        color: AppColors.clrF7EFC7,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              LabTestFigmaImage(
                url: Assets.labTestDiscountIcon,
                width: 15.r,
                height: 15.r,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  l10n.labTestDiscountCodeLabel,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.clr1C232D,
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                  ),
                ),
              ),
              Text(
                code,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: AppColors.clr1C232D,
                  fontWeight: FontWeight.w700,
                  fontSize: 15.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Container(height: 1, color: AppColors.clrE1D49D),
          SizedBox(height: 8.h),
          Text(
            l10n.labTestShowCodeInstruction,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.clr1C232D,
              fontSize: 12.sp,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
