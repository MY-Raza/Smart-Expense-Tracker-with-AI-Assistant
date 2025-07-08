import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_expense_tracker_with_ai_assistant/providers/expense_provider.dart';
import 'package:pie_chart/pie_chart.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final chartData = expenseProvider.chartData;
    final total = expenseProvider.total;
    final selectedRange = expenseProvider.selectedRange;

    Map<String, double> pieData = {
      for (var item in chartData)
        item['category']: (item['amount'] as double)
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20,),
            Text('Analyse Your Expenses!!',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 18),),
            SizedBox(height: 30,),
            ToggleButtons(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderWidth: 5,
              fillColor: Colors.transparent,
              selectedColor: Colors.blueAccent,
              selectedBorderColor: Colors.orangeAccent,
              disabledBorderColor: Colors.grey,
              isSelected: [
                selectedRange == DateRangeFilter.weekly,
                selectedRange == DateRangeFilter.monthly,
                selectedRange == DateRangeFilter.yearly,
                selectedRange == DateRangeFilter.all,
              ],
              onPressed: (index) {
                final filters = [
                  DateRangeFilter.weekly,
                  DateRangeFilter.monthly,
                  DateRangeFilter.yearly,
                  DateRangeFilter.all,
                ];
                expenseProvider.setDateRangeFilter(filters[index]);
              },
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('Weekly'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('Monthly'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('Yearly'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('All'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Chart For Your Expenses',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.black),),
            SizedBox(height: 20,),
            if (pieData.isEmpty)
              const Text('No data for selected range.')
            else
              PieChart(
                dataMap: pieData,
                chartRadius: MediaQuery.of(context).size.width / 2.2,
                legendOptions: const LegendOptions(showLegendsInRow: false),
                chartValuesOptions: const ChartValuesOptions(
                  showChartValuesInPercentage: true,
                  showChartValues: true,
                ),
              ),
            const SizedBox(height: 16),
            Text(
              'Total Expenses: Rs. ${total.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
