import 'package:apnaclinic/core/analytics/analytics_service.dart';
import 'package:apnaclinic/core/di/dependency_injection.dart';
import 'package:apnaclinic/core/l10n/app_localizations.dart';
import 'package:apnaclinic/core/preference/app_pref.dart';
import 'package:apnaclinic/core/preference/user_local_model.dart';
import 'package:apnaclinic/core/widgets/app_button_widget.dart';
import 'package:apnaclinic/features/lab_test/domain/entities/lab_test_cart_item.dart';
import 'package:apnaclinic/features/lab_test/presentation/widgets/lab_test_checkout_error_banner_widget.dart';
import 'package:apnaclinic/features/lab_test/domain/repositories/lab_test_cart_repository.dart';
import 'package:apnaclinic/features/lab_test/domain/use_cases/abandon_lab_test_booking_use_case.dart';
import 'package:apnaclinic/features/lab_test/domain/use_cases/book_lab_test_use_case.dart';
import 'package:apnaclinic/features/lab_test/presentation/lab_test_route_args.dart';
import 'package:apnaclinic/features/lab_test/presentation/screens/lab_test_checkout_screen.dart';
import 'package:apnaclinic/features/promo_code/domain/use_cases/validate_promo_code_use_case.dart';
import 'package:apnaclinic/features/promo_code/presentation/cubit/promo_code_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _MockAppPref implements AppPref {
  @override
  UserLocalModel? getUserLocalModel() => null;

  @override
  String getToken() => '';

  @override
  bool getLoginStatus() => false;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockLabTestCartRepository implements LabTestCartRepository {
  @override
  Future<List<LabTestCartItem>> readCart() async => [];

  @override
  Future<void> writeCart(List<LabTestCartItem> items) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockBookLabTestUseCase implements BookLabTestUseCase {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockAbandonLabTestBookingUseCase implements AbandonLabTestBookingUseCase {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockAnalyticsService implements AnalyticsService {
  @override
  Future<void> logEvent(String name, [Map<String, Object>? parameters]) async {}

  @override
  Future<void> logScreenView({required String screenName, String? screenClass}) async {}

  @override
  Future<void> setUserId(String? userId) async {}

  @override
  Future<void> setUserProperty({required String name, required String? value}) async {}
}

class _MockValidatePromoCodeUseCase implements ValidatePromoCodeUseCase {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late PromoCodeCubit promoCodeCubit;

  setUp(() {
    if (sl.isRegistered<AppPref>()) sl.unregister<AppPref>();
    if (sl.isRegistered<LabTestCartRepository>()) {
      sl.unregister<LabTestCartRepository>();
    }
    if (sl.isRegistered<BookLabTestUseCase>()) {
      sl.unregister<BookLabTestUseCase>();
    }
    if (sl.isRegistered<AbandonLabTestBookingUseCase>()) {
      sl.unregister<AbandonLabTestBookingUseCase>();
    }
    if (sl.isRegistered<AnalyticsService>()) {
      sl.unregister<AnalyticsService>();
    }

    sl.registerSingleton<AppPref>(_MockAppPref());
    sl.registerSingleton<LabTestCartRepository>(_MockLabTestCartRepository());
    sl.registerSingleton<BookLabTestUseCase>(_MockBookLabTestUseCase());
    sl.registerSingleton<AbandonLabTestBookingUseCase>(
      _MockAbandonLabTestBookingUseCase(),
    );
    sl.registerSingleton<AnalyticsService>(_MockAnalyticsService());

    promoCodeCubit = PromoCodeCubit(
      validateUseCase: _MockValidatePromoCodeUseCase(),
    );
  });

  tearDown(() {
    promoCodeCubit.close();
    if (sl.isRegistered<AppPref>()) sl.unregister<AppPref>();
    if (sl.isRegistered<LabTestCartRepository>()) {
      sl.unregister<LabTestCartRepository>();
    }
    if (sl.isRegistered<BookLabTestUseCase>()) {
      sl.unregister<BookLabTestUseCase>();
    }
    if (sl.isRegistered<AbandonLabTestBookingUseCase>()) {
      sl.unregister<AbandonLabTestBookingUseCase>();
    }
    if (sl.isRegistered<AnalyticsService>()) {
      sl.unregister<AnalyticsService>();
    }
  });

  Widget buildTestWidget(LabTestCheckoutArgs args) {
    return BlocProvider.value(
      value: promoCodeCubit,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: LabTestCheckoutScreen(args: args),
        ),
      ),
    );
  }

  LabTestCheckoutArgs createCheckoutArgs({String patientAge = '0'}) {
    return LabTestCheckoutArgs(
      testIds: const [1],
      city: 'Lahore',
      testTitle: 'CBC',
      labDisplayName: 'Chughtai',
      labLogoUrl: '',
      partnerLogoUrl: '',
      sampleType: 'Blood',
      discountedFee: '1000',
      originalFee: '1000',
      discountPercent: 0,
      discountAmount: '0',
      discountCode: '',
      totalAmount: '1000',
      requirementLines: const [],
      patientName: 'Ali Khan',
      patientAge: patientAge,
      patientGender: 'male',
      lines: const [],
    );
  }

  group('LabTestCheckoutScreen Age Validation', () {
    testWidgets('shows labTestAgeInvalid error message when age is 0 on proceed', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final args = createCheckoutArgs(patientAge: '0');

      await tester.pumpWidget(buildTestWidget(args));
      await tester.pumpAndSettle();

      // Tap Edit to edit patient details
      final editBtn = find.text('Edit');
      if (editBtn.evaluate().isNotEmpty) {
        await tester.ensureVisible(editBtn.first);
        await tester.tap(editBtn.first);
        await tester.pumpAndSettle();
      }

      // Enter valid phone numbers for all phone fields (patient phone + emergency phone)
      final phoneFields = find.byWidgetPredicate(
        (w) => w is TextField && w.keyboardType == TextInputType.phone,
      );
      for (var i = 0; i < phoneFields.evaluate().length; i++) {
        await tester.enterText(phoneFields.at(i), '03001234567');
        await tester.pump();
      }

      // Enter age '0'
      final ageField = find.byWidgetPredicate(
        (w) => w is TextField && w.keyboardType == TextInputType.number,
      );
      expect(ageField, findsOneWidget);
      await tester.enterText(ageField, '0');
      await tester.pump();

      // Tap proceed button (Book Lab Test)
      final bookBtn = find.byType(AppButtonWidget);
      expect(bookBtn, findsOneWidget);
      await tester.tap(bookBtn);
      await tester.pumpAndSettle();

      // Verify the invalid age error message is displayed
      expect(find.text('Please enter a valid age (1-99).'), findsOneWidget);
    });

    testWidgets('clears invalid age error message once valid age (1-99) is entered', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final args = createCheckoutArgs(patientAge: '0');

      await tester.pumpWidget(buildTestWidget(args));
      await tester.pumpAndSettle();

      // Tap Edit
      final editBtn = find.text('Edit');
      if (editBtn.evaluate().isNotEmpty) {
        await tester.ensureVisible(editBtn.first);
        await tester.tap(editBtn.first);
        await tester.pumpAndSettle();
      }

      // Enter valid phone numbers for all phone fields (patient phone + emergency phone)
      final phoneFields = find.byWidgetPredicate(
        (w) => w is TextField && w.keyboardType == TextInputType.phone,
      );
      for (var i = 0; i < phoneFields.evaluate().length; i++) {
        await tester.enterText(phoneFields.at(i), '03001234567');
        await tester.pump();
      }

      // Enter age '0'
      final ageField = find.byWidgetPredicate(
        (w) => w is TextField && w.keyboardType == TextInputType.number,
      );
      await tester.enterText(ageField, '0');
      await tester.pump();

      // Tap proceed
      final bookBtn = find.byType(AppButtonWidget);
      expect(bookBtn, findsOneWidget);
      await tester.tap(bookBtn);
      await tester.pumpAndSettle();
      expect(find.text('Please enter a valid age (1-99).'), findsOneWidget);

      // Now enter valid age '35'
      await tester.enterText(ageField, '35');
      await tester.pumpAndSettle();

      // Error message should be cleared
      expect(find.text('Please enter a valid age (1-99).'), findsNothing);
    });
  });
}
