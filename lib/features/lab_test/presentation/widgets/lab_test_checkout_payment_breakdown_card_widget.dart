import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';
import '../../../pro/presentation/widgets/pro_service_offer_slot.dart';
import '../../../promo_code/domain/entities/promo_code_service.dart';
import '../../../promo_code/presentation/cubit/promo_code_cubit.dart';
import '../../../promo_code/presentation/cubit/promo_code_state.dart';
import '../../../promo_code/presentation/widgets/promo_code_field_widget.dart';
import '../../domain/utils/lab_test_price_formatter.dart';
import '../lab_test_route_args.dart';
import 'lab_test_figma_image.dart';

/// Payment details plus the Pro upsell. Active members see Discount (%) and
/// [Assets.proProBadge] on the discount row.
class LabTestCheckoutPaymentSection extends StatefulWidget {
  const LabTestCheckoutPaymentSection({super.key, required this.args});

  final LabTestCheckoutArgs args;

  @override
  State<LabTestCheckoutPaymentSection> createState() =>
      _LabTestCheckoutPaymentSectionState();
}

class _LabTestCheckoutPaymentSectionState
    extends State<LabTestCheckoutPaymentSection> {
  final _offerKey = GlobalKey<ProServiceOfferSlotState>();
  bool? _isPro;

  void _onProChanged(bool isPro) {
    if (!mounted || _isPro == isPro) return;
    setState(() => _isPro = isPro);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProServiceOfferSlot(
          key: _offerKey,
          service: ProServiceOfferKind.lab,
          upsellOnly: true,
          onProChanged: _onProChanged,
        ),
        LabTestCheckoutPaymentBreakdownCardWidget(
          args: widget.args,
          isPro: _isPro == true,
          onProTap: () => _offerKey.currentState?.openSheet(),
        ),
      ],
    );
  }
}

/// Payment Details card: fee, promo, discount, discount code strip and total bar.
class LabTestCheckoutPaymentBreakdownCardWidget extends StatelessWidget {
  const LabTestCheckoutPaymentBreakdownCardWidget({
    super.key,
    required this.args,
    this.isPro = false,
    this.onProTap,
  });

  final LabTestCheckoutArgs args;
  final bool isPro;
  final VoidCallback? onProTap;

  int get _discountedAmount {
    final fromTotal = LabTestPriceFormatter.parseRsAmount(args.totalAmount);
    if (fromTotal > 0) return fromTotal;
    return LabTestPriceFormatter.parseRsAmount(args.discountedFee);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final catalogCode = args.discountCode.trim();

    return BlocBuilder<PromoCodeCubit, PromoCodeState>(
      builder: (context, promo) {
        final hasPromo = promo.isApplied;
        final discountAmount =
            LabTestPriceFormatter.parseRsAmount(args.discountAmount);
        final originalAmount =
            LabTestPriceFormatter.parseRsAmount(args.originalFee);
        final discountPercent = args.discountPercent > 0
            ? args.discountPercent
            : (originalAmount > 0
                ? ((discountAmount * 100) / originalAmount).round()
                : 0);
        final showProDiscount =
            isPro && (discountAmount > 0 || discountPercent > 0);
        final feeAmount = showProDiscount && originalAmount > 0
            ? originalAmount
            : _discountedAmount;
        final totalText = LabTestPriceFormatter.formatRs(
          promo.payableTotal(_discountedAmount),
        );

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
                      LabTestPriceFormatter.formatRs(feeAmount),
                    ),
                    if (showProDiscount) ...[
                      SizedBox(height: 12.h),
                      _proDiscountRow(
                        context,
                        label: l10n.bookingsDiscountLabel('$discountPercent'),
                        amount: LabTestPriceFormatter.formatRs(discountAmount),
                        onTap: onProTap,
                      ),
                    ],
                    SizedBox(height: 12.h),
                    PromoCodeFieldWidget(
                      status: promo.status,
                      displayCode: promo.displayCode,
                      enabled: !promo.isValidating,
                      onChanged: context.read<PromoCodeCubit>().onInputChanged,
                      onSubmitted: (code) =>
                          context.read<PromoCodeCubit>().validate(
                                service: PromoCodeService.lab,
                                amount: _discountedAmount,
                                code: code,
                              ),
                      onCleared: context.read<PromoCodeCubit>().clear,
                    ),
                    if (promo.isInvalid || promo.needsApply) ...[
                      SizedBox(height: 8.h),
                      Text(
                        promo.needsApply
                            ? l10n.promoCodeApplyRequired
                            : l10n.promoCodeInvalid,
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

  Widget _proDiscountRow(
    BuildContext context, {
    required String label,
    required String amount,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.bodyMedium?.copyWith(
      color: AppColors.clr667B99,
      fontSize: 14.sp,
    );
    return InkWell(
      onTap: onTap,
      child: Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  label,
                  style: labelStyle,
                ),
              ),
              SizedBox(width: 6.w),
              SvgPicture.asset(
                Assets.proProBadge,
                height: 18.h,
                fit: BoxFit.contain,
              ),
            ],
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
      ),
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
