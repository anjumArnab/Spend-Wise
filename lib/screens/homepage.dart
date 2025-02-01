import 'package:flutter/material.dart';
import 'package:spend_wise/screens/drawer.dart';
import 'package:intl/intl.dart';
import 'package:spend_wise/screens/showModalBottomSheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedButton = 0;
  String formattedDate = DateFormat('dd MMMM').format(DateTime.now());

  void _bottomSheet(){
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (context) => const Showmodalbottomsheet());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
        username: 'John Doe',
        email: "johndoe@gmail.com",
        profilePictureUrl: "",
        isBackupEnabled: false,
        onBackupToggle: (_) {},
        onLogout: () {},
        onExit: () {},
      ),
      appBar: AppBar(
        title: const Text("\$17,500"),
        centerTitle: true,
        actions: [
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
                                  : Colors.black,
                              backgroundColor: selectedButton == 0
                                  ? Colors.black
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
                                  : Colors.black,
                              backgroundColor: selectedButton == 1
                                  ? Colors.black
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
                      backgroundColor: Colors.black,
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0), // Adds padding to screen edges
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensures equal spacing
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0), // Space around each container
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // Adds border radius
                          ),
                          child: const SizedBox(
                            width: 75,
                            height: 75,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Day"),
                                Text("\$52"),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const SizedBox(
                            width: 75,
                            height: 75,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Week"),
                                Text("\$322"),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const SizedBox(
                            width: 75,
                            height: 75,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Month"),
                                Text("\$1322"),
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
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return const ListTile(
                      leading: Icon(Icons.shopping_cart),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Shopping Item \${index + 1}",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                           Text("Description of the item"),
                        ],
                      ),
                      trailing: Text("\$\${(index + 1) * 10}"),
                    );
                  },
                ),
              ),
        ],
        
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _bottomSheet,
        child: const Icon(Icons.add),
      ),
      
    );
  }
}
