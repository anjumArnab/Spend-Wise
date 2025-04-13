import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget{
  final TextEditingController controller;
  final bool obsecureText;
  final Widget? suffixIcon;
  final String hintText;
  final TextInputType keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key, 
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    this.obsecureText = false,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap, 
  });

  @override
  Widget build (BuildContext context){
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        suffixIcon: suffixIcon,
      ),
      keyboardType: keyboardType,
      obscureText: obsecureText,
      readOnly: readOnly,
      onTap: onTap
    );
  }
}