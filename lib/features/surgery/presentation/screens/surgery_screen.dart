import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../cubit/surgery_cubit.dart';
import '../cubit/surgery_state.dart';
import '../widgets/city_bottom_sheet.dart';
import 'surgery_booking_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../cubit/surgery_cubit.dart';
import '../cubit/surgery_state.dart';
import '../widgets/city_bottom_sheet.dart';
import 'surgery_booking_screen.dart';

class SurgeryScreen extends StatelessWidget {
  const SurgeryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<SurgeryCubit, SurgeryState>(
      builder: (context, state) {
        return AppScaffoldGradient(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 18.h),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Color(0xFF061E40),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Procedures & Surgeries',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: const Color(0xFF061E40),
                          fontWeight: FontWeight.w700,
                          fontSize: 20.sp,
                          height: 1.2,
                        ),
                      ),
                    ),
                    SizedBox(width: 40.w),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(42.r),
                    ),
                  ),
                  child: _buildBody(context, state),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, SurgeryState state) {
    if (state.loadingStateStatus == StateStatus.loading) {
      return _SurgeryShimmerView();
    }

    if (state.loadingStateStatus == StateStatus.error) {
      return Center(
        child: Text(
          state.errorMessage ?? AppStrings.genericErrorMessage,
          textAlign: TextAlign.center,
        ),
      );
    }

    if (state.loadingStateStatus == StateStatus.empty) {
      return const Center(
        child: Text(
          'No surgery procedures available right now.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return _SurgeryContentView(state: state);
  }
}

class _SurgeryContentView extends StatefulWidget {
  const _SurgeryContentView({required this.state});

  final SurgeryState state;

  @override
  State<_SurgeryContentView> createState() => _SurgeryContentViewState();
}

class _SurgeryContentViewState extends State<_SurgeryContentView> {
  static const Map<String, String> _procedureInfo = {
    'acl':
    'Anterior cruciate ligament (ACL) is in the middle of the knee. It prevents the shin bone from sliding out in front of the thigh bone. Posterior cruciate ligament (PCL) works with the ACL. It prevents the shin bone from sliding backward under the femur.',
    'cataract-eye':
    'Cataract surgery removes the cloudy lens and improves vision.',
    'c-section': 'C-section is a surgical procedure to deliver a baby.',
    'fistula': 'Fistula surgery treats abnormal connections between organs.',
    'lasik-eye': 'Uses a laser to fix vision issues like nearsightedness.',
    'liposuction':
    'Liposuction removes excess fat deposits from selected areas.',
    'cataract-surgery': 'Cataract surgery replaces the cloudy eye lens.',
    'stent-procedure': 'Stent procedure opens blocked blood vessels.',
    'gallbladder-removal': 'Gallbladder removal treats stones or inflammation.',
    'breast-surgery':
    'Breast surgery includes therapeutic and corrective procedures.',
  };

  // Holds the overlay entry for the currently-open tooltip (if any).
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
    final cubit = context.read<SurgeryCubit>();
    final procedures = cubit.filteredProcedures;
    final state = widget.state;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(24.w, 22.h, 24.w, 12.h),
            children: [
              _LocationRow(
                city: state.selectedCity,
                onChangeTap: () => _showCityBottomSheet(context, state),
              ),
              SizedBox(height: 22.h),
              Text(
                'Select for Surgery',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF061E40),
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 12.h),
              _SearchField(
                query: state.searchQuery,
                onChanged: cubit.updateSearchQuery,
              ),
              SizedBox(height: 14.h),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: procedures.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8.h,
                  crossAxisSpacing: 8.w,
                  childAspectRatio: 189.4 / 81.7,
                ),
                itemBuilder: (context, index) {
                  final item = procedures[index];
                  return _ProcedureTile(
                    name: item.name,
                    index: index,
                    onTap: () => _openSurgeryBooking(context, item.name, state),
                    onInfoTap: (tileContext) => _showProcedureInfo(
                      tileContext,
                      item.id,
                      item.name,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showCityBottomSheet(BuildContext context, SurgeryState state) {
    return showCityPickerSheet(context);
  }

  void _openSurgeryBooking(
      BuildContext context,
      String procedureName,
      SurgeryState state,
      ) {
    final surgeryCubit = context.read<SurgeryCubit>();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: surgeryCubit,
          child: SurgeryBookingScreen(
            procedureName: procedureName,
            city: state.selectedCity,
            cities: state.content.cities,
          ),
        ),
      ),
    );
  }

  /// Shows the tooltip positioned exactly above the tapped tile,
  /// dims the rest of the screen, and keeps the tapped tile highlighted.
  void _showProcedureInfo(
      BuildContext tileContext,
      String procedureId,
      String title,
      ) {
    // If another tooltip is open, close it first.
    _removeTooltip();

    final description =
        _procedureInfo[procedureId] ??
            'Detailed information for this procedure will be shared by our representative.';

    // Find the tile's global position & size.
    final renderBox = tileContext.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.attached) return;
    final tileOffset = renderBox.localToGlobal(Offset.zero);
    final tileSize = renderBox.size;

    final overlay = Overlay.of(tileContext, rootOverlay: true);

    _tooltipEntry = OverlayEntry(
      builder: (ctx) {
        return _ProcedureInfoTooltip(
          title: title,
          description: description,
          tileOffset: tileOffset,
          tileSize: tileSize,
          onDismiss: _removeTooltip,
        );
      },
    );

    overlay.insert(_tooltipEntry!);
  }
}

