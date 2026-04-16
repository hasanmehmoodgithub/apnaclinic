import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/consultation/consultation_injection.dart';
import '../../features/customer_support/customer_support_injection.dart';
import '../../features/dashboard/dashboard_injection.dart';
import '../../features/free_doctor/free_doctor_injection.dart';
import '../../features/auth/auth_injection.dart';
import '../../features/profile_setup/profile_setup_injection.dart';
import '../database/app_database.dart';
import '../network/api_service.dart';
import '../preference/app_pref.dart';
import '../preference/app_pref_impl.dart';
import '../services/encryption_service.dart';
import '../services/connectivity_service.dart';
import '../services/responsive_config_service.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencyInjection() async {
  await _initCore();
  initAuthInjector();
  initProfileSetupInjector();
  initConsultationInjector();
  initFreeDoctorInjector();
  initCustomerSupportInjector();
  initDashboardInjector();
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
