import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spend_wise/models/budget.dart';
import 'package:spend_wise/models/payment.dart';

class FirestoreService {
  // final FirebaseFirestore _db = FirebaseFirestore.instance;

  // References to the collections
  final CollectionReference paymentCollection = FirebaseFirestore.instance.collection('payments');
  final CollectionReference budgetCollection = FirebaseFirestore.instance.collection('budgets');

  // Add a Payment
  Future<void> addPayment(String uid, Payment payment) async {
    try {
      await paymentCollection.add({
        'userId': uid,
        ...payment.toJson(),
      });
    } catch (e) {
      print("Error adding payment: $e");
    }
  }

  // Add a Budget
  Future<void> addBudget(String uid, Budget budget) async {
    try {
      await budgetCollection.add({
        'userId': uid,
        ...budget.toJson(),
      });
    } catch (e) {
      print("Error adding budget: $e");
    }
  }

  // Get Payments by user
  Stream<List<Payment>> getPayments(String uid) {
    return paymentCollection
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Payment.fromJson(doc.data() as Map<String, dynamic>)).toList());
  }

  // Get Budgets by user
  Stream<List<Budget>> getBudgets(String uid) {
    return budgetCollection
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Budget.fromJson(doc.data() as Map<String, dynamic>)).toList());
  }

  // Optional: Update Budget
  Future<void> updateBudget(String docId, Budget budget) async {
    try {
      await budgetCollection.doc(docId).update(budget.toJson());
    } catch (e) {
      print("Error updating budget: $e");
    }
  }

  // Optional: Delete Payment
  Future<void> deletePayment(String docId) async {
    try {
      await paymentCollection.doc(docId).delete();
    } catch (e) {
      print("Error deleting payment: $e");
    }
  }
}
