import 'package:flutter/material.dart';
import '../services/authentication.dart';
import '../widgets/border_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/show_snack_bar.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  // Initialize the auth service
  final FirebaseAuthService _authService = FirebaseAuthService();

  Future<void> _forgetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      showSnackBar(context, 'Please enter your email');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.sendPasswordResetEmail(email, context);
      showSnackBar(context, 'Password reset email sent. Check your inbox.');
    } catch (e) {
      showSnackBar(context, 'An unexpected error occurred.');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AuthSync'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Forget Password',
                style: TextStyle(fontSize: 30),
              ),
            ),
            const SizedBox(height: 15),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Email'),
            ),
            CustomTextField(
                controller: _emailController,
                hintText: 'youremail@mail.com',
                keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 30),
            BorderButton(
              text: _isLoading ? 'Sending...' : 'Send',
              onPressed: _isLoading
                  ? null
                  : () async {
                      await _forgetPassword();
                    },
            ),
          ],
        ),
      ),
    );
  }
}
