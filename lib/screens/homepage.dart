import 'package:flutter/material.dart';
import 'package:spend_wise/screens/drawer.dart';
import 'package:spend_wise/screens/showModalBottomSheet.dart';
import 'package:spend_wise/screens/signUpScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _bottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows height customization
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(20)), // Rounded top corners
      ),
      backgroundColor: Colors.white, // Background color of the modal
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9, // Opens at 50% of screen height
          minChildSize: 0.3, // Minimum height (30% of screen)
          maxChildSize: 0.9, // Maximum height (90% of screen)
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                controller: scrollController, // Enables scrolling
                child: const Showmodalbottomsheet(),
              ),
            );
          },
        );
      },
    );
  }

  void _login() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SignUpScreen(),
      ),
    );
  }

  void _drawer() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CustomDrawer(
          email: "",
          username: "",
          profilePictureUrl: "",
          onLogIn: _login,
          isBackupEnabled: false,
          onBackupToggle: (bool value) {},
          onLogout: () {},
          onExit: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Welcome Back, Annie", style: TextStyle(fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_sharp, size: 20),
            onPressed: _bottomSheet,
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
                color: const Color.fromRGBO(9, 18, 44, 1.0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _drawer,
                        child: const CircleAvatar(
                          radius: 15,
                          backgroundImage:
                              AssetImage("assets/images/annie.jpg"),
                        ),
                      ),
                      const Spacer(),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Balance",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14)),
                          Text("\$32,450.00",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
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
                      backgroundColor: Colors.white,
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
                          color: const Color.fromRGBO(226, 241, 231, 1.0),
                          borderRadius: BorderRadius.circular(8),
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
                          color: const Color.fromRGBO(226, 241, 231, 1.0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Expense",
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
                const Text("My Budgets",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_forward_ios_sharp, size: 20)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(226, 241, 231, 1.0),
                      borderRadius: BorderRadius.circular(8),
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
                            backgroundColor: Colors.white,
                            valueColor:
                                const AlwaysStoppedAnimation<Color>(Colors.black),
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
                      color: const Color.fromRGBO(226, 241, 231, 1.0),
                      borderRadius: BorderRadius.circular(8),
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
                            backgroundColor: Colors.white,
                            valueColor:
                               const  AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            // Transaction list with Card
            const Text(
              "Transactions",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
           const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Number of transactions to display
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: const EdgeInsets.only(bottom: 8), // Reduced margin
                    child: ListTile(
                      leading: const Icon(Icons.credit_card,
                          color: Colors.blue, size: 20), // Smaller icon
                      title: Text("Training Session #$index",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: const Text("Date: 2025-02-02 | Time: 10:00 AM",
                          style: TextStyle(
                              color: Colors.grey, fontSize: 12)),
                      trailing: const Text("\$250.00",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
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
