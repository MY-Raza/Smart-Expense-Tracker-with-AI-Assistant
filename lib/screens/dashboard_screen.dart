import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_expense_tracker_with_ai_assistant/providers/expense_provider.dart';
import 'package:smart_expense_tracker_with_ai_assistant/widgets/category_filter.dart';
import 'package:smart_expense_tracker_with_ai_assistant/widgets/search_bar.dart';
import 'package:smart_expense_tracker_with_ai_assistant/widgets/expense_chart.dart';

import '../widgets/expense_tile.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final expenses = expenseProvider.expenses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          const CategoryFilter(),
          const SearchBarWidget(),
          const SizedBox(height: 8),
          const ExpenseChart(), // Pie chart by category
          const Divider(),
          Expanded(
            child: expenses.isEmpty
                ? const Center(child: Text('No expenses found.'))
                : ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                return ExpenseTile(expense: expenses[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
