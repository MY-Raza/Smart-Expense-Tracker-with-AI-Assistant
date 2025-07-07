import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:smart_expense_tracker_with_ai_assistant/providers/ai_chat_provider.dart';
import 'package:smart_expense_tracker_with_ai_assistant/providers/auth_providers.dart';
import 'package:smart_expense_tracker_with_ai_assistant/providers/expense_provider.dart';
import 'package:smart_expense_tracker_with_ai_assistant/screens/add_expense_screen.dart';
import 'package:smart_expense_tracker_with_ai_assistant/screens/ai_chat_screen.dart';
import 'package:smart_expense_tracker_with_ai_assistant/screens/analytics_screen.dart';
import 'package:smart_expense_tracker_with_ai_assistant/screens/dashboard_screen.dart';
import 'package:smart_expense_tracker_with_ai_assistant/screens/login.dart';
import 'package:smart_expense_tracker_with_ai_assistant/screens/main_navigation_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_expense_tracker_with_ai_assistant/screens/settings_screen.dart';
import 'package:smart_expense_tracker_with_ai_assistant/screens/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
        ChangeNotifierProvider(create: (_) => AIChatProvider()),
      ],
      child: MaterialApp(
        title: 'Smart Expense Tracker',
        theme: ThemeData(primarySwatch: Colors.indigo),
        debugShowCheckedModeBanner: false,
        home: const RootPage(),
        routes: {
          '/main': (context) => const MainScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          '/analytics': (context) => const AnalyticsScreen(),
          '/add-expense': (context) => const AddExpenseScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/chat': (context) => const ChatScreen(),
        },// ⛳ Entry logic
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
          return const MainScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
