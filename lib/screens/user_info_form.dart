import 'package:flutter/material.dart';
import 'package:spend_wise/models/user.dart';
import 'package:spend_wise/screens/homepage.dart';
import 'package:spend_wise/services/authentication.dart';
import 'package:spend_wise/services/cloud_store.dart';
import 'package:spend_wise/widgets/border_button.dart';
import 'package:spend_wise/widgets/custom_text_field.dart';
import 'package:spend_wise/widgets/show_snack_bar.dart';

class UserInfoForm extends StatefulWidget {
  final UserModel? userData; // Accept user data from UserProfilePage
  const UserInfoForm({super.key, this.userData});

  @override
  State<UserInfoForm> createState() => _UserInfoFormState();
}

class _UserInfoFormState extends State<UserInfoForm> {
  final TextEditingController _fullname = TextEditingController();
  final TextEditingController _phone = TextEditingController();

  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _db = FirestoreService();

  // Define static lists for dropdown items
  static const List<String> genderOptions = ['Male', 'Female', 'Other'];
  static const List<String> bloodGroupOptions = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-'
  ];
  static const List<String> languageOptions = [
    'Bengali',
    'English',
    'Japanese'
  ];

  String? _selectedGender;
  String? _selectedBloodGroup;
  String? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    // Populate fields with existing user data if available
    if (widget.userData != null) {
      _fullname.text = widget.userData!.fullName;
      // If phone exists in your UserModel (seems like it's not in the provided model)
      // _phone.text = widget.userData!.phone;
      _selectedGender = widget.userData!.gender;
      _selectedBloodGroup = widget.userData!.bloodGroup;
      _selectedLanguage = widget.userData!.preferredLanguage;
    }
  }

  // Helper method to create dropdown buttons with consistent styling
  Widget _buildDropdownButton<T>({
    required List<T> items,
    required T? value,
    required void Function(T?) onChanged,
    required String hint,
  }) {
    return DropdownButton<T>(
      value: value,
      hint: Text(hint),
      items: items.map((T value) {
        return DropdownMenuItem<T>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  void _navToHomePage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }
  // Function to save user information

  Future<void> _saveUserInfo() async {
    // Add validation to ensure all required dropdowns are selected
    if (_selectedGender == null ||
        _selectedBloodGroup == null ||
        _selectedLanguage == null) {
      showSnackBar(context, 'Please select all dropdown values');
      return;
    }

    // Validate required text fields
    if (_fullname.text.isEmpty || _phone.text.isEmpty) {
      showSnackBar(context, 'Please fill in all required fields');
      return;
    }
    try {
      // Use the existing UID if updating an existing user
      String uid = widget.userData?.uid ?? _authService.currentUser!.uid;
      String email = widget.userData?.email ?? _authService.currentUser!.email!;
      
      UserModel user = UserModel(
        uid: uid,
        email: email,
        fullName: _fullname.text,
        gender: _selectedGender!,
        bloodGroup: _selectedBloodGroup!,
        preferredLanguage: _selectedLanguage!,
      );

      await _db.saveUserData(user, uid);
      
      // Go back to previous screen if editing, or to HomePage if new user
      if (widget.userData != null) {
        Navigator.pop(context);
      } else {
        _navToHomePage(context);
      }
    } catch (e) {
      showSnackBar(context, 'Error saving user data: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userData != null ? 'Edit Profile' : 'Spend Wise'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.userData != null 
                    ? 'Edit your information'
                    : 'Please enter information',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              Text(widget.userData != null
                  ? 'for ${widget.userData!.email}'
                  : 'for ${_authService.currentUser!.email}'),
              const SizedBox(height: 20),

              // Personal Information Section
              const Text(
                'Personal Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const Divider(),
              const SizedBox(height: 10),

              const Text('Full Name *'),
              CustomTextField(
                controller: _fullname,
                hintText: 'Enter your full name',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 15),

              // Dropdown Row
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  // Gender Dropdown
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Gender *'),
                      _buildDropdownButton<String>(
                        items: genderOptions,
                        value: _selectedGender,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedGender = newValue;
                          });
                        },
                        hint: 'Gender',
                      ),
                    ],
                  ),

                  // Blood Group Dropdown
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Blood Group *'),
                      _buildDropdownButton<String>(
                        items: bloodGroupOptions,
                        value: _selectedBloodGroup,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedBloodGroup = newValue;
                          });
                        },
                        hint: 'Blood Group',
                      ),
                    ],
                  ),

                  // Language Dropdown
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Language *'),
                      _buildDropdownButton<String>(
                        items: languageOptions,
                        value: _selectedLanguage,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedLanguage = newValue;
                          });
                        },
                        hint: 'Language',
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Contact Information Section
              const Text(
                'Contact Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ),
              const Divider(),
              const SizedBox(height: 10),

              const Text('Phone Number *'),
              CustomTextField(
                controller: _phone,
                hintText: 'Enter your phone number',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 15),

              BorderButton(
                text: widget.userData != null ? 'Update' : 'Save',
                onPressed: _saveUserInfo,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}