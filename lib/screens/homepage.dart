import 'package:flutter/material.dart';
import 'package:spend_wise/screens/Transction_budget.dart';
import 'package:spend_wise/screens/drawer.dart';
import 'package:spend_wise/screens/sign_up_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void _navToSignUpScreen(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }
  
  void _navToTransctionBudget(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TransctionBudget(title: title)),
    );
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
            onPressed: () => _navToTransctionBudget(context, 'Transction'),
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
            // Budgets section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "My Budgets",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(width: 250),
                IconButton(
                  onPressed: () => _navToTransctionBudget(context, 'Budget'),
                  icon: const Icon(Icons.add_circle_sharp, size: 20),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_forward_ios_sharp, size: 20),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Monthly Budget",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12)),
                            Text("\$2,000",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: double.infinity,
                          height: 6,
                          child: LinearProgressIndicator(
                            borderRadius: BorderRadius.circular(8),
                            value: 0.7,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Yearly Budget",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12)),
                            Text("\$24,000",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: double.infinity,
                          height: 6,
                          child: LinearProgressIndicator(
                            borderRadius: BorderRadius.circular(8),
                            value: 0.5,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            // Transaction list with Container
            const Text(
              "Transactions",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Number of transactions to display
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    margin: const EdgeInsets.only(bottom: 3), // Reduced margin
                    child: ListTile(
                      leading: const Icon(Icons.credit_card,
                          color: Colors.blue, size: 20), // Smaller icon
                      title: Text(
                        "Credit card payment $index",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      subtitle: const Text(
                        "Date: 2025-02-02 | Time: 10:00 AM",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      trailing: const Text(
                        "\$250.00",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
