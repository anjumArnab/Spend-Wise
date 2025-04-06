import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spend_wise/models/budget.dart';
import 'package:spend_wise/models/payment.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a Payment (multiple payments under each user)
  Future<void> addPayment(String uid, Payment payment) async {
    try {
      final paymentRef = _db
          .collection('payment')
          .doc(uid)
          .collection('transactions')
          .doc(); // auto-ID
      await paymentRef.set(payment.toJson());
    } catch (e) {
      print("Error adding payment: $e");
      rethrow; // Rethrow so UI can handle the error
    }
  }

  // Add a Budget (multiple budgets under each user)
  Future<void> addBudget(String uid, Budget budget) async {
    try {
      final budgetRef = _db
          .collection('budget')
          .doc(uid)
          .collection('items')
          .doc(); // auto-ID
      await budgetRef.set(budget.toJson());
    } catch (e) {
      print("Error adding budget: $e");
      rethrow; // Rethrow so UI can handle the error
    }
  }

  // Get all Payments by user (now includes document ID in each Payment object)
  Stream<List<Payment>> getPayments(String uid) {
    return _db
        .collection('payment')
        .doc(uid)
        .collection('transactions')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => 
              Payment.fromJson(doc.data(), docId: doc.id)
            ).toList());
  }

  // Get all Budgets by user (now includes document ID in each Budget object)
  Stream<List<Budget>> getBudgets(String uid) {
    return _db
        .collection('budget')
        .doc(uid)
        .collection('items')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => 
              Budget.fromJson(doc.data(), docId: doc.id)
            ).toList());
  }

  // Update a specific Payment
  Future<void> updatePayment(
      String uid, String paymentId, Payment payment) async {
    try {
      await _db
          .collection('payment')
          .doc(uid)
          .collection('transactions')
          .doc(paymentId)
          .update(payment.toJson());
    } catch (e) {
      print("Error updating payment: $e");
      rethrow; // Rethrow so UI can handle the error
    }
  }

  // Update a specific Budget item
  Future<void> updateBudget(String uid, String budgetId, Budget budget) async {
    try {
      await _db
          .collection('budget')
          .doc(uid)
          .collection('items')
          .doc(budgetId)
          .update(budget.toJson());
    } catch (e) {
      print("Error updating budget: $e");
      rethrow; // Rethrow so UI can handle the error
    }
  }

  // Delete a specific Payment
  Future<void> deletePayment(String uid, String paymentId) async {
    try {
      await _db
          .collection('payment')
          .doc(uid)
          .collection('transactions')
          .doc(paymentId)
          .delete();
    } catch (e) {
      print("Error deleting payment: $e");
      rethrow; // Rethrow so UI can handle the error
    }
  }

  // Delete a specific Budget
  Future<void> deleteBudget(String uid, String budgetId) async {
    try {
      await _db
          .collection('budget')
          .doc(uid)
          .collection('items')
          .doc(budgetId)
          .delete();
    } catch (e) {
      print("Error deleting budget: $e");
      rethrow; // Rethrow so UI can handle the error
    }
  }
}