import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_expense_tracker_with_ai_assistant/providers/expense_provider.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExpenseProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search expenses...',
          prefixIcon: Icon(Icons.search,color: Colors.orangeAccent,),
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
        onChanged: provider.setSearchQuery,
      ),
    );
  }
}
