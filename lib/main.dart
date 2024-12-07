import 'package:expense_tracker/features/home_screen/widgets/expenses.dart';
import 'package:expense_tracker/utilities/custom_theme.dart';
import 'package:expense_tracker/utilities/routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      darkTheme: CustomTheme.darkTheme,
      theme: CustomTheme.lightTheme,
      themeMode: ThemeMode.system,
      initialRoute: Expenses.routeName,
      routes: routes,
    ),
  );
}
