import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});
  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  Category _selectedCategory = Category.food;
  DateTime? _selectedDate;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
              'Please make sure a valid title, amount, date and category was entered'),
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
    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    final isDarkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final width = constraints.maxWidth;
        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
              child: Column(
                children: [
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            maxLines: 1,
                            controller: _titleController,
                            maxLength: 50,
                            decoration: const InputDecoration(
                              label: Text('Title'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 25),
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: '\$ ',
                              label: Text('Amount'),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    TextField(
                      maxLines: 1,
                      controller: _titleController,
                      maxLength: 50,
                      decoration: const InputDecoration(
                        label: Text('Title'),
                      ),
                    ),
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: DropdownMenu<Category>(
                            width: MediaQuery.of(context).size.width * 0.3,
                            textStyle: const TextStyle(fontSize: 15),
                            inputDecorationTheme:
                                const InputDecorationTheme().copyWith(
                              contentPadding: const EdgeInsets.only(
                                  left: 1, right: 4, top: 5, bottom: 2),
                            ),
                            initialSelection: _selectedCategory,
                            onSelected: (category) {
                              setState(() {
                                _selectedCategory = category!;
                              });
                            },
                            dropdownMenuEntries: Category.values
                                .map(
                                  (category) => DropdownMenuEntry(
                                    style: MenuItemButton.styleFrom(
                                      foregroundColor: isDarkTheme
                                          ? Colors.deepPurple.shade50
                                          : Colors.black,
                                    ),
                                    value: category,
                                    label: category.name.toUpperCase(),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        const SizedBox(width: 25),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  _selectedDate == null
                                      ? 'No Date Selected'
                                      : formatter.format(_selectedDate!),
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  onPressed: _presentDatePicker,
                                  icon:
                                      const Icon(Icons.calendar_month_outlined),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: '\$ ',
                              label: Text('Amount'),
                            ),
                          ),
                        ),
                        // const SizedBox(width: 60),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  _selectedDate == null
                                      ? 'No Date Selected'
                                      : formatter.format(_selectedDate!),
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  onPressed: _presentDatePicker,
                                  icon:
                                      const Icon(Icons.calendar_month_outlined),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 30),
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 1,
                            ),
                            elevation: 0,
                          ),
                          onPressed: _submitExpenseData,
                          child: const Text('Save Expense'),
                        )
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: DropdownMenu<Category>(
                            width: MediaQuery.of(context).size.width * 0.3,
                            textStyle: const TextStyle(fontSize: 15),
                            inputDecorationTheme:
                                const InputDecorationTheme().copyWith(
                              contentPadding: const EdgeInsets.only(
                                  left: 1, right: 4, top: 5, bottom: 2),
                            ),
                            initialSelection: _selectedCategory,
                            onSelected: (category) {
                              setState(() {
                                _selectedCategory = category!;
                              });
                            },
                            dropdownMenuEntries: Category.values
                                .map(
                                  (category) => DropdownMenuEntry(
                                    style: MenuItemButton.styleFrom(
                                      foregroundColor: isDarkTheme
                                          ? Colors.deepPurple.shade50
                                          : Colors.black,
                                    ),
                                    value: category,
                                    label: category.name.toUpperCase(),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 1,
                              ),
                              elevation: 0,
                            ),
                            onPressed: _submitExpenseData,
                            child: const Text('Save Expense'),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
