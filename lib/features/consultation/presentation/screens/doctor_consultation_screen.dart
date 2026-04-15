import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../domain/entities/consultation_category_entity.dart';
import '../constants/consultation_ui_config.dart';
import '../cubit/consultation_cubit.dart';
import '../cubit/consultation_state.dart';
import '../widgets/consultation_category_card.dart';

class DoctorConsultationScreen extends StatelessWidget {
  const DoctorConsultationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ConsultationUiConfig.pageTopGradient,
              ConsultationUiConfig.pageBottomGradient,
            ],
            stops: [0.09, 0.36],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  22.w,
                  8.h,
                  22.w,
                  8.h,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.of(context).pop(),
                      child: SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: Center(
                          child: SvgPicture.asset(
                            ConsultationUiConfig.backArrowAsset,
                            width: 24.w,
                            height: 24.h,
                            fit: BoxFit.contain,
                            colorFilter: const ColorFilter.mode(
                              ConsultationUiConfig.primaryText,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        ConsultationUiConfig.screenTitle,
                        textAlign: TextAlign.center,
                        style: textTheme.titleLarge?.copyWith(
                          color: ConsultationUiConfig.primaryText,
                          fontWeight: FontWeight.w700,
                          fontSize: 20.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 24.w),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<ConsultationCubit, ConsultationState>(
                  builder: (context, state) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 2.h),
                          SizedBox(
                            height: 178.h,
                            child: Center(
                              child: SizedBox(
                                width: 240.w,
                                height: 178.h,
                                child: Stack(
                                  alignment: Alignment.topCenter,
                                  children: [
                                    Positioned(
                                      top: 2.h,
                                      child: SvgPicture.asset(
                                        ConsultationUiConfig.heroVectorAsset,
                                        width: 238.w,
                                        height: 172.h,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      child: Image.asset(
                                        ConsultationUiConfig.heroDoctorAsset,
                                        width: 188.w,
                                        height: 177.h,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(42.r),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                24.w,
                                22.h,
                                24.w,
                                22.h,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _AssistantCard(textTheme: textTheme),
                                  SizedBox(height: 21.h),
                                  Text(
                                    ConsultationUiConfig.chooseCategories,
                                    style: textTheme.titleMedium?.copyWith(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: ConsultationUiConfig.primaryText,
                                    ),
                                  ),
                                  SizedBox(height: 14.h),
                                  _SearchField(
                                    onChanged: context
                                        .read<ConsultationCubit>()
                                        .onSearchChanged,
                                  ),
                                  SizedBox(height: 14.h),
                                  if (state.isLoading)
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 40.h,
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  else
                                    GridView.builder(
                                      itemCount:
                                          state.filteredCategories.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 8,
                                            crossAxisSpacing: 6,
                                            childAspectRatio: 189.4 / 81.7,
                                          ),
                                      itemBuilder: (context, index) {
                                        final category =
                                            state.filteredCategories[index];
                                        return ConsultationCategoryCard(
                                          category: category,
                                          onInfoTap: (position) =>
                                              _showTooltipMenu(
                                                context,
                                                category,
                                                position,
                                              ),
                                        );
                                      },
                                    ),
                                  if ((state.errorMessage ?? '').isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.only(top: 12.h),
                                      child: Text(
                                        state.errorMessage!,
                                        style: textTheme.bodySmall?.copyWith(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showTooltipMenu(
    BuildContext context,
    ConsultationCategoryEntity category,
    Offset position,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final screenSize = MediaQuery.sizeOf(context);
    final tooltipWidth = 330.w;
    final tooltipHeight = 118.h;
    final left = (position.dx - tooltipWidth + 10.w).clamp(
      16.w,
      screenSize.width - tooltipWidth - 16,
    );
    final top = (position.dy - tooltipHeight - 10.h).clamp(
      70.h,
      screenSize.height - 140,
    );
    final arrowLeft = (position.dx - left - 8.w).clamp(
      10.w,
      tooltipWidth - 26.w,
    );

    return showGeneralDialog<void>(
      context: context,
      barrierLabel: 'tooltip',
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 110),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => Navigator.of(dialogContext).pop(),
                ),
              ),
              Positioned(
                left: left,
                top: top,
                child: SizedBox(
                  width: tooltipWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: tooltipWidth,
                        padding: EdgeInsets.all(18.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            8.r,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x4D000000),
                              blurRadius: 24.2,
                              offset: Offset(0, 13),
                            ),
                          ],
                        ),
                        child: Text(
                          category.description,
                          style: textTheme.bodyMedium?.copyWith(
                            fontSize: 14.sp,
                            height: 1.3,
                            color: ConsultationUiConfig.tertiaryText,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: arrowLeft),
                        child: CustomPaint(
                          size: Size(
                            16.w,
                            8.h,
                          ),
                          painter: _TooltipArrowPainter(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TooltipArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AssistantCard extends StatelessWidget {
  final TextTheme textTheme;

  const _AssistantCard({required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        13.w,
        11.h,
        13.w,
        11.h,
      ),
      decoration: BoxDecoration(
        color: ConsultationUiConfig.cardBackground,
        borderRadius: BorderRadius.circular(10.7.r),
        border: Border.all(color: ConsultationUiConfig.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 16.w,
                height: 16.h,
                child: SvgPicture.asset(
                  ConsultationUiConfig.assistantIconAsset,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                ConsultationUiConfig.assistantTitle,
                style: textTheme.titleMedium?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: ConsultationUiConfig.primaryText,
                ),
              ),
            ],
          ),
          SizedBox(height: 9.h),
          Text(
            ConsultationUiConfig.assistantDescription,
            style: textTheme.bodyMedium?.copyWith(
              fontSize: 13.sp,
              height: 1.2,
              fontWeight: FontWeight.w500,
              color: ConsultationUiConfig.secondaryText,
            ),
          ),
          SizedBox(height: 18.h),
          SizedBox(
            height: 32.h,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ConsultationUiConfig.ctaColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
              onPressed: () {},
              child: Text(
                ConsultationUiConfig.startNow,
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const _SearchField({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.565.h,
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: ConsultationUiConfig.searchHint,
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF9E9E9E),
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
          suffixIcon: Padding(
            padding: EdgeInsets.all(12.r),
            child: SvgPicture.asset(
              ConsultationUiConfig.searchIconAsset,
              width: 18.6.w,
              height: 18.6.h,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 11.w,
            vertical: 12.h,
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF9BA6A7), width: 0.3),
            borderRadius: BorderRadius.circular(12.r),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF9BA6A7), width: 0.3),
            borderRadius: BorderRadius.circular(12.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ConsultationUiConfig.ctaColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }
}
