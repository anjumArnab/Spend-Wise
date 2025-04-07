import 'package:flutter/material.dart';
import 'package:spend_wise/models/budget.dart';
import 'package:spend_wise/models/payment.dart';
import 'package:spend_wise/services/authentication.dart';
import 'package:spend_wise/services/cloud_store.dart';
import 'package:spend_wise/utils/transaction_budget_bottom_sheet.dart';

class TransctionBudget extends StatefulWidget {
  final String title;
  const TransctionBudget({required this.title, super.key});

  @override
  State<TransctionBudget> createState() => _TransctionBudgetState();
}

class _TransctionBudgetState extends State<TransctionBudget> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _db = FirestoreService();

  final List<String> _category = [
    'Housing',
    'Utilities',
    'Groceries',
    'Toiletries & Hygiene',
    'Apparel',
    'Transportation',
    'Healthcare',
    'Debt Payment',
    'Dining Out',
    'Entertainment',
    'Subscriptions & Memberships',
    'Personal Care',
    'Emergency Fund',
    'Retirement Contributions',
    'Education & Learning',
    'Gifts & Donations',
    'Insurance',
    'Childcare & Education',
    'Pets',
    'Miscellaneous Transctions'
  ];

  // Fixed to use paymentMethod key from data map
  Future<void> _addPayment(Map<String, String> data, String category) async {
    final amount = data['amount'] ?? '0';
    final paymentMethod = data['paymentMethod'] ?? '';
    final date = data['date'] ?? '';
    final time = data['time'] ?? '';

    // Convert the amount string to double
    double amountValue;
    try {
      amountValue = double.parse(amount);
    } catch (e) {
      // Handle invalid amount format
      print("Invalid amount format: $e");
      return;
    }

    // Create the Payment object with the explicitly passed category
    final payment = Payment(
      category: category,
      method: paymentMethod,
      date: date,
      time: time,
      amount: amountValue,
      id: '',
    );

    // Add the payment to the database
    await _db.addPayment(_authService.currentUser!.uid, payment);

    // Close the bottom sheet
    Navigator.pop(context);
  }

  // Modified to accept all data from the map and explicitly pass the category
  Future<void> _addBudget(Map<String, String> data, String category) async {
    final amount = data['amount'] ?? '0';
    final startDate = data['startDate'] ?? '';
    final endDate = data['endDate'] ?? '';

    // For debugging
    print("Budget data received: $data");

    // Convert the amount string to double
    double amountValue;
    try {
      amountValue = double.parse(amount);
    } catch (e) {
      // Handle invalid amount format
      print("Invalid amount format: $e");
      return;
    }

    final budget = Budget(
      id: '',
      category: category, // Use the explicitly passed category
      amount: amountValue,
      startDate: startDate,
      endDate: endDate,
    );
    await _db.addBudget(_authService.currentUser!.uid, budget);

    // Close the bottom sheet
    Navigator.pop(context);
  }

  void _showAddCategoryDialog() {
    TextEditingController categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Category"),
          content: TextField(
            controller: categoryController,
            decoration: const InputDecoration(
              hintText: "Enter category name",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (categoryController.text.trim().isNotEmpty) {
                  setState(() {
                    _category.add(categoryController.text.trim());
                  });
                }
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Wrap(
          spacing: 8, // Horizontal space between items
          runSpacing: 8, // Vertical space between lines
          children: [
            // Show all categories dynamically
            ..._category.map(
              (item) {
                return GestureDetector(
                  onTap: () {
                    TransactionBudgetBottomSheet.show(
                      context: context,
                      title: widget.title,
                      category: item,
                      onSubmit: (Map<String, String> data) {
                        // Pass both the data map and the category directly
                        if (widget.title == 'Transaction') {
                          _addPayment(data, item);
                        } else {
                          _addBudget(data, item);
                        }
                      },
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                );
              },
            ),

            // "+" button to add a new category
            GestureDetector(
              onTap: _showAddCategoryDialog,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: const Icon(Icons.add, size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
