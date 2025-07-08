import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_services.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();
  User? _user;

  AuthProvider() {
    _user = _authService.currentUser;
  }

  User? get user => _user;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ✅ Sign In
  Future<bool> signIn(String email, String password) async {
    try {
      _user = await _authService.signIn(email, password);
      notifyListeners();


      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
      await prefs.setString('password', password);

      return true;
    } catch (_) {
      return false;
    }
  }


  Future<bool> signUp(String email, String password) async {
    try {
      _user = await _authService.signUp(email, password);
      notifyListeners();


      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
      await prefs.setString('password', password);

      return true;
    } catch (_) {
      return false;
    }
  }

  void signOut() async {
    await _authService.signOut();
    _user = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');

    notifyListeners();
  }
}
