import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../cubit/surgery_cubit.dart';
import '../cubit/surgery_state.dart';
import '../../domain/entities/surgery_procedure_entity.dart';
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
                    onTap: () => _openSurgeryBooking(context, item, state),
                    onInfoTap: (tileContext) => _showProcedureInfo(
                      tileContext,
                      item.name,
                      item.description,
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
    SurgeryProcedureEntity item,
    SurgeryState state,
  ) {
    final surgeryCubit = context.read<SurgeryCubit>();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: surgeryCubit,
          child: SurgeryBookingScreen(
            surgeryId: item.id,
            procedureName: item.name,
            city: state.selectedCity,
            cities: state.content.cities,
          ),
        ),
      ),
    );
  }

  void _showProcedureInfo(
    BuildContext tileContext,
    String title,
    String description,
  ) {
    _removeTooltip();

    final effectiveDescription = description.trim().isEmpty
        ? 'Detailed information for this procedure will be shared by our representative.'
        : description;

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
            description: effectiveDescription,
            tileOffset: tileOffset,
            tileSize: tileSize,
            onDismiss: _removeTooltip,
          ),
    );

    overlay.insert(_tooltipEntry!);
  }
}
