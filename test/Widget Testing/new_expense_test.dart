import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/new_expense.dart';

void main() {
  group('NewExpense Widget Test', () {
    testWidgets('Widget renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NewExpense(
              onAddExpense: (Expense expense) {},
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsNWidgets(3));
      expect(find.byType(DropdownMenu<Category>), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Submitting expense data calls logic',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NewExpense(
              onAddExpense: (Expense expense) {},
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField).at(0), 'Test Title');
      await tester.enterText(find.byType(TextField).at(1), '20');
      await tester.enterText(find.byType(TextField).at(2), 'FOOD');

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
    });
  });
}
