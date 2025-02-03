import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    }  on FirebaseAuthException catch (e){
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

  // Email and Password Log In
  Future<void> logInWithEmailPassword(
      String email, 
      String password,
      BuildContext context,
      ) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if(_auth.currentUser!.emailVerified){
        await verifyEmail(context);
        showSnackbar(context, 'Logged in successfully.');
      } else {
        showSnackbar(context, 'Please verify your email.');
      }
    } on FirebaseAuthException catch (e) {
      showSnackbar(context, e.message!);
    }
  }



}