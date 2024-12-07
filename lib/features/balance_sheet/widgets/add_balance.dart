import 'package:flutter/material.dart';

import '../model/balance.dart';

class AddBalance extends StatefulWidget {
  const AddBalance({super.key, required this.onAddBalance});

  final void Function(Balance balance) onAddBalance;

  @override
  State<AddBalance> createState() => _AddBalanceState();
}

class _AddBalanceState extends State<AddBalance> {
  final TextEditingController _balanceController = TextEditingController();

  void _submitBalance() {
    final enteredBalance = int.tryParse(_balanceController.text);
    final validBalance = enteredBalance == null || enteredBalance <= 0;
    if (_balanceController.text.trim().isEmpty || validBalance) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            'Invalid Input',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: const Text('Please make sure a valid amount is entered'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            )
          ],
        ),
      );
      return;
    }
    widget.onAddBalance(
      Balance(maxBudget: int.parse(_balanceController.text)),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.25,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Add Balance'),
                SizedBox(height: 10),
                TextField(
                  controller: _balanceController,
                  decoration: InputDecoration(
                    prefixText: "₹",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(100, 50),
                    ),
                    onPressed: _submitBalance,
                    child: Text('Add'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
