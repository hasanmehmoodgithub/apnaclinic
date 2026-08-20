import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/no_emoji_text_input_formatter.dart';
import '../../../../core/widgets/app_rounded_rating_widget.dart';
import '../cubit/doctor_consultation_booking_details_cubit.dart';
import '../cubit/doctor_consultation_booking_details_state.dart';
import 'doctor_consultation_booking_rating_stars_widget.dart';

class DoctorConsultationBookingFeedbackFormWidget extends StatefulWidget {
  const DoctorConsultationBookingFeedbackFormWidget({super.key});

  @override
  State<DoctorConsultationBookingFeedbackFormWidget> createState() =>
      _DoctorConsultationBookingFeedbackFormWidgetState();
}

class _DoctorConsultationBookingFeedbackFormWidgetState
    extends State<DoctorConsultationBookingFeedbackFormWidget> {
  final _reviewController = TextEditingController();
  double _rating = 0;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    FocusScope.of(context).unfocus();
    await context.read<DoctorConsultationBookingDetailsCubit>().submitFeedback(
          rating: _rating,
          review: _reviewController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final todayLabel = DateFormat('dd/MM/yyyy').format(DateTime.now());

    return BlocBuilder<DoctorConsultationBookingDetailsCubit,
        DoctorConsultationBookingDetailsState>(
      buildWhen: (prev, next) =>
          prev.isSubmittingFeedback != next.isSubmittingFeedback,
      builder: (context, state) {
        final canSubmit = _rating >= 1 && !state.isSubmittingFeedback;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.bookingsPatientsReviewTitle,
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.clr061E40,
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 10.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.bookingsYourFeedbackLabel,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.clr061E40,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  todayLabel,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.clr98A2B3,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                DoctorConsultationBookingRatingStarsWidget(
                  rating: _rating,
                  onStarTap: state.isSubmittingFeedback
                      ? null
                      : (value) => setState(() => _rating = value),
                ),
                const Spacer(),
                if (_rating >= 1)
                  AppRoundedRatingWidget(
                    rating: _rating,
                    textTheme: textTheme,
                  ),
              ],
            ),
            SizedBox(height: 10.h),
            TextField(
              controller: _reviewController,
              enabled: !state.isSubmittingFeedback,
              inputFormatters: NoEmojiTextInputFormatter.merge(
                const <TextInputFormatter>[],
                allowBasicPunctuation: true,
              ),
              maxLines: 3,
              minLines: 2,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: l10n.bookingsFeedbackHint,
                hintStyle: textTheme.bodyMedium?.copyWith(
                  color: AppColors.clr98A2B3,
                  fontSize: 14.sp,
                ),
                filled: true,
                fillColor: AppColors.clrF7F7F7,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 12.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.r),
                  borderSide: BorderSide.none,
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.r),
                  borderSide: BorderSide.none,
                ),
              ),
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.clr667085,
                fontSize: 14.sp,
                height: 1.35,
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: FilledButton(
                onPressed: canSubmit ? _onSubmit : null,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.clr1FAFA3,
                  foregroundColor: AppColors.clrWhite,
                  disabledBackgroundColor: const Color(0xFFB7D9D6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: state.isSubmittingFeedback
                    ? SizedBox(
                        width: 22.r,
                        height: 22.r,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        l10n.bookingsSubmitFeedbackCta,
                        style: textTheme.titleMedium?.copyWith(
                          color: AppColors.clrWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}
