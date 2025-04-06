import 'package:flutter/material.dart';
import 'package:spend_wise/models/budget.dart';
import 'package:spend_wise/models/payment.dart';
import 'package:spend_wise/services/authentication.dart';
import 'package:spend_wise/services/cloud_store.dart';
import 'package:spend_wise/utils/budget_progress.dart';
import 'package:spend_wise/utils/transaction_item.dart';

class ItemsListScreen extends StatefulWidget {
  final String type; // 'Transaction' or 'Budget'
  const ItemsListScreen({super.key, required this.type});

  @override
  _ItemsListScreenState createState() => _ItemsListScreenState();
}

class _ItemsListScreenState extends State<ItemsListScreen> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _db = FirestoreService();
  late Future<List<dynamic>> _items;
  // For budget progress calculation
  late Future<Map<String, dynamic>> _combinedData;

  @override
  void initState() {
    super.initState();
    if (widget.type == 'Transaction') {
      _items = _getAllPayments();
    } else {
      // For budgets, we need both budgets and payments
      _combinedData = _getCombinedData();
    }
  }

  // Fetch Payments (Transaction items)
  Future<List<dynamic>> _getAllPayments() async {
    if (_authService.currentUser != null) {
      return await _db.getPayments(_authService.currentUser!.uid).first;
    } else {
      return [];
    }
  }

  // Fetch Budgets
  Future<List<dynamic>> _getAllBudgets() async {
    if (_authService.currentUser != null) {
      return await _db.getBudgets(_authService.currentUser!.uid).first;
    } else {
      return [];
    }
  }

  // Fetch both budgets and payments and combine them
  Future<Map<String, dynamic>> _getCombinedData() async {
    final budgetsData = await _getAllBudgets();
    final paymentsData = await _getAllPayments();

    return {
      'budgets': budgetsData,
      'payments': paymentsData,
    };
  }

  // Update a payment
  Future<void> _updatePayment(String paymentId, Payment payment) async {
    if (_authService.currentUser != null) {
      await _db.updatePayment(
          _authService.currentUser!.uid, paymentId, payment);
    }
  }

  // Update a budget item
  Future<void> _updateBudget(String budgetId, Budget budget) async {
    if (_authService.currentUser != null) {
      await _db.updateBudget(_authService.currentUser!.uid, budgetId, budget);
    }
  }

  // Delete a payment
  Future<void> _deletePayment(String paymentId) async {
    if (_authService.currentUser != null) {
      await _db.deletePayment(_authService.currentUser!.uid, paymentId);
    }
  }

  // Delete a budget item
  Future<void> _deleteBudget(String budgetId) async {
    if (_authService.currentUser != null) {
      await _db.deleteBudget(_authService.currentUser!.uid, budgetId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: widget.type == 'Transaction'
              ? const Text('Transactions')
              : const Text('Budgets')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: widget.type == 'Transaction'
            ? _buildTransactionsList()
            : _buildBudgetsList(),
      ),
    );
  }

  // Build transactions list view
  Widget _buildTransactionsList() {
    return FutureBuilder<List<dynamic>>(
      future: _items,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error fetching data'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No transactions available'));
        } else {
          List<dynamic> transactions = snapshot.data!;
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              var payment = transactions[index];
              return GestureDetector(
                onLongPress: () => _deletePayment(payment.id),
                child: TransactionItem(
                  category: payment.category,
                  method: payment.method,
                  date: payment.date,
                  time: payment.time,
                  amount: payment.amount,
                ),
              );
            },
          );
        }
      },
    );
  }

  // Build budgets list view with correct progress calculation
  Widget _buildBudgetsList() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _combinedData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error fetching data'));
        } else if (!snapshot.hasData ||
            (snapshot.data!['budgets'] as List).isEmpty) {
          return const Center(child: Text('No budgets available'));
        } else {
          List<dynamic> budgets = snapshot.data!['budgets'];
          List<dynamic> payments = snapshot.data!['payments'];

          return ListView.builder(
            itemCount: budgets.length,
            itemBuilder: (context, index) {
              var budget = budgets[index];

              // Calculate progress by matching payments with budget category
              double totalSpent = 0;
              for (var payment in payments) {
                if (payment.category == budget.category) {
                  totalSpent += payment.amount;
                }
              }

              // Calculate progress as a ratio of spent amount to budget amount
              double progress =
                  budget.amount > 0 ? totalSpent / budget.amount : 0;
              progress =
                  progress.clamp(0.0, 1.0); // Ensure it is between 0 and 1

              return GestureDetector(
                onLongPress: () => _deleteBudget(budget.id),
                child: BudgetProgress(
                  category: budget.category,
                  startDate: budget.startDate,
                  endDate: budget.endDate,
                  amount: budget.amount,
                  progress: progress,
                ),
              );
            },
          );
        }
      },
    );
  }
}
