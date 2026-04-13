import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/services/responsive_config_service.dart';
import '../../domain/entities/consultation_category_entity.dart';
import '../constants/consultation_ui_config.dart';
import '../cubit/consultation_cubit.dart';
import '../cubit/consultation_state.dart';
import '../widgets/consultation_category_card.dart';

class DoctorConsultationScreen extends StatelessWidget {
  const DoctorConsultationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = sl<ResponsiveConfigService>();
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
                  responsive.w(context, 22),
                  responsive.h(context, 8),
                  responsive.w(context, 22),
                  responsive.h(context, 8),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.of(context).pop(),
                      child: SizedBox(
                        width: responsive.w(context, 24),
                        height: responsive.h(context, 24),
                        child: Center(
                          child: SvgPicture.asset(
                            ConsultationUiConfig.backArrowAsset,
                            width: responsive.w(context, 24),
                            height: responsive.h(context, 24),
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
                          fontSize: responsive.sp(context, 20),
                        ),
                      ),
                    ),
                    SizedBox(width: responsive.w(context, 24)),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<ConsultationCubit, ConsultationState>(
                  builder: (context, state) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: responsive.h(context, 2)),
                          SizedBox(
                            height: responsive.h(context, 178),
                            child: Center(
                              child: SizedBox(
                                width: responsive.w(context, 240),
                                height: responsive.h(context, 178),
                                child: Stack(
                                  alignment: Alignment.topCenter,
                                  children: [
                                    Positioned(
                                      top: responsive.h(context, 2),
                                      child: SvgPicture.asset(
                                        ConsultationUiConfig.heroVectorAsset,
                                        width: responsive.w(context, 238),
                                        height: responsive.h(context, 172),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      child: Image.asset(
                                        ConsultationUiConfig.heroDoctorAsset,
                                        width: responsive.w(context, 188),
                                        height: responsive.h(context, 177),
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
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(42),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                24,
                                22,
                                24,
                                22,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _AssistantCard(textTheme: textTheme),
                                  SizedBox(height: responsive.h(context, 21)),
                                  Text(
                                    ConsultationUiConfig.chooseCategories,
                                    style: textTheme.titleMedium?.copyWith(
                                      fontSize: responsive.sp(context, 16),
                                      fontWeight: FontWeight.w500,
                                      color: ConsultationUiConfig.primaryText,
                                    ),
                                  ),
                                  SizedBox(height: responsive.h(context, 14)),
                                  _SearchField(
                                    onChanged: context
                                        .read<ConsultationCubit>()
                                        .onSearchChanged,
                                  ),
                                  SizedBox(height: responsive.h(context, 14)),
                                  if (state.isLoading)
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 40,
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
                                      padding: const EdgeInsets.only(top: 12),
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
    final responsive = sl<ResponsiveConfigService>();
    final textTheme = Theme.of(context).textTheme;
    final screenSize = MediaQuery.sizeOf(context);
    final tooltipWidth = responsive.w(context, 330);
    final tooltipHeight = responsive.h(context, 118);
    final left = (position.dx - tooltipWidth + responsive.w(context, 10)).clamp(
      responsive.w(context, 16),
      screenSize.width - tooltipWidth - 16,
    );
    final top = (position.dy - tooltipHeight - responsive.h(context, 10)).clamp(
      responsive.h(context, 70),
      screenSize.height - 140,
    );
    final arrowLeft = (position.dx - left - responsive.w(context, 8)).clamp(
      responsive.w(context, 10),
      tooltipWidth - responsive.w(context, 26),
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
                        padding: EdgeInsets.all(responsive.r(context, 18)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            responsive.r(context, 8),
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
                            fontSize: responsive.sp(context, 14),
                            height: 1.3,
                            color: ConsultationUiConfig.tertiaryText,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: arrowLeft),
                        child: CustomPaint(
                          size: Size(
                            responsive.w(context, 16),
                            responsive.h(context, 8),
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
    final responsive = sl<ResponsiveConfigService>();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        responsive.w(context, 13),
        responsive.h(context, 11),
        responsive.w(context, 13),
        responsive.h(context, 11),
      ),
      decoration: BoxDecoration(
        color: ConsultationUiConfig.cardBackground,
        borderRadius: BorderRadius.circular(responsive.r(context, 10.7)),
        border: Border.all(color: ConsultationUiConfig.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: responsive.w(context, 16),
                height: responsive.h(context, 16),
                child: SvgPicture.asset(
                  ConsultationUiConfig.assistantIconAsset,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: responsive.w(context, 8)),
              Text(
                ConsultationUiConfig.assistantTitle,
                style: textTheme.titleMedium?.copyWith(
                  fontSize: responsive.sp(context, 16),
                  fontWeight: FontWeight.w500,
                  color: ConsultationUiConfig.primaryText,
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.h(context, 9)),
          Text(
            ConsultationUiConfig.assistantDescription,
            style: textTheme.bodyMedium?.copyWith(
              fontSize: responsive.sp(context, 13),
              height: 1.2,
              fontWeight: FontWeight.w500,
              color: ConsultationUiConfig.secondaryText,
            ),
          ),
          SizedBox(height: responsive.h(context, 18)),
          SizedBox(
            height: responsive.h(context, 32),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ConsultationUiConfig.ctaColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(responsive.r(context, 6)),
                ),
              ),
              onPressed: () {},
              child: Text(
                ConsultationUiConfig.startNow,
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: responsive.sp(context, 14),
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
    final responsive = sl<ResponsiveConfigService>();
    return SizedBox(
      height: responsive.h(context, 44.565),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: ConsultationUiConfig.searchHint,
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF9E9E9E),
            fontWeight: FontWeight.w500,
            fontSize: responsive.sp(context, 14),
          ),
          suffixIcon: Padding(
            padding: EdgeInsets.all(responsive.r(context, 12)),
            child: SvgPicture.asset(
              ConsultationUiConfig.searchIconAsset,
              width: responsive.w(context, 18.6),
              height: responsive.h(context, 18.6),
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: responsive.w(context, 11),
            vertical: responsive.h(context, 12),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF9BA6A7), width: 0.3),
            borderRadius: BorderRadius.circular(responsive.r(context, 12)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF9BA6A7), width: 0.3),
            borderRadius: BorderRadius.circular(responsive.r(context, 12)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ConsultationUiConfig.ctaColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(responsive.r(context, 12)),
          ),
        ),
      ),
    );
  }
}
