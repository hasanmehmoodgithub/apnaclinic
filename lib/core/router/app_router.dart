import 'package:apnaclinic/features/pharmacy/presentation/screens/pharmacy_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/app/presentation/screens/splash_screen.dart';
import '../../features/bookings/data/models/surgery_details_item.dart';
import '../../features/consultation/presentation/cubit/consultation_cubit.dart';
import '../../features/consultation/presentation/screens/ai_consultation_screen.dart';
import '../../features/consultation/presentation/screens/doctor_consultation_book_doctor_screen.dart';
import '../../features/consultation/presentation/screens/doctor_consultation_results_screen.dart';
import '../../features/consultation/presentation/screens/doctor_consultation_screen.dart';
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
import '../../features/pharmacy/presentation/screens/pharmacy_screen.dart';
import '../../features/search/presentation/cubit/search_cubit.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/surgery/presentation/cubit/surgery_cubit.dart';
import '../../features/surgery/presentation/screens/surgery_screen.dart';
import '../../features/dashboard/presentation/screens/main_navigation_shell.dart';
import '../../features/account/presentation/screens/account_details_screen.dart';
import '../../features/account/presentation/screens/add_account_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../di/dependency_injection.dart';
import '../../features/profile_setup/presentation/screens/profile_setup_screen.dart';
import 'app_routes.dart';
import 'router_observer.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.path(AppRoutes.splash),
    observers: [GoRouterObserver()], // Router debug logging

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
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.home),
        name: AppRoutes.home,
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
        builder: (context, state) => BlocProvider<NotificationCubit>(
          create: (_) => sl<NotificationCubit>(),
          child: const NotificationScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.addAccount),
        name: AppRoutes.addAccount,
        builder: (context, state) => const AddAccountScreen(),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.accountDetails),
        name: AppRoutes.accountDetails,
        builder: (context, state) {
          final extra = state.extra;
          final data = extra is Map ? Map<String, dynamic>.from(extra) : null;
          return AccountDetailsScreen(
            initialAccountIndex: data?['accountIndex'] as int?,
            showSuccessDialog: data?['showSuccessDialog'] == true,
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
        path:AppRoutes.path(AppRoutes.aiScreening),
        name: AppRoutes.aiScreening,
        builder: (context, state) => const AiScreeningScreen(),
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.consultationDoctors),
        name: AppRoutes.consultationDoctors,
        builder: (context, state) {
          final extra = state.extra;
          final data = extra is Map ? Map<String, dynamic>.from(extra) : null;
          final selectedCategory = (data?['category'] as String?)?.trim();
          return DoctorConsultationResultsScreen(
            selectedCategory: (selectedCategory?.isNotEmpty ?? false)
                ? selectedCategory!
                : 'Neurologist',
          );
        },
      ),
      GoRoute(
        path: AppRoutes.path(AppRoutes.consultationBookDoctor),
        name: AppRoutes.consultationBookDoctor,
        builder: (context, state) {
          final extra = state.extra;
          final data = extra is Map ? Map<String, dynamic>.from(extra) : null;
          return DoctorConsultationBookDoctorScreen(
            doctorId: (data?['doctorId'] as String?),
            doctorName: (data?['doctorName'] as String?) ?? 'Dr. Sumbal Shahid',
            specialty: (data?['specialty'] as String?) ?? 'Neurologist',
            fee: (data?['fee'] as String?) ?? 'Rs. 15,000/-',
            imageUrl: (data?['imageUrl'] as String?) ?? '',
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
        path: AppRoutes.path(AppRoutes.search),
        name: AppRoutes.search,
        builder: (context, state) {
          final initialQuery = state.extra is String ? state.extra as String : null;
          return BlocProvider<SearchCubit>(
            create: (_) => sl<SearchCubit>(),
            child: SearchScreen(initialQuery: initialQuery),
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
        path: AppRoutes.path(AppRoutes.surgeryBookingDetails),
        name: AppRoutes.surgeryBookingDetails,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! SurgeryBookingDetailsArgs) {
            return const SizedBox.shrink();
          }
          return SurgeryDetailsScreen(
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
            return const LabTestScreen();
          }
          return BlocProvider<LabTestBookingCubit>(
            create: (_) => LabTestBookingCubit(
              args: extra,
              cartRepository: sl<LabTestCartRepository>(),
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
            return const LabTestScreen();
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
            return const LabTestScreen();
          }
          return LabTestViewDetailsScreen(args: extra);
        },
      ),

    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
}
