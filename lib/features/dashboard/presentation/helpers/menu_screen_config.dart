import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/network/app_urls.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/utils/app_url_launcher.dart';
import '../widgets/menu_about_card.dart';

enum MenuActionId {
  myBookings,
  apnaClinicAi,
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
      id: MenuActionId.apnaClinicAi,
      title: l10n.apnaClinicAiMenuTitle,
      icon: Icons.medical_services_outlined,
      curveOverlayColor: AppColors.clr0FAA9A.withValues(alpha: 0.16),
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

Future<String> loadMenuAppVersion() async {
  final info = await PackageInfo.fromPlatform();
  final version = info.version.trim();
  if (version.isEmpty) return '';
  final build = info.buildNumber.trim();
  if (build.isEmpty) return version;
  return '$version ($build)';
}

List<MenuAboutItemData> buildMenuAboutItems(
  AppLocalizations l10n, {
  String? appVersion,
}) {
  final version = appVersion?.trim();
  final support = sl<AppPref>().getSupportSettings();
  return [
    MenuAboutItemData(
      l10n.dashboardMenuAppVersion,
      subtitle: (version != null && version.isNotEmpty) ? version : null,
    ),
    MenuAboutItemData(
      l10n.dashboardMenuTerms,
      onTap: () => AppUrlLauncher.open(
        url: support?.termsAndConditionsUrl ?? '',
        lunchMode: LaunchMode.inAppBrowserView,
      ),
    ),
    MenuAboutItemData(
      l10n.dashboardMenuPrivacy,
      onTap: () => AppUrlLauncher.open(
        url: support?.privacyPolicyUrl ?? '',
        lunchMode: LaunchMode.inAppBrowserView,
      ),
    ),
  ];
}

Future<void> openMenuFaq() {
  final url = sl<AppPref>().getSupportSettings()?.faqsUrl.trim() ?? '';
  if (url.isEmpty) return Future.value();
  final uri = Uri.tryParse(url);
  if (uri == null || !uri.hasScheme) return Future.value();
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}

Future<void> openMenuWebsite() {
  return launchUrl(
    Uri.parse(AppUrls.website),
    mode: LaunchMode.externalApplication,
  );
}
