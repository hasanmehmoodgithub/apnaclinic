import 'package:apnaclinic/core/l10n/app_localizations.dart';
import 'package:apnaclinic/core/preference/app_pref.dart';
import 'package:apnaclinic/core/preference/support_settings_local_model.dart';
import 'package:apnaclinic/core/preference/user_local_model.dart';
import 'package:apnaclinic/features/lab_test/domain/entities/lab_test_patient_details.dart';
import 'package:apnaclinic/features/lab_test/presentation/widgets/lab_test_add_patient_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAppPref implements AppPref {
  _FakeAppPref(this._user);
  final UserLocalModel? _user;

  @override
  UserLocalModel? getUserLocalModel() => _user;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  Widget buildTestWidget({LabTestPatientDetails? initial}) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: LabTestAddPatientSheetWidget(initial: initial),
      ),
    );
  }

  group('LabTestAddPatientSheetWidget Age Restriction and Validation', () {
    testWidgets('sanitizes initial age if greater than 99', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          initial: const LabTestPatientDetails(
            name: 'Ali Khan',
            age: '120',
            gender: 'male',
          ),
        ),
      );
      await tester.pumpAndSettle();

      final ageField = find.byWidgetPredicate(
        (w) => w is TextField && w.keyboardType == TextInputType.number,
      );
      expect(ageField, findsOneWidget);
      final ageTextField = tester.widget<TextField>(ageField);
      expect(ageTextField.controller?.text, '');
    });

    testWidgets('preserves initial age if <= 99', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          initial: const LabTestPatientDetails(
            name: 'Ali Khan',
            age: '45',
            gender: 'male',
          ),
        ),
      );
      await tester.pumpAndSettle();

      final ageField = find.byWidgetPredicate(
        (w) => w is TextField && w.keyboardType == TextInputType.number,
      );
      final ageTextField = tester.widget<TextField>(ageField);
      expect(ageTextField.controller?.text, '45');
    });

    testWidgets('restricts typed age to 2 digits and <= 99', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final ageField = find.byWidgetPredicate(
        (w) => w is TextField && w.keyboardType == TextInputType.number,
      );

      // Typing 100 should be rejected by MaxIntTextInputFormatter / LengthLimitingTextInputFormatter
      await tester.enterText(ageField, '100');
      await tester.pump();

      final ageTextField = tester.widget<TextField>(ageField);
      expect(ageTextField.controller?.text.length, lessThanOrEqualTo(2));
      final parsed = int.tryParse(ageTextField.controller?.text ?? '') ?? 0;
      expect(parsed <= 99, isTrue);

      // Entering valid age 99 works
      await tester.enterText(ageField, '99');
      await tester.pump();
      expect(tester.widget<TextField>(ageField).controller?.text, '99');
    });

    testWidgets('submit CTA is disabled when age is empty or 0 and enabled when 1..99', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final nameField = find.byWidgetPredicate(
        (w) => w is TextField && w.keyboardType == TextInputType.name,
      );
      final ageField = find.byWidgetPredicate(
        (w) => w is TextField && w.keyboardType == TextInputType.number,
      );

      await tester.enterText(nameField, 'Ahmad');
      await tester.pump();

      final ctaFinder = find.byType(FilledButton);
      expect(tester.widget<FilledButton>(ctaFinder).onPressed, isNull);

      // Age 0 should keep CTA disabled
      await tester.enterText(ageField, '0');
      await tester.pump();
      expect(tester.widget<FilledButton>(ctaFinder).onPressed, isNull);

      // Age 25 enables CTA
      await tester.enterText(ageField, '25');
      await tester.pump();
      expect(tester.widget<FilledButton>(ctaFinder).onPressed, isNotNull);

      // Age 99 keeps CTA enabled
      await tester.enterText(ageField, '99');
      await tester.pump();
      expect(tester.widget<FilledButton>(ctaFinder).onPressed, isNotNull);
    });

    group('labTestPatientFromAppPref', () {
      test('clamps age when DOB results in age > 99', () {
        final pref = _FakeAppPref(
          const UserLocalModel(
            firstName: 'Old',
            lastName: 'User',
            dateOfBirth: '1900-01-01',
            gender: 'male',
          ),
        );
        final details = labTestPatientFromAppPref(pref);
        expect(details, isNotNull);
        expect(details!.age, '');
      });

      test('sets age when DOB results in age <= 99', () {
        final nowYear = DateTime.now().year;
        final birthYear = nowYear - 30;
        final pref = _FakeAppPref(
          UserLocalModel(
            firstName: 'Young',
            lastName: 'User',
            dateOfBirth: '$birthYear-01-01',
            gender: 'female',
          ),
        );
        final details = labTestPatientFromAppPref(pref);
        expect(details, isNotNull);
        expect(details!.age, '30');
      });
    });
  });
}
