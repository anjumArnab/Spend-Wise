import 'package:flutter/material.dart';
import 'package:spend_wise/models/user.dart';
import 'package:spend_wise/screens/finance_plan.dart';
import 'package:spend_wise/screens/items_list_screen.dart';
import 'package:spend_wise/screens/transction_budget.dart';
import 'package:spend_wise/widgets/drawer.dart';
import 'package:spend_wise/screens/sign_up_screen.dart';
import 'package:spend_wise/screens/user_profile.dart';
import 'package:spend_wise/services/authentication.dart';
import 'package:spend_wise/services/cloud_store.dart';
import 'package:spend_wise/widgets/category_tab.dart';
import 'package:spend_wise/widgets/finance_card.dart';
import 'package:spend_wise/widgets/show_snack_bar.dart';
import 'package:spend_wise/widgets/transaction_item.dart';
import 'package:spend_wise/widgets/budget_progress.dart';

class HomePage extends StatefulWidget {
  final double totalIncome;
  const HomePage({super.key, required this.totalIncome});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Track the currently selected category
  String _selectedCategory = 'Transaction'; // Default selection
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _db = FirestoreService();

  UserModel? _userData;

  late Future<List<dynamic>> _transactions;
  late Future<List<dynamic>> _budgets;
  late Future<double> _totalAmount;
  double _calculatedBalance = 0.0;
  double _calculatedProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }


  void _loadData() {
    if (_authService.currentUser != null) {
      _transactions = _getAllPayments();
      _budgets = _getAllBudgets();
      _totalAmount = _getTotalAmount().then((amount) {
        double balance = widget.totalIncome - amount;
        double progress = widget.totalIncome == 0 ? 0 : amount / widget.totalIncome;

        setState(() {
          _calculatedBalance = balance;
          _calculatedProgress = progress;
        });

        return amount;
      });
      _getUserData();
    } else {
      _transactions = Future.value([]);
      _budgets = Future.value([]);
      _totalAmount = Future.value(0);
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

  Future<double> _getTotalAmount() async {
    if (_authService.currentUser != null) {
      return await _db.getTotalAmount(_authService.currentUser!.uid).first;
    } else {
      return 0.0;
    }
  }

  Future<void> _getUserData() async {
    if (_authService.currentUser != null) {
      _userData = await _db.getUserData(_authService.currentUser!.uid);
      setState(() {});
    }
  }

  Future<void> _signOut() async {
    await _authService.signOut(context);
    showSnackBar(context, 'Logged out successfully.');
    _navToSignUpScreen(context);
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

  void _navToFinancePlan(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FinancePlan()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check if user is authenticated
    bool isUserLoggedIn = _authService.currentUser != null;
    String userName = _userData?.fullName.split(" ").first ?? "User";
    
    return Scaffold(
      drawer: CustomDrawer(
        username: isUserLoggedIn ? _userData?.fullName : null,
        email: isUserLoggedIn ? _authService.currentUser!.email : null,
        profilePictureUrl: "",
        navToUserDetails: () => _navToUserDetails(context),
        onLogIn: () => _navToSignUpScreen(context),
        isLoggedIn: isUserLoggedIn, // Pass the authentication state
        isBackupEnabled: false,
        onBackupToggle: (bool value) {},
        onLogout: () => _signOut(),
        onExit: () {},
      ),
      appBar: AppBar(
        title: Text(
          "Welcome Back, $userName",
          style: const TextStyle(fontSize: 18),
        ),
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
            FutureBuilder<double>(
              future: _totalAmount,
              builder: (context, snapshot) {
                snapshot.data ?? 0.0;
                return FinanceCard(
                  onTap: () => _navToFinancePlan(context),
            balance: "\$${_calculatedBalance.toStringAsFixed(2)}",
            progressValue: _calculatedProgress,
            income: "\$${widget.totalIncome.toStringAsFixed(2)}",
            transaction: "\$${(widget.totalIncome - _calculatedBalance).toStringAsFixed(2)}",
          );
              }
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CategoryTab(
                  label: 'Transaction',
                  selectedCategory: _selectedCategory,
                  onTap: _setSelectedCategory,
                ),
                const SizedBox(width: 8),
                CategoryTab(
                  label: 'Budget',
                  selectedCategory: _selectedCategory,
                  onTap: _setSelectedCategory,
                ),
                const SizedBox(width: 8),
                CategoryTab(
                  label: 'Analysis',
                  selectedCategory: _selectedCategory,
                  onTap: _setSelectedCategory,
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
                  IconButton(
                    icon:
                        const Icon(Icons.arrow_forward_ios_outlined, size: 16),
                    onPressed: () =>
                        _navToItemsList(context, _selectedCategory),
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
      future: Future.wait(
          [_budgets, _transactions]), // Wait for both budgets and transactions
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error fetching data'));
        } else if (!snapshot.hasData || snapshot.data![0].isEmpty) {
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
              double progress =
                  budget.amount > 0 ? totalSpent / budget.amount : 0;
              progress =
                  progress.clamp(0.0, 1.0); // Ensure it is between 0 and 1

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