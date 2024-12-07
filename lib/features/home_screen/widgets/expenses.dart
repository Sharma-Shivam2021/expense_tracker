import 'dart:convert';
import 'package:expense_tracker/features/balance_sheet/widgets/balance_sheet.dart';
import 'package:expense_tracker/features/home_screen/models/expense.dart';
import 'package:expense_tracker/features/home_screen/widgets/chart/chart.dart';
import 'package:expense_tracker/features/home_screen/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/features/home_screen/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  static String routeName = '/expenses';
  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpense = [];
  late SharedPreferences _preferences;

  @override
  void initState() {
    super.initState();
    _loadExpense();
  }

  Future<void> _loadExpense() async {
    _preferences = await SharedPreferences.getInstance();
    final String expenseData = _preferences.getString('expenses') ?? '[]';
    final List<dynamic> decodedData = json.decode(expenseData);
    setState(
      () {
        _registeredExpense.clear();
        _registeredExpense.addAll(
          decodedData.map(
            (item) => Expense.fromJson(item),
          ),
        );
      },
    );
  }

  Future<void> _saveExpense() async {
    final String expensesData = json.encode(_registeredExpense);
    await _preferences.setString('expenses', expensesData);
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
      _registeredExpense.add(expense);
      _saveExpense();
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpense.indexOf(expense);
    setState(() {
      _registeredExpense.remove(expense);
      _saveExpense();
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                if (expenseIndex >= 0 &&
                    expenseIndex <= _registeredExpense.length) {
                  _registeredExpense.insert(expenseIndex, expense);
                } else {
                  _registeredExpense.add(expense);
                }
              });
            }),
        content: const Text('Expense Deleted'),
      ),
    );
  }

  double getTotalExpenses() {
    return _registeredExpense.fold(0.0, (sum, expense) => sum + expense.amount);
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
      drawer: SafeArea(
        child: Drawer(
          child: Column(
            children: [
              DrawerHeader(
                child: Center(
                  child: Text(
                    'Expense Tracker',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).popAndPushNamed(
                        BalanceSheet.routeName,
                        arguments: getTotalExpenses(),
                      );
                    },
                    child: Text('Balance Sheet'),
                  ),
                ],
              ),
            ],
          ),
        ),
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
