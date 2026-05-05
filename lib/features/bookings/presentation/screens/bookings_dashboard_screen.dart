import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/widgets/app_scaffold_gradient.dart';

import 'doctor_consultation_bookings_screen.dart';
import 'lab_test_bookings_screen.dart';
import 'pharmacy_bookings_screen.dart';
import 'surgery_bookings_screen.dart';

class BookingsDashboardScreen extends StatelessWidget {
  const BookingsDashboardScreen({
    super.key,
    this.showBackButton = true,
    this.onBack,
  });

  final bool showBackButton;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final tabs = <String>[
      l10n.bookingsTabDoctorConsultation,
      l10n.bookingsTabSurgery,
      l10n.bookingsTabLabTest,
      l10n.bookingsTabPharmacy,
    ];
    return DefaultTabController(
      length: tabs.length,
      child: AppScaffoldGradient(
        child: Column(
          children: [
              Padding(
                padding: EdgeInsets.fromLTRB(8.w, 6.h, 16.w, 12.h),
                child: Row(
                  children: [
                    showBackButton
                        ? IconButton(
                            onPressed: onBack ??
                                () {
                                  if (context.canPop()) {
                                    context.pop();
                                  }
                                },
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              color: Color(0xFF061E40),
                            ),
                          )
                        : SizedBox(width: 48.w),
                    Expanded(
                      child: Text(
                        l10n.bookingsDashboardTitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: const Color(0xFF061E40),
                          fontWeight: FontWeight.w700,
                          fontSize: 20.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 44.w),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(42.r)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xFF9BA6A7),
                              width: 0.3,
                            ),
                          ),
                        ),
                        child: TabBar(
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          labelPadding: EdgeInsets.symmetric(horizontal: 14.w),
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorWeight: 2.r,
                          indicatorColor: const Color(0xFF061E40),
                          dividerColor: Colors.transparent,
                          labelColor: const Color(0xFF061E40),
                          unselectedLabelColor: const Color(0xFF667B99),
                          labelStyle: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          unselectedLabelStyle:
                              theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          tabs: [for (final tab in tabs) Tab(text: tab)],
                        ),
                      ),
                      const Expanded(
                        child: TabBarView(
                          physics: BouncingScrollPhysics(),
                          children: [
                            DoctorConsultationBookingsScreen(),
                            SurgeryBookingsScreen(),
                            LabTestBookingsScreen(),
                            PharmacyBookingsScreen(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
