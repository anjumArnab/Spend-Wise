import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spend_wise/utils/show_otp_dialpg.dart';
import 'package:spend_wise/utils/show_snack_bar.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);

  // Email and Password Sign Up
  Future<void> signUpWithEmailPassword(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await verifyEmail(context);
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, e.message!);
    }
  }

  // Email verification
  Future<void> verifyEmail(BuildContext context) async {
    try {
      await _auth.currentUser!.sendEmailVerification();
      showSnackbar(context, 'Verification email sent.');
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, e.message!);
    }
  }

  // Email and Password Log In (now returns a boolean)
  Future<bool> logInWithEmailPassword(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if the user is logged in and email is verified
      if (userCredential.user != null && userCredential.user!.emailVerified) {
        showSnackbar(context, 'Logged in successfully.');
        return true;
      } else {
        showSnackbar(context, 'Please verify your email.');
        return false;
      }
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, e.message!);
      return false;
    }
  }

  // Phone Sign In remains unchanged
  Future<void> signInWithPhone(
    String phoneNumber,
    BuildContext context,
  ) async {
    try {
      TextEditingController codeController = TextEditingController();
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          showSnackbar(context, 'Phone number verified.');
        },
        verificationFailed: (FirebaseAuthException e) {
          showSnackbar(context, e.message!);
        },
        codeSent: (String verificationId, int? resendToken) {
          showOTPDialog(context, codeController, () async {
            PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: verificationId,
              smsCode: codeController.text.trim(),
            );
            await _auth.signInWithCredential(credential);
            Navigator.pop(context);
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          showSnackbar(context, 'Time out.');
        },
      );
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, e.message!);
    }
  }
}
