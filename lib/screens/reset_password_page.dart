import 'package:flutter/material.dart';
import '../services/authentication.dart';
import '../widgets/border_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/show_snack_bar.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  // Initialize the auth service
  final FirebaseAuthService _authService = FirebaseAuthService();

  Future<void> _changePassword() async {
    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword != confirmPassword) {
      showSnackBar(context, 'Passwords do not match.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    bool success =
        await _authService.changePassword(oldPassword, newPassword, context);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      // Clear text fields
      _oldPasswordController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Spend Wise"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Reset Password',
                style: TextStyle(fontSize: 30),
              ),
            ),
            const SizedBox(height: 15),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Old Password'),
            ),
            CustomTextField(
                controller: _oldPasswordController,
                hintText: 'Old Password',
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
              child: Text('New Password'),
            ),
            CustomTextField(
                controller: _passwordController,
                hintText: 'New Password',
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
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Confirm Password'),
            ),
            CustomTextField(
                controller: _confirmPasswordController,
                hintText: 'Confirm Password',
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
            const SizedBox(height: 10),
            BorderButton(
              text: _isLoading ? 'Resetting...' : 'Reset',
              onPressed: _isLoading
                  ? null
                  : () async {
                      await _changePassword();
                    },
            ),
          ],
        ),
      ),
    );
  }
}
