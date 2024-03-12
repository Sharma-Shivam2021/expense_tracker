import 'package:expense_tracker/widgets/expenses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:expense_tracker/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Expense Tracker Integration Test ', () {
    testWidgets(
      'When User Enters Wrong Input Then Show Alert Dialog ',
      (widgetTester) async {
        app.main();
        await widgetTester.pumpAndSettle();

        await widgetTester.tap(find.byIcon(Icons.add));
        await widgetTester.pumpAndSettle();

        await widgetTester.tap(find.text('Save Expense'));
        await widgetTester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);
      },
    );
    testWidgets(
      'When User Enters Correct Input Then Expenses Screen ',
      (widgetTester) async {
        app.main();
        await widgetTester.pumpAndSettle();

        await widgetTester.tap(find.byIcon(Icons.add));
        await widgetTester.pumpAndSettle();

        await widgetTester.enterText(find.byType(TextField).at(0), 'text');
        await widgetTester.enterText(find.byType(TextField).at(1), '20');

        await widgetTester.tap(find.byIcon(Icons.calendar_month_outlined));
        await widgetTester.pumpAndSettle();

        await widgetTester.tap(find.text('OK'));
        await widgetTester.pumpAndSettle();

        await widgetTester.tap(find.text('Save Expense'));
        await widgetTester.pumpAndSettle();

        expect(find.byType(Expenses), findsOneWidget);
      },
    );
  });
}
