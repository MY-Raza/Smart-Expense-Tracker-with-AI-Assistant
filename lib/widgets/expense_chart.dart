import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_expense_tracker_with_ai_assistant/providers/expense_provider.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpenseChart extends StatelessWidget {
  const ExpenseChart({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<ExpenseProvider>(context).chartData;

    final total = data.fold(0.0, (sum, item) => sum + (item['amount'] as double));

    return SizedBox(
      height: 250,
      child: PieChart(
        PieChartData(
          sections: data.map((item) {
            final double amount = item['amount'];
            final String category = item['category'];
            final percentage = ((amount / total) * 100).toStringAsFixed(1);
            return PieChartSectionData(
              value: amount,
              title: "$percentage%",
              color: _getColorForCategory(category),
              radius: 60,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            );
          }).toList(),
          sectionsSpace: 2,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }

  Color _getColorForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Colors.orange;
      case 'transport':
        return Colors.blue;
      case 'entertainment':
        return Colors.purple;
      case 'bills':
        return Colors.red;
      case 'shopping':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
