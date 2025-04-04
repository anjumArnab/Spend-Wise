// Create a new screen to display either transactions or budgets
import 'package:flutter/material.dart';
import 'package:spend_wise/utils/budget_progress.dart';
import 'package:spend_wise/utils/transaction_item.dart';

class ItemsListScreen extends StatelessWidget {
  final String type; // Either 'Transaction' or 'Budget'

  const ItemsListScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(type, style: const TextStyle(fontSize: 18)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: _buildListItems(),
        ),
      ),
    );
  }

  List<Widget> _buildListItems() {
    if (type == 'Transaction') {
      // Sample transaction data - you would typically get this from a database or state management
      return [
        const TransactionItem(
          category: "Groceries",
          method: "Credit Card",
          date: "2025-04-01",
          time: "14:30",
          amount: 89.75,
        ),
        const TransactionItem(
          category: "Entertainment",
          method: "Debit Card",
          date: "2025-04-02",
          time: "19:45",
          amount: 35.20,
        ),
        const TransactionItem(
          category: "Restaurant",
          method: "Cash",
          date: "2025-04-03",
          time: "12:15",
          amount: 42.50,
        ),
        const TransactionItem(
          category: "Shopping",
          method: "Credit Card",
          date: "2025-04-03",
          time: "16:20",
          amount: 127.99,
        ),
        const TransactionItem(
          category: "Utilities",
          method: "Bank Transfer",
          date: "2025-04-04",
          time: "09:10",
          amount: 145.32,
        ),
      ];
    } else if (type == 'Budget') {
      // Sample budget data
      return [
        const BudgetProgress(
          category: "Groceries",
          startDate: "2025-04-01",
          endDate: "2025-04-30",
          amount: 400.00,
          progress: 0.25, // 25% used
        ),
        const BudgetProgress(
          category: "Entertainment",
          startDate: "2025-04-01",
          endDate: "2025-04-30",
          amount: 200.00,
          progress: 0.18, // 18% used
        ),
        const BudgetProgress(
          category: "Restaurant",
          startDate: "2025-04-01",
          endDate: "2025-04-30",
          amount: 300.00,
          progress: 0.42, // 42% used
        ),
        const BudgetProgress(
          category: "Shopping",
          startDate: "2025-04-01",
          endDate: "2025-04-30",
          amount: 500.00,
          progress: 0.65, // 65% used
        ),
        const BudgetProgress(
          category: "Utilities",
          startDate: "2025-04-01",
          endDate: "2025-04-30",
          amount: 350.00,
          progress: 0.8, // 80% used
        ),
      ];
    }
    return []; // Return empty list if type is neither 'Transaction' nor 'Budget'
  }
}