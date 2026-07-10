import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../components/shimmer/app_shimmer.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/entities/consultation_category_entity.dart';
import '../constants/consultation_ui_config.dart';
import '../cubit/consultation_cubit.dart';
import '../cubit/consultation_state.dart';
import '../doctor_consultation_results_args.dart';
import '../widgets/consultation_category_card.dart';
import '../widgets/consultation_screen_header_widget.dart';

class DoctorConsultationScreen extends StatefulWidget {
  const DoctorConsultationScreen({super.key});

  @override
  State<DoctorConsultationScreen> createState() =>
      _DoctorConsultationScreenState();
}

class _DoctorConsultationScreenState extends State<DoctorConsultationScreen> {
  OverlayEntry? _tooltipEntry;

  @override
  void dispose() {
    _removeTooltip();
    super.dispose();
  }

  void _removeTooltip() {
    _tooltipEntry?.remove();
    _tooltipEntry = null;
  }

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
          bottom: false,
          child: Column(
            children: [
              ConsultationScreenHeaderWidget(
                title: ConsultationUiConfig.screenTitle,
                onBackTap: () => context.pop(),
              ),

              // ───── Hero illustration (fixed) ─────
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

              // ───── White sheet: fixed assistant + scroll from categories ─────
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(42.r),
                    ),
                  ),
                  child: BlocBuilder<ConsultationCubit, ConsultationState>(
                    builder: (context, state) {
                      return Padding(
                        padding: EdgeInsets.fromLTRB(24.w, 22.h, 24.w, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            state.isLoading
                                ? AppShimmerCard(
                                    height: 150.h,
                                    borderRadius: 10.7.r,
                                  )
                                : _AssistantCard(textTheme: textTheme),
                            SizedBox(height: 21.h),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 22.h),
                                child: CustomScrollView(
                                  slivers: _buildScrollableSlivers(
                                    context,
                                    state,
                                    textTheme,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildScrollableSlivers(
    BuildContext context,
    ConsultationState state,
    TextTheme textTheme,
  ) {
    final slivers = <Widget>[
      SliverToBoxAdapter(
        child: state.isLoading
            ? AppShimmerText(width: 180.w, height: 18.h, borderRadius: 6.r)
            : Text(
                ConsultationUiConfig.chooseCategories,
                style: textTheme.titleMedium?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: ConsultationUiConfig.primaryText,
                ),
              ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 14.h)),
      SliverToBoxAdapter(
        child: state.isLoading
            ? AppShimmerCard(height: 44.565.h, borderRadius: 12.r)
            : _SearchField(
                onChanged: context.read<ConsultationCubit>().onSearchChanged,
              ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 14.h)),
    ];

    if (state.isLoading) {
      slivers.add(
        SliverToBoxAdapter(
          child: AppShimmerGrid(
            itemCount: 8,
            crossAxisCount: 2,
            mainAxisSpacing: 8.h,
            crossAxisSpacing: 6.w,
            childAspectRatio: 189.4 / 81.7,
            borderRadius: 10.7.r,
          ),
        ),
      );
      return slivers;
    }

    if ((state.errorMessage ?? '').isNotEmpty) {
      slivers.add(
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Text(
              state.errorMessage!,
              style: textTheme.bodySmall?.copyWith(color: Colors.red),
            ),
          ),
        ),
      );
      return slivers;
    }

    slivers.add(
      SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 6,
          childAspectRatio: 189.4 / 81.7,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final category = state.filteredCategories[index];
            return Builder(
              builder: (tileContext) {
                return ConsultationCategoryCard(
                  category: category,
                  index: index,
                  onTap: () => context.pushNamed(
                    AppRoutes.consultationDoctors,
                    extra: DoctorConsultationResultsArgs(
                      selectedCategory: category.title,
                      mainCategoryId: category.id,
                      categoryOptions: state.categories,
                    ),
                  ),
                  onInfoTap: (_) => ()

                      // _showProcedureInfo(tileContext, category),


                );
              },
            );
          },
          childCount: state.filteredCategories.length,
        ),
      ),
    );

    return slivers;
  }

  /// Shows the tooltip positioned exactly above the tapped tile,
  /// dims the rest of the screen, and keeps the tapped tile highlighted.
  void _showProcedureInfo(
      BuildContext tileContext,
      ConsultationCategoryEntity category,
      ) {
    _removeTooltip();

    final renderBox = tileContext.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.attached) return;
    final tileOffset = renderBox.localToGlobal(Offset.zero);
    final tileSize = renderBox.size;

    final overlay = Overlay.of(tileContext, rootOverlay: true);

    _tooltipEntry = OverlayEntry(
      builder: (ctx) {
        return _CategoryInfoTooltip(
          title: category.cardTitle,
          description: category.description,
          tileOffset: tileOffset,
          tileSize: tileSize,
          onDismiss: _removeTooltip,
        );
      },
    );

    overlay.insert(_tooltipEntry!);
  }
}

/// Full-screen overlay with dim barrier, tile cut-out, and speech-bubble tooltip.
class _CategoryInfoTooltip extends StatelessWidget {
  const _CategoryInfoTooltip({
    required this.title,
    required this.description,
    required this.tileOffset,
    required this.tileSize,
    required this.onDismiss,
  });

