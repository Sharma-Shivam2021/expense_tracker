import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

enum Category { food, travel, leisure, work }

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff_rounded,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });

  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String getFormattedData() {
    return formatter.format(date);
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "amount": amount,
      "date": date.toIso8601String(),
      "category": category.index,
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      title: json["title"],
      amount: json["amount"].toDouble(),
      date: DateTime.parse(json["date"]),
      category: Category.values[json["category"]],
    );
  }
}

class ExpenseBucket {
  final Category category;
  final List<Expense> expenses;

  ExpenseBucket.forCategory(List<Expense> allExpense, this.category)
      : expenses = allExpense
            .where((expense) => expense.category == category)
            .toList();

  ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  double totalExpense() {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
