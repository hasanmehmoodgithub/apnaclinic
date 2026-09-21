import 'package:apnaclinic/core/l10n/app_localizations.dart';
import 'package:apnaclinic/features/payment/presentation/widgets/jazz_cash_payment_verification_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestWidget({
    String? title,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: JazzCashPaymentVerificationDialog(
          title: title,
        ),
      ),
    );
  }

  group('JazzCashPaymentVerificationDialog', () {
    testWidgets('renders all 3 instruction cards with loader, red status, and dialog structure',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Header title
      expect(
        find.text('Waiting for payment\nconfirmation'),
        findsOneWidget,
      );

      // Card 1: Status with circular progress loader & waiting for approval
      expect(find.text('Status'), findsOneWidget);
      expect(
        find.text('Waiting for JazzCash confirmation...'),
        findsOneWidget,
      );
      expect(find.text('Waiting for approval...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Card 2: For Jazz Users
      expect(find.text('For Jazz Users'), findsOneWidget);
      expect(
        find.text(
            'Please unlock your phone and you will get a PIN input prompt. Enter your MPIN to confirm the payment'),
        findsOneWidget,
      );

      // Card 3: For Other Networks
      expect(find.text('For Other Networks'), findsOneWidget);
      expect(
        find.text('Approve payment in your JazzCash App'),
        findsOneWidget,
      );
      expect(
        find.text(
            'Login to JazzCash App and tap on profile picture to open the menu'),
        findsOneWidget,
      );
      expect(
        find.text(
            'Then tap on “Payment Requests” and accept the payment request'),
        findsOneWidget,
      );
      expect(
        find.text('Then enter your MPIN to confirm the payment.'),
        findsOneWidget,
      );

      // Non-cancellable PopScope & Dialog
      expect(find.byType(Dialog), findsOneWidget);
      final popScope = tester.widget<PopScope>(find.byType(PopScope));
      expect(popScope.canPop, isFalse);
    });

    testWidgets('renders custom title when provided', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(title: 'Custom Payment Status'),
      );
      await tester.pump();

      expect(find.text('Custom Payment Status'), findsOneWidget);
    });
  });

  group('JazzCashPaymentVerificationDialogController', () {
    testWidgets('shows and closes non-cancellable verification dialog programmatically',
        (tester) async {
      const testId = 'test-loader-id';

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (innerContext) => ElevatedButton(
                onPressed: () {
                  JazzCashPaymentVerificationDialogController.show(
                    innerContext,
                    id: testId,
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Waiting for payment\nconfirmation'), findsNothing);

      // Open dialog
      await tester.tap(find.text('Open Dialog'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Waiting for payment\nconfirmation'), findsOneWidget);
      expect(find.byType(Dialog), findsOneWidget);

      // Close dialog programmatically
      JazzCashPaymentVerificationDialogController.close(testId);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Waiting for payment\nconfirmation'), findsNothing);
    });
  });
}
