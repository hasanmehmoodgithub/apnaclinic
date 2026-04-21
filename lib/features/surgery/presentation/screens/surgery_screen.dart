import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../components/shimmer/app_shimmer.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/enums/state_status.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';
import '../cubit/surgery_cubit.dart';
import '../cubit/surgery_state.dart';
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
    'lasik-eye': 'LASIK reshapes corneal tissue to correct refractive errors.',
    'liposuction':
        'Liposuction removes excess fat deposits from selected areas.',
    'cataract-surgery': 'Cataract surgery replaces the cloudy eye lens.',
    'stent-procedure': 'Stent procedure opens blocked blood vessels.',
    'gallbladder-removal': 'Gallbladder removal treats stones or inflammation.',
    'breast-surgery':
        'Breast surgery includes therapeutic and corrective procedures.',
  };

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
                    onInfoTap: () =>
                        _showProcedureInfo(context, item.id, item.name),
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
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.r)),
      ),
      builder: (sheetContext) {
        return _CityBottomSheet(state: state);
      },
    );
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

  Future<void> _showProcedureInfo(
    BuildContext context,
    String procedureId,
    String title,
  ) async {
    final description =
        _procedureInfo[procedureId] ??
        'Detailed information for this procedure will be shared by our representative.';

    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Procedure info',
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.35),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        final theme = Theme.of(context);
        return SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(22.5.w, 132.h, 22.5.w, 0),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.fromLTRB(24.w, 18.h, 24.w, 18.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.3),
                        blurRadius: 24.2,
                        offset: Offset(0, 13),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: const Color(0xFF061E40),
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF667B99),
                          fontSize: 14.sp,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
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
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.h),
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
                SizedBox(height: 4.h),
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
  final VoidCallback onInfoTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.7.r),
        child: Container(
          height: 81.689.h,
          decoration: BoxDecoration(
            color: _cardColor(index),
            borderRadius: BorderRadius.circular(10.7.r),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  child: Opacity(
                    opacity: 0.55,
                    child: index.isEven
                        ? const _CardPatternD1()
                        : const _CardPatternD2(),
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
                  onTap: onInfoTap,
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
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
    return CustomPaint(
      painter: _LinesPatternPainter(
        color: const Color(0xFFF3F3F3),
        reverse: false,
      ),
    );
  }
}

class _CardPatternD2 extends StatelessWidget {
  const _CardPatternD2();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LinesPatternPainter(
        color: const Color(0xFFEDEDED),
        reverse: true,
      ),
    );
  }
}

class _LinesPatternPainter extends CustomPainter {
  _LinesPatternPainter({required this.color, required this.reverse});

  final Color color;
  final bool reverse;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final originX = reverse ? size.width * 0.62 : size.width * 0.42;
    final originY = -size.height * 0.20;

    for (int i = 0; i < 4; i++) {
      final path = Path();
      final w = 64.0 + (i * 20);
      final h = 22.0 + (i * 12);
      path.addArc(
        Rect.fromCenter(
          center: Offset(originX, originY + (i * 4)),
          width: w,
          height: h,
        ),
        0.35,
        2.35,
      );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _LinesPatternPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.reverse != reverse;
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

class _CityBottomSheet extends StatefulWidget {
  const _CityBottomSheet({required this.state});

  final SurgeryState state;

  @override
  State<_CityBottomSheet> createState() => _CityBottomSheetState();
}

class _CityBottomSheetState extends State<_CityBottomSheet> {
  late String selectedCity;
  String query = '';

  @override
  void initState() {
    super.initState();
    selectedCity = widget.state.selectedCity;
  }

  @override
  Widget build(BuildContext context) {
    final cities = widget.state.content.cities
        .where((city) => city.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 10.h, 24.w, 18.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFCACACA),
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Select a city',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color(0xFF061E40),
                fontWeight: FontWeight.w500,
                fontSize: 28.sp / 2,
              ),
            ),
            SizedBox(height: 14.h),
            Container(
              height: 44.7.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(color: const Color(0xFFD5D5D5), width: 0.8),
              ),
              child: TextField(
                onChanged: (value) => setState(() => query = value),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search by name',
                  hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF7F96B0),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 14.h,
                  ),
                  suffixIcon: Icon(
                    Icons.search_rounded,
                    color: const Color(0xFF7F96B0),
                    size: 18.r,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 230.h),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: cities.length,
                separatorBuilder: (_, index) =>
                    Divider(height: 1, color: const Color(0xFFDCDCDC)),
                itemBuilder: (context, index) {
                  final city = cities[index];
                  final selected = city == selectedCity;
                  return InkWell(
                    onTap: () => setState(() => selectedCity = city),
                    child: Container(
                      color: selected
                          ? const Color(0xFFF1F1F1)
                          : Colors.transparent,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 13.h,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              city,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: const Color(0xFF5D758F)),
                            ),
                          ),
                          Container(
                            width: 14.r,
                            height: 14.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF7F96B0),
                                width: 1,
                              ),
                            ),
                            child: selected
                                ? Center(
                                    child: Container(
                                      width: 6.r,
                                      height: 6.r,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF061E40),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 14.h),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  context.read<SurgeryCubit>().changeCity(selectedCity);
                  Navigator.of(context).pop();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0FAFA0),
                  minimumSize: Size.fromHeight(57.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: const Text('Proceed'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
