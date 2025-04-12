import 'package:flutter/material.dart';
import 'package:spend_wise/models/user.dart';
import 'package:spend_wise/screens/reset_password_page.dart';
import 'package:spend_wise/screens/sign_up_screen.dart';
import 'package:spend_wise/services/authentication.dart';
import 'package:spend_wise/services/cloud_store.dart';
import 'package:spend_wise/widgets/border_button.dart';
import 'package:spend_wise/widgets/show_snack_bar.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _db = FirestoreService();
  UserModel? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  void _navToSignUpScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  void _navToChangeEmail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ResetPasswordPage(),
      ),
    );
  }

  void _navToChangePassword(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ResetPasswordPage(),
      ),
    );
  }

  Future<void> _getUserData() async {
    if (_authService.currentUser != null) {
      _userData = await _db.getUserData(_authService.currentUser!.uid);
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _deleteAccount() async {
    bool success = await _authService.deleteUser(context);
    if (success) {
      showSnackBar(context, 'Account deleted successfully.');
      _navToSignUpScreen(context);
    } else {
      showSnackBar(context, 'Failed to delete account. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () {},
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userData == null
              ? const Center(child: Text("No user data available."))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            const CircleAvatar(
                              radius: 50,
                              backgroundColor: Color(0xFF1976D2),
                              child: Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _userData!.fullName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                      _buildSectionHeader('Personal Information'),
                      _buildInfoRow('Full Name', _userData!.fullName),
                      _buildInfoRow('Email', _userData!.email),
                      _buildInfoRow('Gender', _userData!.gender),
                      _buildInfoRow('Blood Group', _userData!.bloodGroup),
                      _buildInfoRow(
                          'Preferred Language', _userData!.preferredLanguage),
                      const SizedBox(height: 24),
                      BorderButton(
                          text: "Change Email",
                          onVoidPressed: () => _navToChangeEmail(context)),
                      const SizedBox(height: 15),
                      BorderButton(
                          text: "Change Password",
                          onVoidPressed: () => _navToChangePassword(context)),
                      const SizedBox(height: 15),
                      BorderButton(
                          text: "Delete Account", onPressed: _deleteAccount),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const Divider(thickness: 1),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            value.isEmpty ? 'Not provided' : value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
