import 'package:flutter/material.dart';
import '../services/authentication.dart';
import '../widgets/border_button.dart';
import '../widgets/custom_text_field.dart';

class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({super.key});

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  // Initialize the auth service
  final FirebaseAuthService _authService = FirebaseAuthService();

  void _changeEmail() async {
    final newEmail = _emailController.text.trim();
    final password = _passwordController.text.trim();
    setState(() {
      _isLoading = true;
    });
    bool success = await _authService.updateEmail(newEmail, password, context);
    if (success) {
      // Clear text fields
      _emailController.clear();
      Navigator.pop(context); // Navigate back on success
    }
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
                'Change email',
                style: TextStyle(fontSize: 30),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('for ${_authService.currentUser!.email}'),
            ),
            const SizedBox(height: 15),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Password'),
            ),
            CustomTextField(
                controller: _passwordController,
                hintText: 'Password',
                obsecureText: !_isPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                keyboardType: TextInputType.text),
            const SizedBox(height: 15),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('New Email'),
            ),
            CustomTextField(
                controller: _emailController,
                hintText: 'youremail@mail.com',
                keyboardType: TextInputType.text),
            const SizedBox(height: 10),
            BorderButton(
              text: _isLoading ? 'Changing...' : 'Change',
              onPressed: _isLoading
                  ? null
                  : () {
                      _changeEmail();
                    },
            ),
          ],
        ),
      ),
    );
  }
}
