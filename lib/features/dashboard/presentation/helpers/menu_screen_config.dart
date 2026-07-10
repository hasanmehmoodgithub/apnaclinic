import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/utils/app_url_launcher.dart';
import '../widgets/menu_about_card.dart';

enum MenuActionId {
  myBookings,
  customerSupport,
  faq,
}

class MenuActionItem {
  const MenuActionItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.curveOverlayColor,
  });

  final MenuActionId id;
  final String title;
  final IconData icon;
  final Color curveOverlayColor;
}

List<MenuActionItem> buildMenuActionItems(AppLocalizations l10n) {
  return [
    MenuActionItem(
      id: MenuActionId.myBookings,
      title: l10n.bookingsDashboardTitle,
      icon: Icons.event_note_outlined,
      curveOverlayColor: AppColors.clr9EC7E8.withValues(alpha: 0.20),
    ),
    MenuActionItem(
      id: MenuActionId.customerSupport,
      title: l10n.dashboardMenuCustomerSupport,
      icon: Icons.headset_mic_outlined,
      curveOverlayColor: AppColors.clrCAD8FD.withValues(alpha: 0.20),
    ),
    MenuActionItem(
      id: MenuActionId.faq,
      title: l10n.dashboardMenuFaq,
      icon: Icons.help_outline_rounded,
      curveOverlayColor: AppColors.clrEBDFFF.withValues(alpha: 0.25),
    ),
  ];
}

List<MenuAboutItemData> buildMenuAboutItems(AppLocalizations l10n) {
  return [
    MenuAboutItemData(l10n.dashboardMenuAppVersion, subtitle: '1.0'),
    MenuAboutItemData(
      l10n.dashboardMenuTerms,
      onTap: () => AppUrlLauncher.open(
        url: AppUrls.termsAndConditions,
        lunchMode: LaunchMode.inAppWebView,
      ),
    ),
    MenuAboutItemData(
      l10n.dashboardMenuPrivacy,
      onTap: () => AppUrlLauncher.open(
        url: AppUrls.privacyPolicy,
        lunchMode: LaunchMode.inAppWebView,
      ),
    ),
  ];
}

Future<void> openMenuFaq() {
  return launchUrl(
    Uri.parse(AppUrls.faq),
    mode: LaunchMode.externalApplication,
  );
}

Future<void> openMenuWebsite() {
  return launchUrl(
    Uri.parse(AppUrls.website),
    mode: LaunchMode.externalApplication,
  );
}
