import 'package:flutter/material.dart';

void showOTPDialog(
  BuildContext context, 
  TextEditingController codeController,
  VoidCallback onPressed) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text('Enter OTP'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: codeController,
              decoration: const InputDecoration(
                hintText: 'Enter OTP',
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color.fromRGBO(23, 59, 69, 1), // Neon Green
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Submit'),
          ),
        ],
      );
    },
  );
}
