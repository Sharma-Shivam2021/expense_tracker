import 'dart:convert';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/App%20Logic/expenses_logic.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ExpensesLogic', () {
    late ExpensesLogic expensesLogic;
    late SharedPreferences preferences;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      preferences = await SharedPreferences.getInstance();
      expensesLogic = ExpensesLogic();
    });

    test('Load expenses returns a list of Expense objects', () async {
      final List<Expense> loadedExpense = await expensesLogic.loadExpenses();
      expect(loadedExpense, isA<List<Expense>>());
    });

    test('Save expenses saves the provided list in SharedPreferences',
        () async {
      final List<Expense> testExpense = [
        Expense(
            title: 'title',
            amount: 10,
            date: DateTime.now(),
            category: Category.work),
        Expense(
            title: 'title2',
            amount: 20,
            date: DateTime.now(),
            category: Category.travel),
      ];
      await expensesLogic.saveExpense(testExpense);

      final String saveExpenseData = preferences.getString('expenses') ?? '[]';
      final List<dynamic> decodedData = json.decode(saveExpenseData);
      final List<Expense> savedExpenses =
          decodedData.map((e) => Expense.fromJson(e)).toList();
      expect(
        savedExpenses.map((e) => e.toJson()),
        equals(testExpense.map((e) => e.toJson())),
      );
    });

    test('Add expense add an expense to the list', () async {
      final List<Expense> expenses = [];
      final Expense testExpense = Expense(
        title: 'title',
        amount: 10,
        date: DateTime.now(),
        category: Category.work,
      );

      expensesLogic.addExpense(expenses, testExpense);

      expect(expenses, contains(testExpense));
    });

    test('Remove expense removes an expense from the list', () async {
      final Expense testExpense = Expense(
        title: 'title',
        amount: 10,
        date: DateTime.now(),
        category: Category.work,
      );
      final List<Expense> expenses = [testExpense];
      expensesLogic.removeExpense(expenses, testExpense);
      expect(expenses, isNot(contains(testExpense)));
    });
  });
}
