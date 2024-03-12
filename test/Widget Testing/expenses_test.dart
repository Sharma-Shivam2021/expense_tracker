import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Expenses Widget Test', () {
    testWidgets('Initial UI', (widgetTester) async {
      await widgetTester.pumpWidget(
        const MaterialApp(home: Expenses()),
      );
      expect(find.text('Expense Tracker'), findsOneWidget);

      expect(find.text('No expenses Found. Start adding some'), findsOneWidget);
    });
    testWidgets('Open Add Expense Modal', (widgetTester) async {
      await widgetTester.pumpWidget(
        const MaterialApp(home: Expenses()),
      );

      await widgetTester.tap(find.byIcon(Icons.add));
      await widgetTester.pump();

      expect(find.text('Title'), findsOneWidget);
    });
    testWidgets('Expense List and Chart Display', (widgetTester) async {
      await widgetTester.pumpWidget(
        const MaterialApp(home: Expenses()),
      );
      expect(find.byType(Chart), findsOneWidget);
      expect(find.byType(ExpensesList), findsNothing);
    });
  });
}
