import 'package:apnaclinic/features/pharmacy/presentation/screens/pharmacy_main_screen.dart';
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
import '../../features/consultation/presentation/screens/doctor_consultation_book_doctor_screen.dart';
import '../../features/consultation/presentation/screens/doctor_consultation_checkout_screen.dart';
import '../../features/consultation/presentation/screens/doctor_consultation_summary_screen.dart';
import '../../features/consultation/presentation/screens/doctor_consultation_results_screen.dart';
import '../../features/consultation/presentation/doctor_consultation_results_args.dart';
import '../../features/consultation/presentation/screens/doctor_consultation_screen.dart';
import '../../features/consultation/presentation/cubit/doctor_consultation_checkout_cubit.dart';
import '../../features/consultation/presentation/doctor_consultation_book_doctor_args.dart';
import '../../features/consultation/presentation/doctor_consultation_checkout_args.dart';
import '../../features/consultation/presentation/doctor_consultation_summary_args.dart';
import '../../features/customer_support/presentation/screens/customer_support_screen.dart';
import '../../features/dashboard/presentation/screens/menu_screen.dart';
import '../../features/lab_test/domain/repositories/lab_test_cart_repository.dart';
import '../../features/lab_test/presentation/cubit/lab_test_booking_cubit.dart';
import '../../features/lab_test/presentation/cubit/lab_test_cart_cubit.dart';
import '../../features/lab_test/presentation/cubit/lab_test_cubit.dart';
import '../../features/lab_test/presentation/lab_test_route_args.dart';
import '../../features/lab_test/presentation/screens/lab_test_booking_screen.dart';
import '../../features/lab_test/presentation/screens/lab_test_cart_screen.dart';
import '../../features/lab_test/presentation/screens/lab_test_checkout_screen.dart';
import '../../features/lab_test/presentation/screens/lab_test_screen.dart';
import '../../features/lab_test/presentation/screens/lab_test_view_details_screen.dart';
import '../../features/notification/presentation/cubit/notification_cubit.dart';
import '../../features/notification/presentation/screens/notifcation_screen.dart';
import '../../features/bookings/presentation/screens/surgery_booking_details_screen.dart';
import '../../features/pharmacy/domain/entities/pharmacy_medicine_entity.dart';
import '../../features/pharmacy/presentation/screens/pharmacy_cart_screen.dart';
import '../../features/pharmacy/presentation/screens/pharmacy_checkout_screen.dart';
import '../../features/pharmacy/presentation/screens/pharmacy_booking_details_screen.dart';
import '../../features/pharmacy/presentation/screens/pharmacy_screen.dart';
import '../../features/search/presentation/cubit/search_cubit.dart';
import '../../features/search/presentation/models/search_launch_args.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/surgery/presentation/cubit/surgery_cubit.dart';
import '../../features/surgery/presentation/cubit/surgery_patient_details_cubit.dart';
import '../../features/surgery/presentation/screens/surgery_booking_entry_screen.dart';
import '../../features/surgery/presentation/screens/surgery_patient_details_screen.dart';
import '../../features/surgery/presentation/screens/surgery_screen.dart';
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
import '../utils/chucker_guard.dart';
import '../../features/instant_doctor/presentation/instant_doctor_consultation_args.dart';
import '../../features/instant_doctor/presentation/screens/instant_doctor_consultation_webview_screen.dart';
import '../../features/payment/presentation/payment_webview_args.dart';
import '../../features/payment/presentation/screens/payment_webview_screen.dart';
import '../../features/profile_setup/presentation/profile_setup_launch_source.dart';
import '../../features/profile_setup/presentation/cubit/profile_cubit.dart';
import '../../features/profile_setup/presentation/screens/profile_screen.dart';
import '../../features/profile_setup/presentation/screens/profile_setup_screen.dart';
import 'app_routes.dart';
import 'router_observer.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.path(AppRoutes.splash),
    observers: [
      GoRouterObserver(),
      if (ChuckerGuard.isEnabled) ChuckerFlutter.navigatorObserver,
    ], // Router debug logging

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
        builder: (context, state) => const LoginScreen(),
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
          child: const DoctorConsultationScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.aiScreening),
        name: AppRoutes.aiScreening,
        builder: (context, state) => const AiScreeningScreen(),
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
          return DoctorConsultationBookDoctorScreen(doctor: extra.doctor);
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
          return BlocProvider<DoctorConsultationCheckoutCubit>(
            create: (_) => sl<DoctorConsultationCheckoutCubit>(),
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
              data?['selectedMedicine'] as PharmacyMedicineEntity?;
          return PharmacyScreen(initialFeaturedMedicine: selectedMedicine);
        },
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.pharmacyMain),
        name: AppRoutes.pharmacyMain,
        builder: (context, state) => const PharmacyMainScreen(),
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
          final orderId = (data?['orderId'] as String? ??
                  data?['orderNo'] as String? ??
                  '')
              .trim();
          final fallbackOrderNo = (data?['orderNo'] as String?)?.trim();
          return PharmacyBookingDetailsScreen(
            orderId: orderId,
            fallbackOrderNo: fallbackOrderNo,
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
          child: const SurgeryScreen(),
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
        builder: (context, state) => BlocProvider<LabTestCubit>(
          create: (_) => sl<LabTestCubit>(),
          child: const LabTestScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.labTestBooking),
        name: AppRoutes.labTestBooking,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! LabTestBookingArgs) {
            return BlocProvider<LabTestCubit>(
              create: (_) => sl<LabTestCubit>(),
              child: const LabTestScreen(),
            );
          }
          return BlocProvider<LabTestBookingCubit>(
            create: (_) => LabTestBookingCubit(
              args: extra,
              cartRepository: sl<LabTestCartRepository>(),
              getLabTestDetailUseCase: sl(),
            ),
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
            return BlocProvider<LabTestCubit>(
              create: (_) => sl<LabTestCubit>(),
              child: const LabTestScreen(),
            );
          }
          return LabTestCheckoutScreen(args: extra);
        },
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.labTestCart),
        name: AppRoutes.labTestCart,
        builder: (context, state) => BlocProvider<LabTestCartCubit>(
          create: (_) => sl<LabTestCartCubit>(),
          child: const LabTestCartScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.labTestViewDetails),
        name: AppRoutes.labTestViewDetails,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! LabTestViewDetailsArgs) {
            return BlocProvider<LabTestCubit>(
              create: (_) => sl<LabTestCubit>(),
              child: const LabTestScreen(),
            );
          }
          return LabTestViewDetailsScreen(args: extra);
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
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
}
