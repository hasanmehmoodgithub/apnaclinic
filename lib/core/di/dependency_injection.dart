import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/consultation/consultation_injection.dart';
import '../../features/account/account_injection.dart';
import '../../features/customer_support/customer_support_injection.dart';
import '../../features/dashboard/dashboard_injection.dart';
import '../../features/lab_test/lab_test_injection.dart';
import '../../features/notification/notification_injection.dart';
import '../../features/pharmacy/pharmacy_injection.dart';
import '../../features/search/search_injection.dart';
import '../../features/surgery/surgery_injection.dart';
import '../../features/free_doctor/free_doctor_injection.dart';
import '../../features/auth/auth_injection.dart';
import '../../features/profile_setup/profile_setup_injection.dart';
import '../database/app_database.dart';
import '../network/api_service.dart';
import '../network/device_headers_provider.dart';
import '../preference/app_pref.dart';
import '../preference/app_pref_impl.dart';
import '../services/encryption_service.dart';
import '../services/connectivity_service.dart';
import '../services/responsive_config_service.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencyInjection() async {
  await _initCore();
  initAuthInjector();
  initAccountInjector();
  initProfileSetupInjector();
  initConsultationInjector();
  initFreeDoctorInjector();
  initCustomerSupportInjector();
  initDashboardInjector();
  initNotificationInjector();
  initPharmacyInjector();
  initSearchInjector();
  initSurgeryInjector();
  initLabTestInjector();
}

Future<void> _initCore() async {
  final sharedPref = await SharedPreferences.getInstance();
  final encryptionService = EncryptionService();
  await encryptionService.initialize();

  sl.registerLazySingleton<EncryptionService>(() => encryptionService);
  sl.registerLazySingleton<SharedPreferences>(() => sharedPref);
  sl.registerLazySingleton<AppPref>(
    () => AppPrefImpl(encryptionService: sl<EncryptionService>(), sharedPref),
  );
  sl.registerLazySingleton<DeviceHeadersProvider>(
    () => DeviceHeadersProvider(),
  );
  sl.registerLazySingleton<ApiService>(
    () => ApiService(
      // baseUrl is automatically retrieved from FlavorConfig.apiBaseUrl
      // enableLogging is automatically retrieved from FlavorConfig.enableLogging
    ),
  );
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());
  sl.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
  sl.registerLazySingleton<ResponsiveConfigService>(
    () => const ResponsiveConfigService(),
  );
  // sl.registerLazySingleton<NotificationService>(() => NotificationService());
}
