import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/widgets/expenses.dart';

void main() {
  testWidgets('App should run and display Expenses widget',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Expenses(),
      ),
    );
    expect(find.byType(Expenses), findsOneWidget);
  });
}
