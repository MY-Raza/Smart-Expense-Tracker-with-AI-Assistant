import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_expense_tracker_with_ai_assistant/screens/main_navigation_screen.dart';

import '../providers/auth_providers.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import 'forgot_password_screen.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');
    final savedPassword = prefs.getString('password');

    if (savedEmail != null && savedPassword != null) {
      emailController.text = savedEmail;
      passwordController.text = savedPassword;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Login',style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black
      ),),
      centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 40,),
            Text('Track Your Expenses with AI Assistant!!',style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontStyle: FontStyle.italic
            ),),
            SizedBox(height: 20,),
            CustomTextField(
              controller: emailController,
              labelText: 'Email',
            ),
            CustomTextField(
              controller: passwordController,
              labelText: 'Password',
              obscureText: true,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                );
              },
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : PrimaryButton(
              label: 'Sign In',
              onPressed: () async {
                setState(() => _isLoading = true);

                final success = await authProvider.signIn(
                  emailController.text,
                  passwordController.text,
                );
                Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen()));

                setState(() => _isLoading = false);

                if (!success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Login failed')),
                  );
                }
                // You may optionally navigate on success here
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignupScreen()),
                );
              },
              child: const Text("Don't have an account? Sign up",style: TextStyle(
                color: Colors.black,fontWeight: FontWeight.w400,fontSize: 14
              ),),
            ),
          ],
        ),
      ),
    );
  }
}
