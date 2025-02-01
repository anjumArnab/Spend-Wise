import 'package:flutter/material.dart';
import 'package:spend_wise/models/transaction.dart';
import 'package:spend_wise/screens/drawer.dart';
import 'package:intl/intl.dart';
import 'package:spend_wise/screens/showModalBottomSheet.dart';
import 'package:spend_wise/screens/signUpScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedButton = 0;
  String formattedDate = DateFormat('dd MMMM').format(DateTime.now());

  void _bottomSheet() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allows height customization
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)), // Rounded top corners
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


  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0), // Makes it square
              ),
            ),
          ),
          child: DatePickerDialog(
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          ),
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        formattedDate = DateFormat('dd MMMM').format(pickedDate);
      });
    }
  }

  final List<Transaction> transactions = [
    Transaction(date: DateTime(2024, 3, 18), category: "Shopping", description: "Clothes and watch", amount: 1101.00),
    Transaction(date: DateTime(2024, 3, 18), category: "Shopping", description: "Laptop", amount: 18025.00),
    Transaction(date: DateTime(2024, 3, 17), category: "Shopping", description: "Study table", amount: 10125.00),
    Transaction(date: DateTime(2024, 3, 17), category: "Shopping", description: "Laptop", amount: 40025.00),
    Transaction(date: DateTime(2024, 3, 16), category: "Shopping", description: "Paints and brush", amount: 826.00),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
        username: 'John Doe',
        email: "johndoe@gmail.com",
        profilePictureUrl: "",
        onLogIn: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SignUpScreen(),
            ),
          );
        },
        isBackupEnabled: false,
        onBackupToggle: (_) {},
        onLogout: () {},
        onExit: () {},
      ),
      appBar: AppBar(
        title: const Text(
          "\$17,500",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _bottomSheet,
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedButton = 0;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              minimumSize: const Size(0, 0),
                              foregroundColor: selectedButton == 0
                                  ? Colors.white
                                  : Color.fromRGBO(23, 59, 69, 1),
                              backgroundColor: selectedButton == 0
                                  ? Color.fromRGBO(23, 59, 69, 1)
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const SizedBox.expand(
                              child: Center(child: Text('Expenses')),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedButton = 1;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              minimumSize: const Size(0, 0),
                              foregroundColor: selectedButton == 1
                                  ? Colors.white
                                  : Color.fromRGBO(23, 59, 69, 1),
                              backgroundColor: selectedButton == 1
                                  ? Color.fromRGBO(23, 59, 69, 1)
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const SizedBox.expand(
                              child: Center(child: Text('Income')),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ElevatedButton(
                    onPressed: () => _selectDate(context),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      minimumSize: const Size(0, 0),
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromRGBO(23, 59, 69, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: SizedBox.expand(
                      child: Center(child: Text(formattedDate)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0), // Adds padding to screen edges
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, // Ensures equal spacing
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: Color.fromARGB(255, 225, 234, 205),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const SizedBox(
                              width: 75,
                              height: 75,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Day"),
                                  Text(
                                    "\$75",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: Color.fromARGB(255, 225, 234, 205),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const SizedBox(
                              width: 75,
                              height: 75,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Week"),
                                  Text(
                                    "\$450",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: Color.fromARGB(255, 225, 234, 205),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const SizedBox(
                              width: 75,
                              height: 75,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Month"),
                                  Text(
                                    "\$1322",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          final String formattedDate = DateFormat('d MMMM').format(transaction.date);
          Divider();
          final bool showDateHeader = index == 0 || transaction.date != transactions[index - 1].date;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showDateHeader)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Text(
                    formattedDate,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                  ),
                ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.purple[100],
                  child: Icon(Icons.shopping_cart, color: Colors.black),
                ),
                title: Text(transaction.category, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(transaction.description),
                trailing: Text(
                  "${transaction.amount.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
             // Divider(),
            ],
          );
        },
      ),
          ),
        ],
      ),
    );
  }
}
