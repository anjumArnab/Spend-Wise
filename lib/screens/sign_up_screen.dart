import 'package:flutter/material.dart';
import 'package:spend_wise/screens/homepage.dart';
import 'package:spend_wise/services/authentication.dart';
import 'package:spend_wise/utils/border_button.dart';
import 'package:spend_wise/utils/show_snack_bar.dart';
import 'package:spend_wise/utils/text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _isSignUp = true;

  // Initialize the auth service
  final FirebaseAuthService _authService = FirebaseAuthService();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _navToHomePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  // Function to handle sign up
  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final confirmPassword = _confirmPasswordController.text.trim();

      // Validate inputs
      if (email.isEmpty || password.isEmpty) {
        showSnackBar(context, 'Every field is required');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Check if in sign-up mode and validate password confirmation
      if (password != confirmPassword) {
        showSnackBar(context, 'Passwords do not match');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Create user with Firebase Auth - service now handles snackbar display
      final userCredential = await _authService.createUser(
        email: email,
        password: password,
        context: context,
      );

      if (userCredential != null) {
        // Send email verification - service now handles snackbar display
        final emailSent = await _authService.sendEmailVerification(context);

        if (emailSent && mounted) {
          _navToHomePage(context);
        }
      }
    } catch (e) {
      // This catch block will handle any non-FirebaseAuthException errors
      // that weren't caught in the service
      if (mounted) {
        showSnackBar(context, 'Error: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _logIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      // Validate inputs
      if (email.isEmpty || password.isEmpty) {
        showSnackBar(context, 'Email and password cannot be empty');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final userCredential = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
        context: context,
      );

      if (userCredential?.user == null) {
        showSnackBar(context, 'Sign-in failed. Please try again.');
        return;
      }

      // Refresh user to get updated verification status
      await userCredential!.user!.reload();
      if (userCredential.user!.emailVerified) {
        _navToHomePage(context);
      } else {
        final emailSent = await _authService.sendEmailVerification(context);
        if (emailSent) {
          showSnackBar(context, 'Please verify your email before continuing.');
        }
      }
    } catch (e) {
      showSnackBar(context, 'Error: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Get Started Now",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            const Text("Create an account or log in to explore our app",
                style: TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: buildToggleButton("Sign Up", true)),
                const SizedBox(width: 10),
                Expanded(child: buildToggleButton("Log In", false)),
              ],
            ),
            const SizedBox(height: 20),
            buildTextField(
                controller: _emailController,
                labelText: "Email",
                keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 10),
            buildTextField(
              controller: _passwordController,
              labelText: "Password",
              obscureText: !_isPasswordVisible,
              suffixIcon: buildVisibilityIcon(_isPasswordVisible, () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              }),
            ),
            const SizedBox(height: 10),
            if (_isSignUp)
              buildTextField(
                controller: _confirmPasswordController,
                labelText: "Confirm Password",
                obscureText: !_isConfirmPasswordVisible,
                suffixIcon: buildVisibilityIcon(_isConfirmPasswordVisible, () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                }),
              ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: 150,
                    height: 50,
                    child: BorderButton(
                      text: _isSignUp ? "Sign Up" : "Log In",
                      onPressed: () => _isSignUp ? _signUp() : _logIn(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget buildVisibilityIcon(bool isVisible, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
      onPressed: onPressed,
    );
  }

  Widget buildToggleButton(String text, bool isSignUp) {
    return BorderButton(
      text: text,
      onPressed: () => setState(() => _isSignUp = isSignUp),
    );
  }
}

/*
ElevatedButton(
      onPressed: () => setState(() => _isSignUp = isSignUp),
      style: ElevatedButton.styleFrom(
        backgroundColor: _isSignUp == isSignUp
            ? const Color.fromRGBO(23, 59, 69, 1)
            : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(text,
          style: TextStyle(
              color: _isSignUp == isSignUp ? Colors.white : Colors.black)),
    );*/