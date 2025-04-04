import 'package:flutter/material.dart';
import 'package:spend_wise/models/payment.dart';
import 'package:spend_wise/services/authentication.dart';
import 'package:spend_wise/services/cloud_store.dart';
import 'package:spend_wise/utils/border_button.dart';

class TransctionBudget extends StatefulWidget {
  final String title;
  const TransctionBudget({required this.title, super.key});

  @override
  State<TransctionBudget> createState() => _TransctionBudgetState();
}

class _TransctionBudgetState extends State<TransctionBudget> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _paymentMethodController =
      TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

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

  // Modify _addPayment to accept a category parameter
  Future<void> _addPayment(String category) async {
    final amount = _amountController.text.trim();
    final paymentMethod = _paymentMethodController.text.trim();
    final date = _dateController.text.trim();
    final time = _timeController.text.trim();

    // Convert the amount string to double
    double amountValue;
    try {
      amountValue = double.parse(amount);
    } catch (e) {
      // Handle invalid amount format
      print("Invalid amount format: $e");
      return;
    }

    // Create the Payment object
    final payment = Payment(
      category: category,
      method: paymentMethod,
      date: date,
      time: time,
      amount: amountValue,
    );

    // Add the payment to the database
    await _db.addPayment(_authService.currentUser!.uid, payment);

    // Clear the text fields after adding payment
    _amountController.clear();
    _paymentMethodController.clear();
    _dateController.clear();
    _timeController.clear();

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

  void _addTransctionBudget(BuildContext context, String category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.title} - $category",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // Amount & Payment Method Row
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        decoration: const InputDecoration(
                          labelText: "Amount",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _paymentMethodController,
                        decoration: const InputDecoration(
                          labelText: "Payment Method",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                const SizedBox(height: 10),

                // Date and Time Row
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _dateController,
                        decoration: const InputDecoration(
                          labelText: "Date",
                          border: OutlineInputBorder(),
                        ),
                        readOnly: true,
                        onTap: () async {
                          await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _timeController,
                        decoration: const InputDecoration(
                          labelText: "Time",
                          border: OutlineInputBorder(),
                        ),
                        readOnly: true,
                        onTap: () async {
                          await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                BorderButton(
                  text: "Add",
                  onPressed: () => _addPayment(category),
                )
              ],
            ),
          ),
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
                  onTap: () => _addTransctionBudget(context, item),
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
