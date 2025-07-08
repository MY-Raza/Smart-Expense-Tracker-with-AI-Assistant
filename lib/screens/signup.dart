import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../providers/auth_providers.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomTextField(controller: emailController, labelText: 'Email'),
            CustomTextField(controller: passwordController, labelText: 'Password', obscureText: true),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Register',
              onPressed: () async {
                final success = await authProvider.signUp(
                  emailController.text,
                  passwordController.text,
                );
                if (!success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Signup failed')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
