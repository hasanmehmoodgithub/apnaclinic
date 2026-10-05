import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../promo_code/domain/entities/promo_code_service.dart';
import '../../../promo_code/presentation/cubit/promo_code_cubit.dart';
import '../../../promo_code/presentation/cubit/promo_code_state.dart';
import '../../../promo_code/presentation/widgets/promo_code_field_widget.dart';
import '../../data/models/doctor_consultation_checkout_model.dart';

class DoctorConsultationCheckoutBillingSectionWidget extends StatelessWidget {
  const DoctorConsultationCheckoutBillingSectionWidget({
    super.key,
    required this.data,
  });

  final DoctorConsultationCheckoutModel data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    // Show payable (post doctor-discount) as Consultation fee.
    final discountedFee = data.total;

    return BlocBuilder<PromoCodeCubit, PromoCodeState>(
      builder: (context, promo) {
        final total = promo.payableTotal(discountedFee);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.bookingsBillingTitle,
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.clr061E40,
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              l10n.consultationVideoConsultationLabel,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.clr98A4B5,
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 12.h),
            const Divider(color: AppColors.clrD1D6DD, thickness: 1, height: 1),
            SizedBox(height: 16.h),
            _StackedAmount(
              label: l10n.consultationConsultationFeesLabel,
              amount: discountedFee,
            ),
            SizedBox(height: 14.h),
            PromoCodeFieldWidget(
              status: promo.status,
              displayCode: promo.displayCode,
              enabled: !promo.isValidating,
              onChanged: context.read<PromoCodeCubit>().onInputChanged,
              onSubmitted: (code) => context.read<PromoCodeCubit>().validate(
                    service: PromoCodeService.consultation,
                    amount: discountedFee,
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
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.clrC9252C,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            if (promo.isApplied) ...[
              SizedBox(height: 14.h),
              _StackedAmount(
                label: l10n.promoCodeDiscountLabel,
                amount: promo.result!.discountAmount,
                isNegative: true,
                isMuted: true,
              ),
            ],
            SizedBox(height: 16.h),
            const Divider(color: AppColors.clrD1D6DD, thickness: 1, height: 1),
            SizedBox(height: 16.h),
            _StackedAmount(
              label: l10n.consultationTotalChargesLabel,
              amount: total,
            ),
          ],
        );
      },
    );
  }
}

class _StackedAmount extends StatelessWidget {
  const _StackedAmount({
    required this.label,
    required this.amount,
    this.isMuted = false,
    this.isNegative = false,
  });

  final String label;
  final int amount;
  final bool isMuted;
  final bool isNegative;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final valueColor =
        isMuted ? AppColors.clr7C8797 : AppColors.clr061E40;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.clr7C8797,
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 4.h),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: isNegative ? '- Rs. ' : 'Rs. ',
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.clr667B99,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                ),
              ),
              TextSpan(
                text: '$amount',
                style: textTheme.titleMedium?.copyWith(
                  color: valueColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
