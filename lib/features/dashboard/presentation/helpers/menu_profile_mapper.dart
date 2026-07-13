import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/preference/app_pref.dart';
import '../../../../core/utils/auth_guard.dart';

class MenuProfileViewData {
  const MenuProfileViewData({
    required this.isLoggedIn,
    required this.name,
    required this.phone,
    this.imageUrl,
  });

  final bool isLoggedIn;
  final String name;
  final String phone;
  final String? imageUrl;
}

MenuProfileViewData buildMenuProfileViewData({
  required AppPref appPref,
  required AppLocalizations l10n,
}) {
  final isLoggedIn = AuthGuard.isLoggedIn(appPref);
  final user = appPref.getUserLocalModel();
  final firstName = user?.firstName.trim() ?? '';
  final lastName = user?.lastName.trim() ?? '';
  final fullName = '$firstName $lastName'.trim();

  return MenuProfileViewData(
    isLoggedIn: isLoggedIn,
    name: isLoggedIn && fullName.isNotEmpty
        ? fullName
        : l10n.dashboardMenuGuestUser,
    phone: isLoggedIn
        ? (user?.phone.trim() ?? '')
        : l10n.dashboardMenuSignInContinue,
    imageUrl: isLoggedIn ? user?.imageUrl : null,
  );
}
