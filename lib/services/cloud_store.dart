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
    }
  }

  // Get all Payments by user
  Stream<List<Payment>> getPayments(String uid) {
    return _db
        .collection('payment')
        .doc(uid)
        .collection('transactions')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Payment.fromJson(doc.data())).toList());
  }

  // Get all Budgets by user
  Stream<List<Budget>> getBudgets(String uid) {
    return _db
        .collection('budget')
        .doc(uid)
        .collection('items')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Budget.fromJson(doc.data())).toList());
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
    }
  }
}
