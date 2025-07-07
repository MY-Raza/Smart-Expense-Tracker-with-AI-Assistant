import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/expense_model.dart';

class ExpenseProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<ExpenseModel> _allExpenses = [];
  List<ExpenseModel> _filteredExpenses = [];
  double _total = 0.0;

  String _selectedCategory = 'All';
  String _searchQuery = '';

  List<ExpenseModel> get expenses => _filteredExpenses;
  double get total => _total;
  String get selectedCategory => _selectedCategory;

  List<String> get categories {
    final unique = _allExpenses.map((e) => e.category).toSet().toList();
    unique.sort();
    return unique;
  }

  Future<void> fetchExpenses() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final snapshot = await _firestore
        .collection('expenses')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .get();

    _allExpenses = snapshot.docs.map((doc) {
      final data = doc.data();
      return ExpenseModel(
        id: doc.id,
        title: data['title'] ?? '',
        category: data['category'] ?? '',
        amount: (data['amount'] ?? 0).toDouble(),
        date: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    }).toList();

    _total = _allExpenses.fold(0.0, (sum, e) => sum + e.amount);
    _applyFilters();
  }

  Future<void> addExpense(String title, String category, double amount) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final createdAt = Timestamp.now();

    final doc = await _firestore.collection('expenses').add({
      'userId': uid,
      'title': title,
      'category': category,
      'amount': amount,
      'createdAt': createdAt,
    });

    final newExpense = ExpenseModel(
      id: doc.id,
      title: title,
      category: category,
      amount: amount,
      date: createdAt.toDate(),
    );

    _allExpenses.insert(0, newExpense);
    _total += amount;

    _applyFilters();
  }

  Future<void> deleteExpense(String id) async {
    await _firestore.collection('expenses').doc(id).delete();
    final removed = _allExpenses.firstWhere((e) => e.id == id);
    _allExpenses.removeWhere((e) => e.id == id);
    _total -= removed.amount;
    _applyFilters();
  }

  /// 🔎 Filter by category
  void setCategoryFilter(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  void _applyFilters() {
    _filteredExpenses = _allExpenses.where((expense) {
      final matchesCategory = _selectedCategory == 'All' || expense.category == _selectedCategory;
      final matchesSearch = expense.title.toLowerCase().contains(_searchQuery);
      return matchesCategory && matchesSearch;
    }).toList();

    notifyListeners();
  }

  List<Map<String, dynamic>> get chartData {
    final Map<String, double> categoryMap = {};

    for (var expense in _filteredExpenses) {
      categoryMap.update(
        expense.category,
            (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }

    return categoryMap.entries
        .map((entry) => {'category': entry.key, 'amount': entry.value})
        .toList();
  }
}
