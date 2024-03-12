import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/App Logic/expenses_logic.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final ExpensesLogic _expensesLogic = ExpensesLogic();
  late List<Expense> _registeredExpense = [];

  @override
  void initState() {
    super.initState();
    _loadExpense();
  }

  Future<void> _loadExpense() async {
    final List<Expense> loadedExpense = await _expensesLogic.loadExpenses();
    setState(
      () {
        _registeredExpense = loadedExpense;
      },
    );
  }

  Future<void> _saveExpense() async {
    await _expensesLogic.saveExpense(_registeredExpense);
  }

  void _openAddExpenseModal() {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (ctx) {
        return NewExpense(
          onAddExpense: _addExpense,
        );
      },
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _expensesLogic.addExpense(_registeredExpense, expense);
      _saveExpense();
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpense.indexOf(expense);
    setState(() {
      _expensesLogic.removeExpense(_registeredExpense, expense);
      _saveExpense();
    });
    // ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                if (expenseIndex >= 0 &&
                    expenseIndex <= _registeredExpense.length) {
                  _expensesLogic.addExpense(_registeredExpense, expense);
                  _saveExpense();
                } else {
                  _expensesLogic.addExpense(_registeredExpense, expense);
                  _saveExpense();
                }
              });
            }),
        content: const Text('Expense Deleted'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Widget mainContent = const Center(
      child: Text('No expenses Found. Start adding some'),
    );

    if (_registeredExpense.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpense,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(100, 49, 5, 206),
        centerTitle: false,
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseModal,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                const SizedBox(height: 10),
                Expanded(child: Chart(expenses: _registeredExpense)),
                Expanded(
                  child: mainContent,
                ),
              ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: _registeredExpense)),
                Expanded(
                  child: mainContent,
                ),
              ],
            ),
    );
  }
}
