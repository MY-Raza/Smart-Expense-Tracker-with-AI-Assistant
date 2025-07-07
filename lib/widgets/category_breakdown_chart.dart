import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_expense_tracker_with_ai_assistant/providers/expense_provider.dart';
import 'package:fl_chart/fl_chart.dart';

class CategoryBreakdownChart extends StatelessWidget {
  const CategoryBreakdownChart({super.key});

  @override
  Widget build(BuildContext context) {
    final chartData = Provider.of<ExpenseProvider>(context).chartData;

    if (chartData.isEmpty) {
      return const Text('No data available for chart.');
    }

    final colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];

    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          sections: chartData.asMap().entries.map((entry) {
            final i = entry.key;
            final data = entry.value;
            return PieChartSectionData(
              color: colors[i % colors.length],
              value: data['amount'],
              title: data['category'],
              radius: 60,
              titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            );
          }).toList(),
        ),
      ),
    );
  }
}
