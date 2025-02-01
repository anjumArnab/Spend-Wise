import 'package:flutter/material.dart';

class Showmodalbottomsheet extends StatefulWidget {
  const Showmodalbottomsheet({super.key});

  @override
  State<Showmodalbottomsheet> createState() => _ShowmodalbottomsheetState();
}

class _ShowmodalbottomsheetState extends State<Showmodalbottomsheet> {
  Widget customSizeButton(String btnTxt, Color btnColor, Color txtColor,
      double width, double height) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          backgroundColor: btnColor.withOpacity(1),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          btnTxt,
          style: TextStyle(
            fontSize: btnTxt.length > 1
                ? 20
                : 35, // Adjust text size for longer texts
            color: txtColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          minimumSize: const Size(0, 55),
                          backgroundColor: Colors.blue[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Cash',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          minimumSize: const Size(0, 55),
                          backgroundColor: Colors.green[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Shopping',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Column(
                children: [
                  Text('Expense',
                      style: TextStyle(fontSize: 18, color: Colors.black)),
                  SizedBox(height: 10),
                  Text(
                    '\$25.00',
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  Text('Add comment...',
                      style: TextStyle(fontSize: 16, color: Colors.black)),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      for (var btn in ['1', '4', '7', '\$'])
                        Padding(
                          padding: const EdgeInsets.all(
                              5.0), // Adds spacing around each button
                          child: customSizeButton(
                              btn, Colors.grey.shade50, Colors.black, 70, 70),
                        ),
                    ],
                  ),
                  Column(
                    children: [
                      for (var btn in ['2', '5', '8', '0'])
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: customSizeButton(
                              btn, Colors.grey.shade50, Colors.black, 70, 70),
                        ),
                    ],
                  ),
                  Column(
                    children: [
                      for (var btn in ['3', '6', '9', ','])
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: customSizeButton(
                              btn, Colors.grey.shade50, Colors.black, 70, 70),
                        ),
                    ],
                  ),
                  Column(
                    children: [
                      for (var btn in ['Cal', 'Cal'])
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: customSizeButton(
                              btn, Colors.grey.shade50, Colors.black, 70, 70),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: customSizeButton(
                            "Tik", Colors.grey.shade50, Colors.black, 70, 140),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
