import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:smart_expense_tracker_with_ai_assistant/providers/auth_providers.dart';
import 'package:smart_expense_tracker_with_ai_assistant/providers/expense_provider.dart';
import 'package:smart_expense_tracker_with_ai_assistant/screens/dashboard_screen.dart';
import 'package:smart_expense_tracker_with_ai_assistant/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // 🔥 Initialize Firebase

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),     // 👤 Auth
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),  // 💰 Expense
      ],
      child: MaterialApp(
        title: 'Smart Expense Tracker',
        theme: ThemeData(primarySwatch: Colors.indigo),
        debugShowCheckedModeBanner: false,
        home: const RootPage(), // ⛳ Entry logic
      ),
    );
  }
}

// 👇 Automatically routes user based on login status
class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return StreamBuilder(
      stream: authProvider.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          return const DashboardScreen(); // ✅ User logged in
        } else {
          return const LoginScreen(); // 🚪 Show login screen
        }
      },
    );
  }
}
