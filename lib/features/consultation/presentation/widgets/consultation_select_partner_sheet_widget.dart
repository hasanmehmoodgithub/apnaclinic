import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../constants/consultation_partner_filter_defaults.dart';
import '../constants/consultation_ui_config.dart';
import 'consultation_partner_logo_widget.dart';

class ConsultationSelectPartnerSheetWidget extends StatefulWidget {
  const ConsultationSelectPartnerSheetWidget({
    super.key,
    this.selectedPartnerId,
  });

  final String? selectedPartnerId;

  @override
  State<ConsultationSelectPartnerSheetWidget> createState() =>
      _ConsultationSelectPartnerSheetWidgetState();
}

class _ConsultationSelectPartnerSheetWidgetState
    extends State<ConsultationSelectPartnerSheetWidget> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ConsultationPartnerFilterOption> get _filteredPartners {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) {
      return ConsultationPartnerFilterDefaults.partners;
    }
    return ConsultationPartnerFilterDefaults.partners
        .where((partner) => partner.name.toLowerCase().contains(query))
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final partners = _filteredPartners;

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.72,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 38.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD3D9),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              l10n.consultationSelectPartnerTitle,
              style: textTheme.titleMedium?.copyWith(
                color: const Color(0xFF061E40),
                fontWeight: FontWeight.w700,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 48.h,
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _query = value),
                decoration: InputDecoration(
                  hintText: l10n.consultationSearchPartner,
                  hintStyle: textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF9E9E9E),
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(14.r),
                    child: SvgPicture.asset(
                      ConsultationUiConfig.searchIconAsset,
                      width: 18.w,
                      height: 18.h,
                    ),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Color(0xFFD9DEE4), width: 1),
                    borderRadius: BorderRadius.circular(11.r),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Color(0xFFD9DEE4), width: 1),
                    borderRadius: BorderRadius.circular(11.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: ConsultationUiConfig.ctaColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(11.r),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Flexible(
              child: partners.isEmpty
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        child: Text(
                          l10n.consultationNoPartnersFound,
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF667B99),
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: partners.length,
                      separatorBuilder: (_, _) => SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        final partner = partners[index];
                        final isSelected =
                            widget.selectedPartnerId == partner.id;
                        return _PartnerFilterTile(
                          partner: partner,
                          isSelected: isSelected,
                          textTheme: textTheme,
                          onTap: () => Navigator.of(context).pop(partner),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PartnerFilterTile extends StatelessWidget {
  const _PartnerFilterTile({
    required this.partner,
    required this.isSelected,
    required this.textTheme,
    required this.onTap,
  });

  final ConsultationPartnerFilterOption partner;
  final bool isSelected;
  final TextTheme textTheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected
                  ? ConsultationUiConfig.ctaColor
                  : const Color(0xFFE7EBF0),
              width: isSelected ? 1.2 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  partner.name,
                  style: textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF061E40),
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE7EBF0)),
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(6.r),
                child: ConsultationPartnerLogoWidget(
                  logoUrl: partner.logoAsset,
                  width: 28.r,
                  height: 28.r,
                  compact: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
