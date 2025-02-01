import 'package:flutter/material.dart';

class Showmodalbottomsheet extends StatefulWidget {
  const Showmodalbottomsheet({super.key});

  @override
  State<Showmodalbottomsheet> createState() => _ShowmodalbottomsheetState();
}

class _ShowmodalbottomsheetState extends State<Showmodalbottomsheet> {
  Widget customSizeButton(
      String btnTxt, Color btnColor, Color txtColor, double width, double height) {
    return GestureDetector(
      onTap: () {
        // Handle button press here
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: btnColor.withOpacity(0.2), // Increased opacity for visibility
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.center,
        child: Text(
          btnTxt,
          style: TextStyle(
            fontSize: btnTxt.length > 1 ? 20 : 35, // Adjust text size for longer texts
            color: txtColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                        minimumSize: const Size(0, 50),
                        backgroundColor: const Color.fromRGBO(182, 255, 250, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Cash',
                        style: TextStyle(fontSize: 20, color: Colors.black),
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
                        minimumSize: const Size(0, 50),
                        backgroundColor: const Color.fromRGBO(186, 216, 182, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Shopping',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Column(
              children: [
                Text('Expense',
                    style: TextStyle(fontSize: 18, color: Colors.black),),
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
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    for (var btn in ['1', '4', '7', '\$'])
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: customSizeButton(
                            btn, const Color.fromRGBO(35, 72, 106, 1), Colors.black, 50, 50),
                      ),
                  ],
                ),
                Column(
                  children: [
                    for (var btn in ['2', '5', '8', '0'])
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: customSizeButton(
                            btn, const Color.fromRGBO(35, 72, 106, 1), Colors.black, 50, 50),
                      ),
                  ],
                ),
                Column(
                  children: [
                    for (var btn in ['3', '6', '9', ','])
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: customSizeButton(
                            btn, const Color.fromRGBO(35, 72, 106, 1), Colors.black, 50, 50),
                      ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: customSizeButton(
                          "Cal", const Color.fromRGBO(35, 72, 106, 1), Colors.black, 50, 50),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: customSizeButton(
                          "Del", const Color.fromRGBO(35, 72, 106, 1), Colors.black, 50, 50),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: customSizeButton(
                          "✔", const Color.fromRGBO(23, 59, 69, 1), Colors.black, 50, 100),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
