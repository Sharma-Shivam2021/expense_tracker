import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/App%20Logic/new_expense_logic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('New Expense Logic', () {
    late NewExpenseLogic newExpenseLogic;
    setUp(() {
      newExpenseLogic = NewExpenseLogic();
    });

    test('Submit expense data adds a new expense', () {
      bool expenseAdded = false;

      void mockOnAddExpense(Expense expense) {
        expect(expense.title, 'Test');
        expect(expense.amount, 50.0);
        expect(expense.category, Category.food);
        expect(expense.date, DateTime(2022, 3, 8));

        expenseAdded = true;
      }

      newExpenseLogic.submitExpenseData(
        title: 'Test',
        amount: 50.0,
        category: Category.food,
        selectedDate: DateTime(2022, 3, 8),
        onAddExpense: mockOnAddExpense,
      );

      expect(expenseAdded, true);
    });
  });
}
