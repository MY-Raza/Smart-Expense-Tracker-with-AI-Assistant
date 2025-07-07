import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_expense_tracker_with_ai_assistant/providers/expense_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class MonthlyTrendChart extends StatelessWidget {
  const MonthlyTrendChart({super.key});

  @override
  Widget build(BuildContext context) {
    final expenses = Provider.of<ExpenseProvider>(context).expenses;

    final Map<String, double> monthlyTotals = {};

    for (var e in expenses) {
      final monthKey = DateFormat('yyyy-MM').format(e.date);
      monthlyTotals[monthKey] = (monthlyTotals[monthKey] ?? 0) + e.amount;
    }

    final sortedKeys = monthlyTotals.keys.toList()..sort();
    final spots = sortedKeys.asMap().entries.map((entry) {
      final index = entry.key;
      final key = entry.value;
      return FlSpot(index.toDouble(), monthlyTotals[key]!);
    }).toList();

    return AspectRatio(
      aspectRatio: 1.7,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  final i = value.toInt();
                  if (i < 0 || i >= sortedKeys.length) return const SizedBox.shrink();
                  final month = DateFormat('MMM').format(DateTime.parse('${sortedKeys[i]}-01'));
                  return Text(month, style: const TextStyle(fontSize: 10));
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              spots: spots,
              barWidth: 3,
              color: Colors.indigo,
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
