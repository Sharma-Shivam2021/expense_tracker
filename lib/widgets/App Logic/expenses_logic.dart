import 'dart:convert';

import 'package:expense_tracker/models/expense.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpensesLogic {
  late SharedPreferences _preferences;

  Future<List<Expense>> loadExpenses() async {
    _preferences = await SharedPreferences.getInstance();
    final String expenseData = _preferences.getString('expenses') ?? '[]';
    final List<dynamic> decodeData = json.decode(expenseData);
    return decodeData.map((item) => Expense.fromJson(item)).toList();
  }

  Future<void> saveExpense(List<Expense> expenses) async {
    _preferences = await SharedPreferences.getInstance();
    final String expenseData = json.encode(expenses);
    await _preferences.setString('expenses', expenseData);
  }

  void addExpense(List<Expense> expenses, Expense expense) {
    expenses.add(expense);
  }

  void removeExpense(List<Expense> expenses, Expense expense) {
    expenses.remove(expense);
  }
}
