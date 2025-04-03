import 'package:flutter/material.dart';

class ExpenseBudget extends StatefulWidget {
  const ExpenseBudget({super.key});

  @override
  State<ExpenseBudget> createState() => _ExpenseBudgetState();
}

class _ExpenseBudgetState extends State<ExpenseBudget> {
  final List<String> _category = [
    'Housing', 'Utilities', 'Groceries', 'Toiletries & Hygiene', 'Apparel', 'Transportation', 'Healthcare',
    'Debt Payment', 'Dining Out', 'Entertainment', 'Subscriptions & Memberships', 'Personal Care', 'Emergency Fund',
    'Retirement Contributions', 'Education & Learning', 'Gifts & Donations', 'Insurance', 'Childcare & Education',
    'Pets', 'Miscellaneous Expenses'
  ];

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
        title: const Text("Expense Budget"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Wrap(
          spacing: 8, // Horizontal space between items
          runSpacing: 8, // Vertical space between lines
          children: [
            // Show all categories dynamically
            ..._category.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  item,
                  style: const TextStyle(fontSize: 15),
                ),
              );
            }),

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