  final String title;
  final String description;
  final Offset tileOffset;
  final Size tileSize;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;

    final horizontalPadding = 16.w;
    final bubbleMaxWidth = screenSize.width - (horizontalPadding * 2);

    double bubbleLeft = tileOffset.dx;
    if (bubbleLeft + bubbleMaxWidth > screenSize.width - horizontalPadding) {
      bubbleLeft = screenSize.width - horizontalPadding - bubbleMaxWidth;
    }
    if (bubbleLeft < horizontalPadding) bubbleLeft = horizontalPadding;

    final tileCenterX = tileOffset.dx + (tileSize.width / 2);
    double tailX = tileCenterX - bubbleLeft - 9.w;
    final tailInset = 20.w;
    if (tailX < tailInset) tailX = tailInset;
    if (tailX > bubbleMaxWidth - tailInset - 18.w) {
      tailX = bubbleMaxWidth - tailInset - 18.w;
    }

    const tailHeight = 10.0;
    const gapBelowBubble = 6.0;

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: onDismiss,
            behavior: HitTestBehavior.opaque,
            child: CustomPaint(
              painter: _BarrierWithHolePainter(
                holeRect: Rect.fromLTWH(
                  tileOffset.dx,
                  tileOffset.dy,
                  tileSize.width,
                  tileSize.height,
                ),
                holeRadius: 10.7.r,
                barrierColor: const Color.fromRGBO(0, 0, 0, 0.35),
              ),
            ),
          ),
        ),
        Positioned(
          left: bubbleLeft,
          top: null,
          bottom:
          screenSize.height - tileOffset.dy + gapBelowBubble - tailHeight,
          width: bubbleMaxWidth,
          child: Material(
            color: Colors.transparent,
            child: _TooltipBubble(
              title: title,
              description: description,
              tailX: tailX,
              tailHeight: tailHeight,
            ),
          ),
        ),
      ],
    );
  }
}

class _TooltipBubble extends StatelessWidget {
  const _TooltipBubble({
    required this.title,
    required this.description,
    required this.tailX,
    required this.tailHeight,
  });

  final String title;
  final String description;
  final double tailX;
  final double tailHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomPaint(
      painter: _DownwardTailPainter(
        bubbleColor: Colors.white,
        tailOffsetFromLeft: tailX,
        tailWidth: 18.w,
        tailHeight: tailHeight,
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: tailHeight),
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 18.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.18),
              blurRadius: 22,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: const Color(0xFF0A2540),
                fontWeight: FontWeight.w600,
                fontSize: 17.sp,
                height: 1.2,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF7A8AA0),
                fontSize: 14.sp,
                height: 1.4,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DownwardTailPainter extends CustomPainter {
  _DownwardTailPainter({
    required this.bubbleColor,
    required this.tailOffsetFromLeft,
    required this.tailWidth,
    required this.tailHeight,
  });

  final Color bubbleColor;
  final double tailOffsetFromLeft;
  final double tailWidth;
  final double tailHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final bubbleBottom = size.height - tailHeight;

    final path = Path()
      ..moveTo(tailOffsetFromLeft, bubbleBottom)
      ..lineTo(tailOffsetFromLeft + (tailWidth / 2), size.height)
      ..lineTo(tailOffsetFromLeft + tailWidth, bubbleBottom)
      ..close();

    canvas.drawShadow(path, const Color.fromRGBO(0, 0, 0, 0.18), 4, false);

    final paint = Paint()
      ..color = bubbleColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _DownwardTailPainter oldDelegate) =>
      oldDelegate.bubbleColor != bubbleColor ||
          oldDelegate.tailOffsetFromLeft != tailOffsetFromLeft ||
          oldDelegate.tailWidth != tailWidth ||
          oldDelegate.tailHeight != tailHeight;
}

class _BarrierWithHolePainter extends CustomPainter {
  _BarrierWithHolePainter({
    required this.holeRect,
    required this.holeRadius,
    required this.barrierColor,
  });

  final Rect holeRect;
  final double holeRadius;
  final Color barrierColor;

  @override
  void paint(Canvas canvas, Size size) {
    final screenPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final holePath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(holeRect, Radius.circular(holeRadius)),
      );

    final cutOutPath = Path.combine(
      PathOperation.difference,
      screenPath,
      holePath,
    );

    final paint = Paint()..color = barrierColor;
    canvas.drawPath(cutOutPath, paint);
  }

  @override
  bool shouldRepaint(covariant _BarrierWithHolePainter oldDelegate) =>
      oldDelegate.holeRect != holeRect ||
          oldDelegate.holeRadius != holeRadius ||
          oldDelegate.barrierColor != barrierColor;
}

class _AssistantCard extends StatelessWidget {
  final TextTheme textTheme;

  const _AssistantCard({required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(13.w, 11.h, 13.w, 11.h),
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
              onPressed: () => _openAiScreening(context),
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

  void _openAiScreening(BuildContext context) {
    context.pushNamed(AppRoutes.aiScreening);
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
            padding: EdgeInsets.all(15.r),
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