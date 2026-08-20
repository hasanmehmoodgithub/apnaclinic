import 'package:flutter/material.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/extensions/screen_util_extensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/session/auth_session_refresh.dart';
import '../../../dashboard/presentation/constants/main_navigation_tabs.dart';
import '../widgets/empty_booking_widget.dart';

class InstantDoctorBookingsScreen extends StatelessWidget {
  const InstantDoctorBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: EmptyBookingWidget(
        description: l10n.bookingsInstantDoctorEmptyDescription,
        buttonText: l10n.instantDoctorTitle,
        onTap: () => sl<AuthSessionRefresh>().requestTabIndex(
          MainNavigationTabs.instantDoctor,
        ),
      ),
    );
  }
}
