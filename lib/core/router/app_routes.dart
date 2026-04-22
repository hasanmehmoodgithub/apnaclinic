/// App route constants
/// All route names should be defined here (without leading "/")
/// Use path property to get the route path with "/"
class AppRoutes {
  AppRoutes._(); // Private constructor

  static const String root = '';
  static const String splash = 'splash';
  static const String onboarding = 'onboarding';
  static const String authLogin = 'auth-login';
  static const String authOtp = 'auth-otp';
  static const String profileSetup = 'profile-setup';
  static const String home = 'home';
  static const String dashboardMenu = 'dashboard-menu';
  static const String customerSupport = 'customer-support';
  static const String notifications = 'notifications';
  static const String consultation = 'consultation';
  static const String pharmacy = 'pharmacy';
  static const String pharmacyMain = 'pharmacyMain';
  static const String pharmacyCart = 'pharmacyCart';
  static const String pharmacyCheckout = 'pharmacyCheckout';
  static const String search = 'search';
  static const String surgery = 'surgery';
  static const String addAccount = 'add-account';
  static const String accountDetails = 'account-details';
  static const String examples = 'examples';

  static String labTestCheckout='labTestCheckout';

  static String labTestBooking='labTestBooking';

  static String labTest="labTest";

  /// Get route path with leading "/"
  static String path(String route) {
    return route.isEmpty ? '/' : '/$route';
  }
}
