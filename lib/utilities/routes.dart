import 'package:flutter/material.dart';

import '../features/balance_sheet/widgets/balance_sheet.dart';
import '../features/home_screen/widgets/expenses.dart';

Map<String, Widget Function(BuildContext)> routes = {
  Expenses.routeName: (context) => const Expenses(),
  BalanceSheet.routeName: (context) => BalanceSheet(
        totalExpenses: ModalRoute.of(context)!.settings.arguments as double,
      ),
};
