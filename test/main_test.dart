import 'package:expense_tracker/widgets/expenses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App should run and display Expenses widget',
      (widgetTester) async {
    await widgetTester.pumpWidget(const MaterialApp(home: Expenses()));
  });
  expect(find.byType(Expenses), findsOneWidget);
}
