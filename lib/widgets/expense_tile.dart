import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_expense_tracker_with_ai_assistant/models/expense_model.dart';

class ExpenseTile extends StatelessWidget {
  final ExpenseModel expense;

  const ExpenseTile({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.yMMMd().format(expense.date);
    final formattedAmount = NumberFormat.simpleCurrency().format(expense.amount);

    return Card(
      color: Colors.grey.shade100,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orangeAccent.shade100,
          child: Text(
            expense.category.substring(0, 1).toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(expense.title),
        subtitle: Text('$formattedDate • ${expense.category}'),
        trailing: Text(
          formattedAmount,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
      ),
    );
  }
}
