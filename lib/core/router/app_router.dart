import 'package:apnaclinic/features/pharmacy/presentation/screens/pharmacy_main_screen.dart';
import 'package:apnaclinic/features/pharmacy/presentation/screens/prescription_scan_screen.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/app/presentation/screens/splash_screen.dart';
import '../../features/bookings/data/models/surgery_details_item.dart';
import '../../features/bookings/presentation/cubit/doctor_consultation_booking_details_cubit.dart';
import '../../features/bookings/presentation/doctor_consultation_booking_details_args.dart';
import '../../features/bookings/presentation/screens/doctor_consultation_booking_details_screen.dart';
import '../../features/consultation/domain/use_cases/get_consultation_booking_use_case.dart';
import '../../features/consultation/domain/use_cases/submit_consultation_feedback_use_case.dart';
import '../../features/consultation/presentation/cubit/consultation_cubit.dart';
import '../../features/consultation/presentation/screens/ai_consultation_screen.dart';
import '../../features/apna_clinic_ai/presentation/cubit/apna_clinic_ai_cubit.dart';
import '../../features/apna_clinic_ai/presentation/screens/apna_clinic_ai_screen.dart';
import '../../features/consultation/presentation/screens/doctor_consultation_book_doctor_screen.dart';
import '../../features/consultation/presentation/screens/doctor_consultation_checkout_screen.dart';
import '../../features/consultation/presentation/screens/doctor_consultation_summary_screen.dart';
import '../../features/consultation/presentation/screens/doctor_consultation_results_screen.dart';
import '../../features/consultation/presentation/doctor_consultation_results_args.dart';
import '../../features/consultation/presentation/screens/doctor_consultation_screen.dart';
import '../../features/consultation/presentation/consultation_analytics.dart';
import '../../features/consultation/presentation/cubit/doctor_consultation_checkout_cubit.dart';
import '../../features/promo_code/presentation/cubit/promo_code_cubit.dart';
import '../../features/consultation/presentation/doctor_consultation_book_doctor_args.dart';
import '../../features/consultation/presentation/doctor_consultation_checkout_args.dart';
import '../../features/consultation/presentation/doctor_consultation_summary_args.dart';
import '../../features/customer_support/presentation/screens/customer_support_screen.dart';
import '../../features/dashboard/presentation/screens/menu_screen.dart';
import '../../features/lab_test/domain/repositories/lab_test_cart_repository.dart';
import '../../features/lab_test/presentation/cubit/lab_test_booking_cubit.dart';
import '../../features/lab_test/presentation/cubit/lab_test_cart_cubit.dart';
import '../../features/lab_test/presentation/cubit/lab_test_cubit.dart';
import '../../features/lab_test/presentation/lab_test_analytics.dart';
import '../../features/lab_test/presentation/lab_test_route_args.dart';
import '../../features/lab_test/presentation/screens/lab_test_booking_screen.dart';
import '../../features/lab_test/presentation/screens/lab_test_cart_screen.dart';
import '../../features/lab_test/presentation/screens/lab_test_checkout_screen.dart';
import '../../features/lab_test/presentation/screens/lab_test_screen.dart';
import '../../features/lab_test/presentation/screens/lab_test_view_details_screen.dart';
import '../../features/lab_test/presentation/screens/lab_test_report_viewer_screen.dart';
import '../../features/lab_test/presentation/screens/lab_test_select_test_screen.dart';
import '../../features/lab_test/domain/use_cases/get_lab_test_catalog_use_case.dart';
import '../../features/lab_test/domain/use_cases/get_labs_use_case.dart';
import '../cities/domain/repositories/cities_repository.dart';
import '../../features/notification/presentation/cubit/notification_cubit.dart';
import '../../features/notification/presentation/screens/notifcation_screen.dart';
import '../../features/bookings/presentation/screens/surgery_booking_details_screen.dart';
import '../../features/pharmacy/domain/entities/pharmacy_medicine_entity.dart';
import '../../features/pharmacy/presentation/screens/pharmacy_cart_screen.dart';
import '../../features/pharmacy/presentation/screens/pharmacy_checkout_screen.dart';
import '../../features/pharmacy/presentation/screens/pharmacy_booking_details_screen.dart';
import '../../features/pharmacy/presentation/screens/pharmacy_screen.dart';
import '../../features/pharmacy/presentation/pharmacy_navigation.dart';
import '../../features/search/presentation/cubit/search_cubit.dart';
import '../../features/search/presentation/models/search_launch_args.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/surgery/presentation/cubit/surgery_cubit.dart';
import '../../features/surgery/presentation/cubit/surgery_patient_details_cubit.dart';
import '../../features/surgery/presentation/screens/surgery_booking_entry_screen.dart';
import '../../features/surgery/presentation/screens/surgery_patient_details_screen.dart';
import '../../features/surgery/presentation/screens/surgery_screen.dart';
import '../../features/surgery/presentation/surgery_analytics.dart';
import '../../features/surgery/presentation/surgery_booking_args.dart';
import '../../features/surgery/presentation/surgery_patient_details_args.dart';
import '../../features/dashboard/presentation/screens/main_navigation_shell.dart';
import '../../features/account/presentation/screens/account_details_screen.dart';
import '../../features/account/presentation/add_account_launch_source.dart';
import '../../features/account/presentation/screens/add_account_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../di/dependency_injection.dart';
import '../preference/app_pref.dart';
import '../utils/auth_guard.dart';
import '../utils/chucker_guard.dart';
import '../../features/instant_doctor/presentation/instant_doctor_consultation_args.dart';
import '../../features/instant_doctor/presentation/screens/instant_doctor_consultation_webview_screen.dart';
import '../../features/payment/presentation/payment_webview_args.dart';
import '../../features/payment/presentation/screens/payment_webview_screen.dart';
import '../../features/pro/presentation/pro_user_webview_args.dart';
import '../../features/pro/presentation/screens/pro_user_webview_screen.dart';
import '../../features/profile_setup/presentation/profile_setup_launch_source.dart';
import '../../features/profile_setup/presentation/cubit/profile_cubit.dart';
import '../../features/profile_setup/presentation/screens/profile_screen.dart';
import '../../features/profile_setup/presentation/screens/profile_setup_screen.dart';
import '../analytics/analytics_route_observer.dart';
import 'app_routes.dart';
import 'router_observer.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.path(AppRoutes.splash),
    observers: [
      GoRouterObserver(),
      AnalyticsRouteObserver(),
      if (ChuckerGuard.isEnabled) ChuckerFlutter.navigatorObserver,
    ],

    routes: [
      GoRoute(
        path: AppRoutes.path(AppRoutes.root),
        redirect: (context, state) => AppRoutes.path(AppRoutes.splash),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.splash),
        name: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.onboarding),
        name: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.authLogin),
        name: AppRoutes.authLogin,
        builder: (context, state) => LoginScreen(
          source: authLoginSourceFromExtra(state.extra),
        ),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.profileSetup),
        name: AppRoutes.profileSetup,
        builder: (context, state) => ProfileSetupScreen(
          launchSource: profileSetupLaunchSourceFromExtra(state.extra),
        ),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.profile),
        name: AppRoutes.profile,
        builder: (context, state) => BlocProvider<ProfileCubit>(
          create: (_) => sl<ProfileCubit>(),
          child: const ProfileScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.home),
        name: AppRoutes.home,
        redirect: (context, state) {
          final appPref = sl<AppPref>();
          if (appPref.getLoginStatus() && !appPref.isProfileCompleted()) {
            return AppRoutes.path(AppRoutes.profileSetup);
          }
          return null;
        },
        builder: (context, state) => const MainNavigationShell(),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.dashboardMenu),
        name: AppRoutes.dashboardMenu,
        builder: (context, state) => const MenuScreen(),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.customerSupport),
        name: AppRoutes.customerSupport,
        builder: (context, state) => const CustomerSupportScreen(),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.notifications),
        name: AppRoutes.notifications,
        builder: (context, state) => BlocProvider<NotificationCubit>.value(
          value: sl<NotificationCubit>()..loadNotifications(refresh: true),
          child: const NotificationScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.addAccount),
        name: AppRoutes.addAccount,
        builder: (context, state) => AddAccountScreen(
          launchSource: addAccountLaunchSourceFromExtra(state.extra),
        ),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.accountDetails),
        name: AppRoutes.accountDetails,
        builder: (context, state) {
          final extra = state.extra;
          final data = extra is Map ? Map<String, dynamic>.from(extra) : null;
          return AccountDetailsScreen(
            showSuccessDialog: data?['showSuccessDialog'] == true,
            addedPhone: data?['addedPhone'] as String?,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.consultation),
        name: AppRoutes.consultation,
        builder: (context, state) => BlocProvider<ConsultationCubit>(
          create: (_) => sl<ConsultationCubit>(),
          child: DoctorConsultationScreen(
            source: consultancyHubSourceFromExtra(state.extra),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.aiScreening),
        name: AppRoutes.aiScreening,
        builder: (context, state) {
          final extra = state.extra;
          final url = extra is String ? extra : null;
          return AiScreeningScreen(url: url);
        },
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.apnaClinicAi),
        name: AppRoutes.apnaClinicAi,
        builder: (context, state) => BlocProvider<ApnaClinicAiCubit>(
          create: (_) => sl<ApnaClinicAiCubit>(),
          child: const ApnaClinicAiScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.consultationDoctors),
        name: AppRoutes.consultationDoctors,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is DoctorConsultationResultsArgs) {
            return DoctorConsultationResultsScreen(
              selectedCategory: extra.selectedCategory,
              mainCategoryId: extra.mainCategoryId,
              categoryOptions: extra.categoryOptions,
            );
          }
          return const SizedBox.shrink();
        },
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.consultationBookDoctor),
        name: AppRoutes.consultationBookDoctor,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! DoctorConsultationBookDoctorArgs) {
            return const SizedBox.shrink();
          }
          return DoctorConsultationBookDoctorScreen(
            doctor: extra.doctor,
            moduleSource: extra.moduleSource,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.consultationCheckout),
        name: AppRoutes.consultationCheckout,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! DoctorConsultationCheckoutArgs) {
            return const SizedBox.shrink();
          }
          return MultiBlocProvider(
            providers: [
              BlocProvider<DoctorConsultationCheckoutCubit>(
                create: (_) => sl<DoctorConsultationCheckoutCubit>(),
              ),
              BlocProvider<PromoCodeCubit>(
                create: (_) => sl<PromoCodeCubit>(),
              ),
            ],
            child: DoctorConsultationCheckoutScreen(args: extra),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.consultationSummary),
        name: AppRoutes.consultationSummary,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! DoctorConsultationSummaryArgs) {
            return const SizedBox.shrink();
          }
          return BlocProvider<DoctorConsultationCheckoutCubit>(
            create: (_) => sl<DoctorConsultationCheckoutCubit>(),
            child: DoctorConsultationSummaryScreen(args: extra),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.doctorConsultationBookingDetails),
        name: AppRoutes.doctorConsultationBookingDetails,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! DoctorConsultationBookingDetailsArgs) {
            return const SizedBox.shrink();
          }
          return BlocProvider<DoctorConsultationBookingDetailsCubit>(
            create: (_) => DoctorConsultationBookingDetailsCubit(
              getBookingUseCase: sl<GetConsultationBookingUseCase>(),
              submitFeedbackUseCase: sl<SubmitConsultationFeedbackUseCase>(),
              bookingId: extra.bookingId,
              booking: extra.booking,
            ),
            child: const DoctorConsultationBookingDetailsScreen(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.pharmacy),
        name: AppRoutes.pharmacy,
        builder: (context, state) {
          final extra = state.extra;
          final data = extra is Map ? Map<String, dynamic>.from(extra) : null;
          final selectedMedicine =
              data?[PharmacyRouteExtraKeys.selectedMedicine]
                  as PharmacyMedicineEntity?;
          return PharmacyScreen(
            initialFeaturedMedicine: selectedMedicine,
            moduleSource: pharmacySourceFromExtra(extra),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.pharmacyMain),
        name: AppRoutes.pharmacyMain,
        builder: (context, state) => PharmacyMainScreen(
          source: pharmacyHubSourceFromExtra(state.extra),
        ),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.pharmacyPrescriptionScan),
        name: AppRoutes.pharmacyPrescriptionScan,
        builder: (context, state) => const PrescriptionScanScreen(),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.pharmacyCart),
        name: AppRoutes.pharmacyCart,
        builder: (context, state) => const PharmacyCartScreen(),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.pharmacyCheckout),
        name: AppRoutes.pharmacyCheckout,
        builder: (context, state) => const PharmacyCheckoutScreen(),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.pharmacyBookingDetails),
        name: AppRoutes.pharmacyBookingDetails,
        builder: (context, state) {
          final extra = state.extra;
          final data = extra is Map ? Map<String, dynamic>.from(extra) : null;
          final orderId = (data?['orderId'] ?? '').toString().trim();
          final fallbackOrderNo = (data?['orderNo'] ?? '').toString().trim();
          return PharmacyBookingDetailsScreen(
            orderId: orderId,
            fallbackOrderNo:
                fallbackOrderNo.isEmpty ? null : fallbackOrderNo,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.search),
        name: AppRoutes.search,
        builder: (context, state) {
          final extra = state.extra;
          String? initialQuery;
          var startVoiceSearch = false;

          if (extra is SearchLaunchArgs) {
            initialQuery = extra.initialQuery;
            startVoiceSearch = extra.startVoiceSearch;
          } else if (extra is String) {
            initialQuery = extra;
          }

          return BlocProvider<SearchCubit>(
            create: (_) => sl<SearchCubit>(),
            child: SearchScreen(
              initialQuery: initialQuery,
              startVoiceSearch: startVoiceSearch,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.surgery),
        name: AppRoutes.surgery,
        builder: (context, state) => BlocProvider<SurgeryCubit>(
          create: (_) => sl<SurgeryCubit>(),
          child: SurgeryScreen(
            source: surgeryHubSourceFromExtra(state.extra),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.surgeryBooking),
        name: AppRoutes.surgeryBooking,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! SurgeryBookingArgs) {
            return const SizedBox.shrink();
          }
          return BlocProvider<SurgeryCubit>(
            create: (_) => sl<SurgeryCubit>(),
            child: SurgeryBookingEntryScreen(args: extra),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.surgeryPatientDetails),
        name: AppRoutes.surgeryPatientDetails,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! SurgeryPatientDetailsArgs) {
            return const SizedBox.shrink();
          }
          return BlocProvider<SurgeryPatientDetailsCubit>(
            create: (_) => sl<SurgeryPatientDetailsCubit>(),
            child: SurgeryPatientDetailsScreen(
              surgeryId: extra.surgeryId,
              cityId: extra.cityId,
              doctorId: extra.doctorId,
              doctorName: extra.doctorName,
              speciality: extra.speciality,
              experience: extra.experience,
              qualifications: extra.qualifications,
              hospitalName: extra.hospitalName,
              procedureName: extra.procedureName,
              price: extra.price,
              oldPrice: extra.oldPrice,
              imageUrl: extra.imageUrl,
              partnerLogoUrl: extra.partnerLogoUrl,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.surgeryBookingDetails),
        name: AppRoutes.surgeryBookingDetails,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! SurgeryBookingDetailsArgs) {
            return const SizedBox.shrink();
          }
          return SurgeryDetailsScreen(
            key: ValueKey('surgery-details-${extra.leadId}'),
            item: extra.item,
            initialStatus: extra.initialStatus,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.labTest),
        name: AppRoutes.labTest,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider<LabTestCubit>(create: (_) => sl<LabTestCubit>()),
            BlocProvider<LabTestCartCubit>.value(value: sl<LabTestCartCubit>()),
          ],
          child: LabTestScreen(source: labHubSourceFromExtra(state.extra)),
        ),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.labTestSelectTest),
        name: AppRoutes.labTestSelectTest,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! LabTestSelectTestArgs) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<LabTestCubit>(create: (_) => sl<LabTestCubit>()),
                BlocProvider<LabTestCartCubit>.value(
                  value: sl<LabTestCartCubit>(),
                ),
              ],
              child: const LabTestScreen(),
            );
          }
          return MultiBlocProvider(
            providers: [
              BlocProvider<LabTestCubit>(
                create: (_) => LabTestCubit(
                  getLabTestCatalogUseCase: sl<GetLabTestCatalogUseCase>(),
                  getLabsUseCase: sl<GetLabsUseCase>(),
                  appPref: sl<AppPref>(),
                  citiesRepository: sl<CitiesRepository>(),
                  autoBootstrap: false,
                )..startSelectTest(extra),
              ),
              BlocProvider<LabTestCartCubit>.value(
                value: sl<LabTestCartCubit>(),
              ),
            ],
            child: const LabTestSelectTestScreen(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.labTestBooking),
        name: AppRoutes.labTestBooking,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! LabTestBookingArgs) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<LabTestCubit>(create: (_) => sl<LabTestCubit>()),
                BlocProvider<LabTestCartCubit>.value(
                  value: sl<LabTestCartCubit>(),
                ),
              ],
              child: const LabTestScreen(),
            );
          }
          return MultiBlocProvider(
            providers: [
              BlocProvider<LabTestBookingCubit>(
                create: (_) => LabTestBookingCubit(
                  args: extra,
                  cartRepository: sl<LabTestCartRepository>(),
                  sharedCartCubit: sl<LabTestCartCubit>(),
                  getLabTestDetailUseCase: sl(),
                ),
              ),
              BlocProvider<LabTestCartCubit>.value(
                value: sl<LabTestCartCubit>(),
              ),
            ],
            child: const LabTestBookingScreen(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.labTestCheckout),
        name: AppRoutes.labTestCheckout,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! LabTestCheckoutArgs) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<LabTestCubit>(create: (_) => sl<LabTestCubit>()),
                BlocProvider<LabTestCartCubit>.value(
                  value: sl<LabTestCartCubit>(),
                ),
              ],
              child: const LabTestScreen(),
            );
          }
          return BlocProvider(
            create: (_) => sl<PromoCodeCubit>(),
            child: LabTestCheckoutScreen(args: extra),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.labTestCart),
        name: AppRoutes.labTestCart,
        builder: (context, state) => BlocProvider<LabTestCartCubit>.value(
          value: sl<LabTestCartCubit>(),
          child: const LabTestCartScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.labTestViewDetails),
        name: AppRoutes.labTestViewDetails,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! LabTestViewDetailsArgs) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<LabTestCubit>(create: (_) => sl<LabTestCubit>()),
                BlocProvider<LabTestCartCubit>.value(
                  value: sl<LabTestCartCubit>(),
                ),
              ],
              child: const LabTestScreen(),
            );
          }
          return LabTestViewDetailsScreen(args: extra);
        },
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.labTestReportViewer),
        name: AppRoutes.labTestReportViewer,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! LabTestReportViewerArgs) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<LabTestCubit>(create: (_) => sl<LabTestCubit>()),
                BlocProvider<LabTestCartCubit>.value(
                  value: sl<LabTestCartCubit>(),
                ),
              ],
              child: const LabTestScreen(),
            );
          }
          return LabTestReportViewerScreen(args: extra);
        },
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.instantDoctorConsultation),
        name: AppRoutes.instantDoctorConsultation,
        builder: (context, state) {
          final args = instantDoctorConsultationArgsFromExtra(state.extra);
          if (args == null) {
            return const Scaffold(
              body: Center(child: Text('Invalid consultation link')),
            );
          }
          return InstantDoctorConsultationWebViewScreen(args: args);
        },
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.cardPayment),
        name: AppRoutes.cardPayment,
        builder: (context, state) {
          final args = paymentWebViewArgsFromExtra(state.extra);
          if (args == null) {
            return const Scaffold(
              body: Center(child: Text('Invalid payment link')),
            );
          }
          return PaymentWebViewScreen(args: args);
        },
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.proUserWebView),
        name: AppRoutes.proUserWebView,
        builder: (context, state) {
          final args = proUserWebViewArgsFromExtra(state.extra);
          if (args == null) {
            return const Scaffold(
              body: Center(child: Text('Invalid Pro payment link')),
            );
          }
          return ProUserWebViewScreen(args: args);
        },
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
}
