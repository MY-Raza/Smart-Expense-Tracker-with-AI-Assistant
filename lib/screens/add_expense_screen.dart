import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_expense_tracker_with_ai_assistant/providers/expense_provider.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = 'General';

  final List<String> _categories = [
    'Food',
    'Transport',
    'Shopping',
    'Entertainment',
    'Bills',
    'Travel',
    'Health',
    'General'
  ];

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter title' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter amount';
                  if (double.tryParse(value) == null) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories
                    .map((cat) =>
                    DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save Expense'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await expenseProvider.addExpense(
                      _titleController.text,
                      _selectedCategory,
                      double.parse(_amountController.text),
                    );
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
