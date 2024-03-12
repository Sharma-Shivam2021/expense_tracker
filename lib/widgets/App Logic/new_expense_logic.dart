import 'package:expense_tracker/models/expense.dart';

class NewExpenseLogic {
  void submitExpenseData({
    required String title,
    required double amount,
    required Category category,
    required DateTime selectedDate,
    required void Function(Expense expense) onAddExpense,
  }) {
    final expense = Expense(
      title: title,
      amount: amount,
      category: category,
      date: selectedDate,
    );

    onAddExpense(expense);
  }
}
