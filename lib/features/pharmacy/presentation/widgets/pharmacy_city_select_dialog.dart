import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/functional/functional_export.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/app_button_widget.dart';
import '../../domain/entities/pharmacy_city_entity.dart';

/// Pharmacy city picker: pin, dropdown, Confirm City.
///
/// When [loadCities] is provided, the dialog loads (and can retry) itself.
Future<PharmacyCityEntity?> showPharmacyCitySelectDialog(
  BuildContext context, {
  List<PharmacyCityEntity>? cities,
  Future<Either<ErrorMsg, List<PharmacyCityEntity>>> Function()? loadCities,
  PharmacyCityEntity? initialSelected,
  bool barrierDismissible = true,
  String? cartSwitchHint,
}) {
  assert(
    cities != null || loadCities != null,
    'Provide cities or loadCities',
  );
  return showDialog<PharmacyCityEntity>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    builder: (dialogContext) {
      return PopScope(
        // Required picker: system back closes dialog with null so the
        // caller can exit pharmacy (not dismiss into an empty hub).
        canPop: barrierDismissible,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop || barrierDismissible) return;
          if (dialogContext.mounted) {
            Navigator.of(dialogContext).pop();
          }
        },
        child: PharmacyCitySelectDialog(
          initialCities: cities ?? const [],
          loadCities: loadCities,
          initialSelected: initialSelected,
          showCloseButton: barrierDismissible,
          cartSwitchHint: cartSwitchHint,
        ),
      );
    },
  );
}

class PharmacyCitySelectDialog extends StatefulWidget {
  const PharmacyCitySelectDialog({
    super.key,
    this.initialCities = const [],
    this.loadCities,
    this.initialSelected,
    this.showCloseButton = true,
    this.cartSwitchHint,
  });

  final List<PharmacyCityEntity> initialCities;
  final Future<Either<ErrorMsg, List<PharmacyCityEntity>>> Function()?
      loadCities;
  final PharmacyCityEntity? initialSelected;
  final bool showCloseButton;
  final String? cartSwitchHint;

  @override
  State<PharmacyCitySelectDialog> createState() =>
      _PharmacyCitySelectDialogState();
}

class _PharmacyCitySelectDialogState extends State<PharmacyCitySelectDialog> {
  PharmacyCityEntity? _selected;
  List<PharmacyCityEntity> _cities = const [];
  bool _loading = false;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialSelected;
    _cities = widget.initialCities;
    if (widget.loadCities != null && _cities.isEmpty) {
      _reload();
    }
  }

  Future<void> _reload() async {
    final loader = widget.loadCities;
    if (loader == null) return;
    setState(() {
      _loading = true;
      _loadError = null;
    });
    final result = await loader();
    if (!mounted) return;
    result.fold(
      (error) {
        setState(() {
          _loading = false;
          _loadError = error;
          _cities = const [];
        });
      },
      (cities) {
        setState(() {
          _loading = false;
          _loadError = null;
          _cities = cities;
          if (_selected != null &&
              !_cities.any((c) => c.id == _selected!.id)) {
            _selected = null;
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final hint = widget.cartSwitchHint?.trim();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.clrWhite,
          borderRadius: BorderRadius.circular(16.r),
        ),
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: AppColors.clr0FAA9A,
                  size: 22.r,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    l10n.pharmacySelectCityTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.clr060,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                if (widget.showCloseButton)
                  InkWell(
                    onTap: () => context.pop(),
                    borderRadius: BorderRadius.circular(4.r),
                    child: Padding(
                      padding: EdgeInsets.all(2.r),
                      child: Icon(
                        Icons.close,
                        size: 20.r,
                        color: AppColors.clr5D758F,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16.h),
            if (_loading)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 28.h),
                child: Center(
                  child: SizedBox(
                    width: 24.r,
                    height: 24.r,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.clr0FAA9A,
                    ),
                  ),
                ),
              )
            else if ((_loadError ?? '').isNotEmpty && _cities.isEmpty) ...[
              Text(
                _loadError!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.clr5D758F,
                  fontSize: 13.sp,
                ),
              ),
              if (widget.loadCities != null) ...[
                SizedBox(height: 14.h),
                AppButtonWidget(
                  title: l10n.commonRetry,
                  onTap: _reload,
                ),
              ],
            ] else ...[
              InputDecorator(
                decoration: InputDecoration(
                  hintText: _selected == null
                      ? l10n.pharmacySelectCityHint
                      : null,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(color: AppColors.clrD6DCE2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(color: AppColors.clrD6DCE2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(color: AppColors.clr0FAA9A),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _selected != null &&
                            _cities.any((c) => c.id == _selected!.id)
                        ? _selected!.id
                        : null,
                    isExpanded: true,
                    hint: Text(
                      l10n.pharmacySelectCityHint,
                      style: TextStyle(
                        color: AppColors.clr5D758F,
                        fontSize: 14.sp,
                      ),
                    ),
                    items: _cities
                        .map(
                          (city) => DropdownMenuItem<int>(
                            value: city.id,
                            child: Text(
                              city.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.clr060,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        )
                        .toList(growable: false),
                    onChanged: (id) {
                      if (id == null) return;
                      setState(() {
                        _selected = _cities.firstWhere((c) => c.id == id);
                      });
                    },
                  ),
                ),
              ),
              if (hint != null && hint.isNotEmpty) ...[
                SizedBox(height: 12.h),
                Text(
                  hint,
                  style: TextStyle(
                    color: AppColors.clr5D758F,
                    fontSize: 12.sp,
                    height: 1.35,
                  ),
                ),
              ],
              SizedBox(height: 18.h),
              AppButtonWidget(
                title: l10n.pharmacyConfirmCityCta,
                onTap: _selected == null
                    ? null
                    : () => context.pop(_selected),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
