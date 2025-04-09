import 'package:flutter/material.dart';
import 'package:spend_wise/widgets/border_button.dart';
import 'package:spend_wise/widgets/custom_text_field.dart';

class UserInfoForm extends StatefulWidget {
  //final UserModel userData; // Accept user data from UserDetailsPage
  const UserInfoForm({super.key});

  @override
  State<UserInfoForm> createState() => _UserInfoFormState();
}

class _UserInfoFormState extends State<UserInfoForm> {
  final TextEditingController _fullname = TextEditingController();
  final TextEditingController _phone = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spend Wise'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Please enter information',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              Text('for '), // ${_authService.currentUser!.email}
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
                        hint: 'Select Gender',
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
                        hint: 'Select Blood Group',
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
                        hint: 'Select Language',
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Contact Information Section
              const Text(
                'Contact Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
                text: 'Save',
                onPressed: (){},
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}