/// The full-screen overlay that:
/// - Dims the background with a tap-to-dismiss barrier
/// - Cuts out a "hole" around the tapped tile so it stays highlighted
/// - Draws the speech-bubble tooltip above that tile with a downward tail
class _ProcedureInfoTooltip extends StatelessWidget {
  const _ProcedureInfoTooltip({
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

    // Horizontal padding of the tooltip from screen edges.
    final horizontalPadding = 16.w;
    final bubbleMaxWidth = screenSize.width - (horizontalPadding * 2);

    // Align the bubble's left edge with the tapped tile (but keep within screen).
    double bubbleLeft = tileOffset.dx;
    if (bubbleLeft + bubbleMaxWidth > screenSize.width - horizontalPadding) {
      bubbleLeft = screenSize.width - horizontalPadding - bubbleMaxWidth;
    }
    if (bubbleLeft < horizontalPadding) bubbleLeft = horizontalPadding;

    // Tail pointer X position (relative to bubble's left edge),
    // pointing to the horizontal center of the tapped tile.
    final tileCenterX = tileOffset.dx + (tileSize.width / 2);
    double tailX = tileCenterX - bubbleLeft - 9.w; // center tail (18w wide)
    // Keep tail inside bubble with a small inset.
    final tailInset = 20.w;
    if (tailX < tailInset) tailX = tailInset;
    if (tailX > bubbleMaxWidth - tailInset - 18.w) {
      tailX = bubbleMaxWidth - tailInset - 18.w;
    }

    const tailHeight = 10.0;
    const gapBelowBubble = 6.0; // gap between tail tip and tile

    return Stack(
      children: [
        // 1) Dim background with a "cut-out" around the highlighted tile.
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

        // 2) The tooltip bubble positioned right above the tile.
        Positioned(
          left: bubbleLeft,
          // bottom of tooltip (including tail) sits just above the tile
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

/// The white speech-bubble card with a downward-pointing tail.
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
      // Paints the downward tail underneath the card.
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
                fontSize: 14.5.sp,
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

/// Paints the downward-pointing tail below the bubble.
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

    // Triangle: left-base, tip (pointing down), right-base.
    final path = Path()
      ..moveTo(tailOffsetFromLeft, bubbleBottom)
      ..lineTo(tailOffsetFromLeft + (tailWidth / 2), size.height) // tip down
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

/// Paints a dim overlay across the whole screen but leaves a transparent
/// rounded-rect "hole" around the highlighted tile.
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

class _LocationRow extends StatelessWidget {
  const _LocationRow({required this.city, required this.onChangeTap});

  final String city;
  final VoidCallback onChangeTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.32.r),
        border: Border.all(color: const Color(0xFF9BA6A7), width: 0.3),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: const Color(0xFF667B99),
                    fontSize: 10.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  city,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: const Color(0xFF110844),
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onChangeTap,
            borderRadius: BorderRadius.circular(12.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
              child: Row(
                children: [
                  Text(
                    'Change',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF667B99),
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 14.r,
                    color: const Color(0xFF667B99),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatefulWidget {
  const _SearchField({required this.query, required this.onChanged});

  final String query;
  final ValueChanged<String> onChanged;

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.query);
  }

  @override
  void didUpdateWidget(covariant _SearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query != _controller.text) {
      _controller.value = _controller.value.copyWith(
        text: widget.query,
        selection: TextSelection.collapsed(offset: widget.query.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.5.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF9BA6A7), width: 0.3),
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Search name..',
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF9E9E9E),
            fontWeight: FontWeight.w500,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 11.w,
            vertical: 15.h,
          ),
          suffixIcon: Icon(
            Icons.search_rounded,
            size: 18.r,
            color: const Color(0xFF5D758F),
          ),
        ),
      ),
    );
  }
}

class _ProcedureTile extends StatelessWidget {
  const _ProcedureTile({
    required this.name,
    required this.index,
    required this.onTap,
    required this.onInfoTap,
  });

  final String name;
  final int index;
  final VoidCallback onTap;

  /// Callback receives the tile's own context so the tooltip
  /// can be positioned precisely above it.
  final ValueChanged<BuildContext> onInfoTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.7.r),
        child: Builder(
          builder: (tileContext) {
            return Container(
              height: 81.689.h,
              decoration: BoxDecoration(
                color: _cardColor(index),
                borderRadius: BorderRadius.circular(10.7.r),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IgnorePointer(
                      child: Opacity(
                        opacity: 0.9,
                        child: SizedBox(
                          child: index.isEven
                              ? const _CardPatternD2()
                              : const _CardPatternD1(),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16.w,
                    top: 33.h,
                    right: 76.w,
                    child: Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: const Color(0xFF061E40),
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        height: 1,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 12.w,
                    top: 27.h,
                    child: Container(
                      width: 26.7.r,
                      height: 26.7.r,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        size: 20.r,
                        color: const Color(0xFFD3D5D8),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 5.w,
                    top: 4.8.h,
                    child: InkWell(
                      onTap: () => onInfoTap(tileContext),
                      borderRadius: BorderRadius.circular(16.r),
                      child: Container(
                        width: 16.r,
                        height: 16.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF7A7A7A),
                            width: 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '!',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                            color: const Color(0xFF7A7A7A),
                            fontWeight: FontWeight.w700,
                            fontSize: 10.sp,
                            height: 1,
                          ),
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
    );
  }

  Color _cardColor(int idx) {
    const colors = <Color>[
      Color(0xFFE9F9FC),
      Color(0xFFFCE9F0),
      Color(0xFFF5E8FF),
      Color(0xFFECE9FC),
      Color(0xFFE6FEF3),
      Color(0xFFF9F9F9),
    ];
    return colors[idx % colors.length];
  }
}

class _CardPatternD1 extends StatelessWidget {
  const _CardPatternD1();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('assets/icons/d1.svg', fit: BoxFit.contain);
  }
}

class _CardPatternD2 extends StatelessWidget {
  const _CardPatternD2();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('assets/icons/d2.svg', fit: BoxFit.contain);
  }
}

class _SurgeryShimmerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(24.w, 22.h, 24.w, 12.h),
      children: [
        AppShimmerCard(height: 62.h, borderRadius: 6.r),
        SizedBox(height: 22.h),
        AppShimmerText(height: 14.h, width: 120.w),
        SizedBox(height: 10.h),
        AppShimmerCard(height: 44.h, borderRadius: 10.r),
        SizedBox(height: 16.h),
        AppShimmerGrid(
          itemCount: 10,
          crossAxisCount: 2,
          mainAxisSpacing: 8.h,
          crossAxisSpacing: 8.w,
          childAspectRatio: 2.32,
          borderRadius: 10.7.r,
        ),
      ],
    );
  }
}


