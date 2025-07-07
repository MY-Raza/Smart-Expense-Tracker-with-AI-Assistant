import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_expense_tracker_with_ai_assistant/providers/expense_provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ExpenseChart extends StatelessWidget {
  const ExpenseChart({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<ExpenseProvider>(context).chartData;

    final series = [
      charts.Series<Map<String, dynamic>, String>(
        id: 'Expenses',
        domainFn: (datum, _) => datum['category'],
        measureFn: (datum, _) => datum['amount'],
        data: data,
        labelAccessorFn: (datum, _) => '\$${datum['amount']}',
      )
    ];

    return SizedBox(
      height: 200,
      child: charts.PieChart<String>(
        series,
        animate: true,
        defaultRenderer: charts.ArcRendererConfig(
          arcRendererDecorators: [charts.ArcLabelDecorator()],
        ),
      ),
    );
  }
}
