import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../cubit/surgery_cubit.dart';
import '../cubit/surgery_state.dart';
import '../screens/surgery_booking_screen.dart';
import 'city_bottom_sheet.dart';
import 'surgery_location_row_widget.dart';
import 'surgery_procedure_info_tooltip_widget.dart';
import 'surgery_procedure_tile_widget.dart';
import 'surgery_search_field_widget.dart';

class SurgeryContentViewWidget extends StatefulWidget {
  const SurgeryContentViewWidget({super.key, required this.state});

  final SurgeryState state;

  @override
  State<SurgeryContentViewWidget> createState() => _SurgeryContentViewWidgetState();
}

class _SurgeryContentViewWidgetState extends State<SurgeryContentViewWidget> {
  static const Map<String, String> _procedureInfo = {
    'acl':
        'Anterior cruciate ligament (ACL) is in the middle of the knee. It prevents the shin bone from sliding out in front of the thigh bone. Posterior cruciate ligament (PCL) works with the ACL. It prevents the shin bone from sliding backward under the femur.',
    'cataract-eye': 'Cataract surgery removes the cloudy lens and improves vision.',
    'c-section': 'C-section is a surgical procedure to deliver a baby.',
    'fistula': 'Fistula surgery treats abnormal connections between organs.',
    'lasik-eye': 'Uses a laser to fix vision issues like nearsightedness.',
    'liposuction': 'Liposuction removes excess fat deposits from selected areas.',
    'cataract-surgery': 'Cataract surgery replaces the cloudy eye lens.',
    'stent-procedure': 'Stent procedure opens blocked blood vessels.',
    'gallbladder-removal': 'Gallbladder removal treats stones or inflammation.',
    'breast-surgery': 'Breast surgery includes therapeutic and corrective procedures.',
  };

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
              SurgeryLocationRowWidget(
                city: state.selectedCity,
                onChangeTap: () => showCityPickerSheet(context),
              ),
              SizedBox(height: 22.h),
              Text(
                AppLocalizations.of(context)!.surgerySelectForSurgery,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.clr060,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 12.h),
              SurgerySearchFieldWidget(
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
                  return SurgeryProcedureTileWidget(
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

  void _showProcedureInfo(
    BuildContext tileContext,
    String procedureId,
    String title,
  ) {
    _removeTooltip();

    final description =
        _procedureInfo[procedureId] ??
        'Detailed information for this procedure will be shared by our representative.';

    final renderBox = tileContext.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.attached) {
      return;
    }

    final tileOffset = renderBox.localToGlobal(Offset.zero);
    final tileSize = renderBox.size;
    final overlay = Overlay.of(tileContext, rootOverlay: true);

    _tooltipEntry = OverlayEntry(
      builder:
          (_) => SurgeryProcedureInfoTooltipWidget(
            title: title,
            description: description,
            tileOffset: tileOffset,
            tileSize: tileSize,
            onDismiss: _removeTooltip,
          ),
    );

    overlay.insert(_tooltipEntry!);
  }
}
