import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spend_wise/widgets/show_snack_bar.dart';

/// A service class that handles Firebase Authentication operations.
class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Gets the current authenticated user.
  User? get currentUser => _auth.currentUser;

  /// Stream of authentication state changes.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Creates a new user with email and password.
  ///
  /// Returns a [UserCredential] if successful.
  /// Shows a snackbar with error message if failed.
  Future<UserCredential?> createUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, _getAuthErrorMessage(e));
      return null;
    } catch (e) {
      showSnackBar(context, 'An unexpected error occurred.');
      return null;
    }
  }

  /// Deletes the currently authenticated user.
  ///
  /// User must have recently authenticated to perform this action.
  /// Consider calling [reauthenticateUser] before this method.
  Future<bool> deleteUser(BuildContext context) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        showSnackBar(context, 'No user is currently signed in');
        return false;
      }
      await user.delete();
      return true;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, _getAuthErrorMessage(e));
      return false;
    } catch (e) {
      showSnackBar(context, 'An unexpected error occurred.');
      return false;
    }
  }

  /// Updates the email address of the currently authenticated user.
  ///
  /// Returns true if successful, false otherwise.
  /// User must have recently authenticated to perform this action.
  Future<bool> updateEmail(
      String newEmail, password, BuildContext context) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        showSnackBar(context, 'No user is currently signed in');
        return false;
      }

      final email = user.email;
      if (email == null) {
        showSnackBar(context, 'Unable to retrieve user email');
        return false;
      }
      bool reauthenticated = await reauthenticateUser(
        email: email,
        password: password,
        context: context,
      );

      // If re-authentication fails, return false
      if (!reauthenticated) {
        showSnackBar(context, 'Current password is incorrect');
        return false;
      }
      await user.verifyBeforeUpdateEmail(newEmail);
      showSnackBar(context, 'Email updated successfully');
      return true;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, _getAuthErrorMessage(e));
      return false;
    } catch (e) {
      showSnackBar(context, 'An unexpected error occurred.');
      return false;
    }
  }

  /// Changes the password of the currently authenticated user.
  ///
  /// Returns true if successful, false otherwise.
  /// User must have recently authenticated to perform this action.
  Future<bool> changePassword(
      String oldPassword, String newPassword, BuildContext context) async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        showSnackBar(context, 'No user is currently signed in');
        return false;
      }
      final email = user.email;
      if (email == null) {
        showSnackBar(context, 'Unable to retrieve user email');
        return false;
      }
      bool reauthenticated = await reauthenticateUser(
        email: email,
        password: oldPassword,
        context: context,
      );

      // If re-authentication fails, return false
      if (!reauthenticated) {
        showSnackBar(context, 'Current password is incorrect');
        return false;
      }
      await user.updatePassword(newPassword);
      showSnackBar(context, 'Password changed successfully');
      return true;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, _getAuthErrorMessage(e));
      return false;
    } catch (e) {
      showSnackBar(context, 'An unexpected error occurred.');
      return false;
    }
  }

  Future<void> sendPasswordResetEmail(
      String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showSnackBar(context, 'Password reset email sent. Check your inbox.');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, _getAuthErrorMessage(e));
    } catch (e) {
      showSnackBar(context, 'An unexpected error occurred.');
    }
  }

  /// Re-authenticates the current user using their email and password.
  ///
  /// Returns true if successful, false otherwise.
  /// This is useful before performing security-sensitive operations like
  /// changing password, email, or deleting the account.
  Future<bool> reauthenticateUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        showSnackBar(context, 'No user is currently signed in');
        return false;
      }

      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
      return true;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, _getAuthErrorMessage(e));
      return false;
    } catch (e) {
      showSnackBar(context, 'An unexpected error occurred.');
      return false;
    }
  }

  /// Sign out the currently authenticated user.
  ///
  /// Returns true if successful, false otherwise.
  Future<bool> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      showSnackBar(context, 'Failed to sign out');
      return false;
    }
  }

  /// Send email verification to the current user.
  ///
  /// Returns true if successful, false otherwise.
  Future<bool> sendEmailVerification(BuildContext context) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        showSnackBar(context, 'No user is currently signed in');
        return false;
      }
      await user.sendEmailVerification();
      showSnackBar(
          context, 'Verification email sent. Please check your inbox.');
      return true;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, _getAuthErrorMessage(e));
      return false;
    } catch (e) {
      showSnackBar(context, 'An unexpected error occurred.');
      return false;
    }
  }

  /// Check if the current user's email is verified.
  ///
  /// Returns false if no user is signed in.
  bool get isEmailVerified {
    final user = _auth.currentUser;
    return user?.emailVerified ?? false;
  }

  /// Reload the current user to get the latest user data.
  ///
  /// Returns true if successful, false otherwise.
  /// This is useful to refresh the email verification status.
  Future<bool> reloadUser(BuildContext context) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        showSnackBar(context, 'No user is currently signed in');
        return false;
      }
      await user.reload();
      return true;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, _getAuthErrorMessage(e));
      return false;
    } catch (e) {
      showSnackBar(context, 'An unexpected error occurred.');
      return false;
    }
  }

  /// Helper method to get user-friendly error messages from Firebase Auth exceptions.
  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Incorrect password provided.';
      case 'requires-recent-login':
        return 'This operation requires recent authentication. Please log in again before retrying.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many unsuccessful login attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      case 'network-request-failed':
        return 'Network error occurred. Please check your connection.';
      case 'no-user':
        return 'No user is currently signed in.';
      default:
        return e.message ?? 'An unknown error occurred.';
    }
  }

  /// Sign in with email and password
  ///
  /// Returns a [UserCredential] if successful, null otherwise.
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, _getAuthErrorMessage(e));
      return null;
    } catch (e) {
      showSnackBar(context, 'An unexpected error occurred.');
      return null;
    }
  }

  /// Send password reset email
  ///
  /// Returns true if successful, false otherwise.
  Future<bool> resetPassword(String email, BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      showSnackBar(
          context, 'Password reset email sent. Please check your inbox.');
      return true;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, _getAuthErrorMessage(e));
      return false;
    } catch (e) {
      showSnackBar(context, 'An unexpected error occurred.');
      return false;
    }
  }
}