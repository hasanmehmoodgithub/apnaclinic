import 'package:apnaclinic/core/l10n/app_localizations.dart';
import 'package:apnaclinic/features/lab_test/presentation/widgets/lab_test_checkout_patient_form_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestWidget({
    required TextEditingController ageController,
    required TextEditingController nameController,
    required TextEditingController phoneController,
    required TextEditingController emergencyController,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: LabTestCheckoutPatientFormSectionWidget(
            theme: ThemeData.light(),
            nameController: nameController,
            phoneController: phoneController,
            ageController: ageController,
            emergencyController: emergencyController,
            gender: 'male',
            onGender: (_) {},
            isEditingPatientDetails: true,
            onToggleEdit: () {},
            showPatientDetails: true,
          ),
        ),
      ),
    );
  }

  group('LabTestCheckoutPatientFormSectionWidget Age Input', () {
    late TextEditingController ageController;
    late TextEditingController nameController;
    late TextEditingController phoneController;
    late TextEditingController emergencyController;

    setUp(() {
      ageController = TextEditingController();
      nameController = TextEditingController(text: 'John Doe');
      phoneController = TextEditingController(text: '03001234567');
      emergencyController = TextEditingController(text: '03007654321');
    });

    tearDown(() {
      ageController.dispose();
      nameController.dispose();
      phoneController.dispose();
      emergencyController.dispose();
    });

    testWidgets('restricts entered age to <= 99 and 2 digits', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          ageController: ageController,
          nameController: nameController,
          phoneController: phoneController,
          emergencyController: emergencyController,
        ),
      );
      await tester.pumpAndSettle();

      final ageField = find.byWidgetPredicate(
        (w) =>
            w is TextField &&
            w.controller == ageController &&
            w.keyboardType == TextInputType.number,
      );
      expect(ageField, findsOneWidget);

      // Attempt typing 120
      await tester.enterText(ageField, '120');
      await tester.pump();

      expect(ageController.text.length, lessThanOrEqualTo(2));
      final parsed = int.tryParse(ageController.text) ?? 0;
      expect(parsed <= 99, isTrue);

      // Type valid 99
      await tester.enterText(ageField, '99');
      await tester.pump();
      expect(ageController.text, '99');

      // Type valid 1
      await tester.enterText(ageField, '1');
      await tester.pump();
      expect(ageController.text, '1');
    });
  });
}
