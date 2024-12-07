import 'dart:convert';
import 'package:expense_tracker/features/balance_sheet/model/balance.dart';
import 'package:expense_tracker/features/balance_sheet/widgets/add_balance.dart';
import 'package:expense_tracker/features/home_screen/widgets/expenses_list/expenses_list.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../home_screen/models/expense.dart';

class BalanceSheet extends StatefulWidget {
  const BalanceSheet({super.key, required this.totalExpenses});
  final double totalExpenses;

  static String routeName = '/balance_sheet';
  @override
  State<BalanceSheet> createState() => _BalanceSheetState();
}

class _BalanceSheetState extends State<BalanceSheet> {
  Balance _balance = Balance(maxBudget: 0);
  final List<Expense> _registeredExpense = [];

  late SharedPreferences _preferences;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBalance().then((_) {
      _loadExpense().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    });
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

  Future<void> _loadBalance() async {
    try {
      _preferences = await SharedPreferences.getInstance();
      final balanceJson = _preferences.getString('maxBalance');

      if (balanceJson != null) {
        final balanceMap = json.decode(balanceJson) as Map<String, dynamic>;
        _balance = Balance.fromJson(balanceMap);
      } else {
        _balance = const Balance(maxBudget: 0);
      }

      setState(() {});

      _saveBalance();
    } catch (e) {
      debugPrint('Error loading balance: $e');
    }
  }

  void _addBalanceModal() {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (ctx) {
        return AddBalance(
          onAddBalance: _addBalance,
        );
      },
    );
  }

  void _addBalance(Balance balance) {
    setState(() {
      var newBalance =
          Balance(maxBudget: _balance.maxBudget + balance.maxBudget);
      _balance = newBalance;
      _saveBalance();
    });
  }

  void _saveBalance() async {
    final String balanceData = json.encode(_balance);
    await _preferences.setString('maxBalance', balanceData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(100, 49, 5, 206),
        centerTitle: false,
        title: const Text('Balance Sheet'),
        actions: [
          IconButton(
            onPressed: _addBalanceModal,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'Current Balance',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          '₹ ${_balance.maxBudget - widget.totalExpenses.toInt()}',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(),
                  ExpensesList(
                    expenses: _registeredExpense,
                    onRemoveExpense: (_) {},
                  ),
                ],
              ),
            ),
    );
  }
}
