import 'package:flutter/material.dart';
import 'package:spend_wise/screens/items_list_screen.dart';
import 'package:spend_wise/screens/Transction_budget.dart';
import 'package:spend_wise/screens/drawer.dart';
import 'package:spend_wise/screens/sign_up_screen.dart';
import 'package:spend_wise/utils/transaction_item.dart';
import 'package:spend_wise/utils/budget_progress.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Track the currently selected category
  String _selectedCategory = 'Transaction'; // Default selection

  void _navToSignUpScreen(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }

  void _navToTransactionBudget(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TransctionBudget(title: title)),
    );
  }

  // Navigate to ItemsListScreen
  void _navToItemsList(BuildContext context, String type) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ItemsListScreen(type: type)),
    );
  }

  // Change the selected category
  void _setSelectedCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  // Get list of items based on selected category
  List<Widget> _getItems() {
    if (_selectedCategory == 'Transaction') {
      // Return transaction items (showing fewer items on the homepage)
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
      ];
    } else if (_selectedCategory == 'Budget') {
      // Return budget progress items (showing fewer items on the homepage)
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
      ];
    } else {
      // For Analysis, we could return a placeholder or analysis widgets
      return [
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(3),
          ),
          child: const Center(
            child: Text(
              "Analysis functionality coming soon",
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
        username: "John Doe",
        email: "johndoe@gmail.com",
        profilePictureUrl: "",
        onLogIn: () => _navToSignUpScreen(context),
        isBackupEnabled: false,
        onBackupToggle: (bool value) {},
        onLogout: () {},
        onExit: () {},
      ),
      appBar: AppBar(
        title:
            const Text("Welcome Back, Annie", style: TextStyle(fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_sharp, size: 20),
            onPressed: () => _navToTransactionBudget(context, 'Transaction'),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, size: 20),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundImage: AssetImage("assets/images/annie.jpg"),
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Balance", style: TextStyle(fontSize: 14)),
                          Text("\$32,450.00", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    height: 6,
                    child: LinearProgressIndicator(
                      borderRadius: BorderRadius.circular(8),
                      value: 0.7,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color.fromRGBO(33, 33, 33, 1.0)),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 130,
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Income",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12)),
                              SizedBox(height: 4),
                              Text("\$1,07,590",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 130,
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Transaction",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12)),
                              SizedBox(height: 4),
                              Text("\$75,140",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _setSelectedCategory('Transaction'),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedCategory == 'Transaction'
                              ? Colors.blueGrey
                              : Colors.black,
                          width: _selectedCategory == 'Transaction' ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(3),
                        color: _selectedCategory == 'Transaction'
                            ? Colors.blue.withOpacity(0.1)
                            : null,
                      ),
                      child: const Center(
                        child: Text(
                          "Transaction",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _setSelectedCategory('Budget'),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedCategory == 'Budget'
                              ? Colors.blueGrey
                              : Colors.black,
                          width: _selectedCategory == 'Budget' ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(3),
                        color: _selectedCategory == 'Budget'
                            ? Colors.blue.withOpacity(0.1)
                            : null,
                      ),
                      child: const Center(
                        child: Text(
                          "Budget",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _setSelectedCategory('Analysis'),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedCategory == 'Analysis'
                              ? Colors.blueGrey
                              : Colors.black,
                          width: _selectedCategory == 'Analysis' ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(3),
                        color: _selectedCategory == 'Analysis'
                            ? Colors.blue.withOpacity(0.1)
                            : null,
                      ),
                      child: const Center(
                        child: Text(
                          "Analysis",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Display category title
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Text(
                    _selectedCategory,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      // Navigate to ItemsListScreen with current category
                      _navToItemsList(context, _selectedCategory);
                    },
                    child: const Text(
                      "See All",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Display items based on selected category
            Expanded(
              child: ListView(
                children: _getItems(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}