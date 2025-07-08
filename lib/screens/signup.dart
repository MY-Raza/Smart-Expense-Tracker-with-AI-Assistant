import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smart_expense_tracker_with_ai_assistant/screens/login.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../providers/auth_providers.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final nameController = TextEditingController();
    final dobController = TextEditingController();
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up',style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black
      ),),
      centerTitle: true,
      backgroundColor: Colors.orangeAccent,),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 40,),
              Text('Register to Track Your Expense With AI!!',style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontStyle: FontStyle.italic
              ),),
              SizedBox(height: 20,),
              CustomTextField(controller: nameController, labelText: 'Full Name'),
              TextField(
                controller: dobController,
                readOnly: true,
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    dobController.text = DateFormat('yyyy-MM-dd').format(picked);
                  }
                },
                decoration: InputDecoration(labelText: 'Date of Birth',border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)))),
              ),
              CustomTextField(controller: emailController, labelText: 'Email'),
              CustomTextField(controller: passwordController, labelText: 'Password', obscureText: true),
              const SizedBox(height: 20),
              PrimaryButton(
                label: 'Register',
                onPressed: () async {
                  print('hello');
                  final success = await authProvider.signUp(
                    emailController.text,
                    passwordController.text,
                    nameController.text,
                    dobController.text,
                  );
                  if (!success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Signup failed')),
                    );
                  }
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  );
                },
                child: const Text("Already have an Account? Log in",style: TextStyle(
                    color: Colors.black,fontWeight: FontWeight.w400,fontSize: 14
                ),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
