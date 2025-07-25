import 'package:flutter/material.dart';
import 'package:smart_expense_tracker_with_ai_assistant/screens/add_expense_screen.dart';
import 'package:smart_expense_tracker_with_ai_assistant/screens/ai_chat_screen.dart';
import 'package:smart_expense_tracker_with_ai_assistant/screens/dashboard_screen.dart';
import 'package:smart_expense_tracker_with_ai_assistant/screens/analytics_screen.dart';
import 'package:smart_expense_tracker_with_ai_assistant/screens/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    AnalyticsScreen(),
    ChatScreen(),
    SettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.lightBlueAccent,
        fixedColor: Colors.lightBlueAccent,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
            backgroundColor: Colors.orangeAccent
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
              backgroundColor: Colors.orangeAccent
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'AI Assitant',
              backgroundColor: Colors.orangeAccent
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
              backgroundColor: Colors.orangeAccent
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        onPressed: () => Navigator.pushNamed(context, '/add-expense'),
        child: const Icon(Icons.add,color: Colors.blueAccent,),
      ),
    );
  }
}
