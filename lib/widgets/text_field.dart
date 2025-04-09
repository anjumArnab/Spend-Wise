import 'package:flutter/material.dart';

Widget buildTextField({
  required TextEditingController controller,
  required String labelText,
  TextInputType keyboardType = TextInputType.text,
  bool obscureText = false,
  bool readOnly = false,
  Widget? suffixIcon,
  VoidCallback? onTap,
}) {
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
