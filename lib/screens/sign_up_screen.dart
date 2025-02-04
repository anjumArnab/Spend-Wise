import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:spend_wise/screens/homepage.dart';
import 'package:spend_wise/services/firbase_auth_methods.dart';
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
  bool _isSignUp = true;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dobController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  void signUpUser() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      showSnackbar(context, "Please enter both email and password");
      return;
    }

    await FirebaseAuthMethods(FirebaseAuth.instance).signUpWithEmailPassword(
      _emailController.text,
      _passwordController.text,
      context,
    );

    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  void logIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      showSnackbar(context, "Please enter both email and password");
      return;
    }

    bool isLoggedIn = await FirebaseAuthMethods(FirebaseAuth.instance)
        .logInWithEmailPassword(
            _emailController.text, _passwordController.text, context);

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
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
            const Text("Get Started Now", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            const Text("Create an account or log in to explore our app", style: TextStyle(fontSize: 14, color: Colors.grey)),
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
            if (_isSignUp) ...[
              Row(
                children: [
                  Expanded(child: buildTextField(controller: _firstNameController, labelText: "First Name")),
                  const SizedBox(width: 10),
                  Expanded(child: buildTextField(controller: _lastNameController, labelText: "Last Name")),
                ],
              ),
              const SizedBox(height: 10),
              buildTextField(
                controller: _dobController,
                labelText: "Birth Date",
                readOnly: true,
                suffixIcon: const Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
              ),
              const SizedBox(height: 10),
            ],
            buildTextField(controller: _emailController, labelText: "Email", keyboardType: TextInputType.emailAddress),
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
            SizedBox(
              width: 150,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSignUp ? signUpUser : logIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(23, 59, 69, 1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(_isSignUp ? "Sign Up" : "Log In", style: const TextStyle(color: Colors.white, fontSize: 16)),
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
    return ElevatedButton(
      onPressed: () => setState(() => _isSignUp = isSignUp),
      style: ElevatedButton.styleFrom(
        backgroundColor: _isSignUp == isSignUp ? const Color.fromRGBO(23, 59, 69, 1) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(text, style: TextStyle(color: _isSignUp == isSignUp ? Colors.white : Colors.black)),
    );
  }
}
