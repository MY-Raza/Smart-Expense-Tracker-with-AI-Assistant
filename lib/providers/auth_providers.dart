import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_services.dart';

class AuthProvider with ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();
  User? _user;

  AuthProvider(){
    _user = _authService.currentUser;
  }
  User? get user => _user;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  Future<bool> signIn(String email, String password) async {
    try {
      _user = await _authService.signIn(email, password);
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> signUp(String email,String password) async{
    try{
      _user = await _authService.signUp(email, password);
      notifyListeners();
      return true;
    }catch(_){
      return false;
    }
  }

  void signOut() {
    _authService.signOut();
    _user = null;
    notifyListeners();
  }
}