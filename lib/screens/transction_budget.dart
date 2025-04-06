import 'package:flutter/material.dart';
import 'package:spend_wise/models/budget.dart';
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
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

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
      amount: amountValue, id: '',
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

  Future<void> _addBudget(String category) async {
    final amount = _amountController.text.trim();
    final startDate = _startDateController.text.trim();
    final endDate = _endDateController.text.trim();

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
      id:'',
      category: category,
      amount: amountValue,
      startDate: startDate,
      endDate: endDate,
    );
    await _db.addBudget(_authService.currentUser!.uid, budget);

    // Clear the text fields after adding payment
    _amountController.clear();
    _startDateController.clear();
    _endDateController.clear();

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
                      child: widget.title == 'Transaction'
                          ? TextField(
                              controller: _paymentMethodController,
                              decoration: const InputDecoration(
                                labelText: "Payment Method",
                                border: OutlineInputBorder(),
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                const SizedBox(height: 10),

                // Date and Time Row
                Row(
                  children: [
                    Expanded(
                      child: widget.title == 'Transaction'
                          ? TextField(
                              controller: _dateController,
                              decoration: const InputDecoration(
                                labelText: "Date",
                                border: OutlineInputBorder(),
                              ),
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );

                                if (pickedDate != null) {
                                  // Format the date (optional, for better readability)
                                  String formattedDate =
                                      "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                                  setState(() {
                                    _dateController.text = formattedDate;
                                  });
                                }
                              },
                            )
                          : TextField(
                              controller: _startDateController,
                              decoration: const InputDecoration(
                                labelText: "Start Date",
                                border: OutlineInputBorder(),
                              ),
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );

                                if (pickedDate != null) {
                                  String formattedDate =
                                      "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                                  setState(() {
                                    _startDateController.text = formattedDate;
                                  });
                                }
                              },
                            ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: widget.title == 'Transaction'
                          ? TextField(
                              controller: _timeController,
                              decoration: const InputDecoration(
                                labelText: "Time",
                                border: OutlineInputBorder(),
                              ),
                              readOnly: true,
                              onTap: () async {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );

                                if (pickedTime != null) {
                                  DateTime.now();
                                  final formattedTime = TimeOfDay(
                                    hour: pickedTime.hour,
                                    minute: pickedTime.minute,
                                  ).format(context);
                                  setState(() {
                                    _timeController.text = formattedTime;
                                  });
                                }
                              },
                            )
                          : TextField(
                              controller: _endDateController,
                              decoration: const InputDecoration(
                                labelText: "End Date",
                                border: OutlineInputBorder(),
                              ),
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );

                                if (pickedDate != null) {
                                  String formattedDate =
                                      "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                                  setState(() {
                                    _endDateController.text = formattedDate;
                                  });
                                }
                              },
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                BorderButton(
                  text: "Add",
                  onPressed: widget.title == 'Transaction'
                      ? () => _addPayment(category)
                      : () => _addBudget(category),
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