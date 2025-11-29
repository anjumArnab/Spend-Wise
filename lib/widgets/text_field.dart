import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool readOnly;
  final Widget? suffixIcon;
  final VoidCallback? onTap;

  const AppTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.readOnly = false,
    this.suffixIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: labelText,
        border: const UnderlineInputBorder(),
        suffixIcon: suffixIcon,
      ),
      onTap: onTap,
    );
  }
}
