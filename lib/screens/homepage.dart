import 'package:flutter/material.dart';
import 'package:spend_wise/screens/items_list_screen.dart';
import 'package:spend_wise/screens/Transction_budget.dart';
import 'package:spend_wise/screens/drawer.dart';
import 'package:spend_wise/screens/sign_up_screen.dart';
import 'package:spend_wise/screens/user_profile.dart';
import 'package:spend_wise/services/authentication.dart';
import 'package:spend_wise/services/cloud_store.dart';
import 'package:spend_wise/widgets/transaction_item.dart';
import 'package:spend_wise/widgets/budget_progress.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Track the currently selected category
  String _selectedCategory = 'Transaction'; // Default selection
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _db = FirestoreService();

  late Future<List<dynamic>> _transactions;
  late Future<List<dynamic>> _budgets;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _transactions = _getAllPayments();
    _budgets = _getAllBudgets();
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

  void _navToUserDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
        username: "John Doe",
        email: "johndoe@gmail.com",
        profilePictureUrl: "",
        navToUserDetails: () => _navToUserDetails(context),
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
            icon: const Icon(Icons.add_circle_sharp, size: 20),
            onPressed: () => _navToTransactionBudget(context, 'Budget'),
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
              child: _selectedCategory == 'Transaction'
                  ? _buildTransactionsList()
                  : _selectedCategory == 'Budget'
                      ? _buildBudgetsList()
                      : const Center(child: Text('Analytics coming soon')),
            )
          ],
        ),
      ),
    );
  }

  // Build transactions list view
  Widget _buildTransactionsList() {
    return FutureBuilder<List<dynamic>>(
      future: _transactions,
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
              return TransactionItem(
                category: payment.category,
                method: payment.method,
                date: payment.date,
                time: payment.time,
                amount: payment.amount,
              );
            },
          );
        }
      },
    );
  }

  // Build budgets list view with correct progress calculation
  Widget _buildBudgetsList() {
    return FutureBuilder<List<List<dynamic>>>(
      future: Future.wait([_budgets, _transactions]), // Wait for both budgets and transactions
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error fetching data'));
        } else if (!snapshot.hasData || 
                  snapshot.data![0].isEmpty) {
          return const Center(child: Text('No budgets available'));
        } else {
          List<dynamic> budgets = snapshot.data![0];
          List<dynamic> transactions = snapshot.data![1];
          
          return ListView.builder(
            itemCount: budgets.length,
            itemBuilder: (context, index) {
              var budget = budgets[index];
              
              // Calculate progress by matching transactions with budget category
              double totalSpent = 0;
              for (var transaction in transactions) {
                if (transaction.category == budget.category) {
                  totalSpent += transaction.amount;
                }
              }
              
              // Calculate progress as a ratio of spent amount to budget amount
              double progress = budget.amount > 0 ? totalSpent / budget.amount : 0;
              progress = progress.clamp(0.0, 1.0); // Ensure it is between 0 and 1
              
              return BudgetProgress(
                category: budget.category,
                startDate: budget.startDate,
                endDate: budget.endDate,
                amount: budget.amount,
                progress: progress,
              );
            },
          );
        }
      },
    );
  }
}