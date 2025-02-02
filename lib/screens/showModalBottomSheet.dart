import 'package:flutter/material.dart';

class Showmodalbottomsheet extends StatefulWidget {
  const Showmodalbottomsheet({super.key});

  @override
  State<Showmodalbottomsheet> createState() => _ShowmodalbottomsheetState();
}

class _ShowmodalbottomsheetState extends State<Showmodalbottomsheet> {
  List<String> finance = ['Cash', 'Card', 'Bank Transfer'];
  List<String> shopping = ['Shopping', 'Groceries', 'Electronics'];

  String _amount = "0.00";

  void _updateAmount(String value) {
    setState(() {
      if (value == "Del") {
        _amount = _amount.length > 1
            ? _amount.substring(0, _amount.length - 1)
            : "0.00";
      } else if (value == "Cal") {
        _amount = "0.00";
      } else {
        if (_amount == "0.00" || _amount == "0") {
          _amount = value; // Replace initial amount with new value
        } else {
          _amount += value; // Append new value
        }
      }
    });
  }

  Widget customSizeButton(String btnTxt, Color btnColor, Color txtColor,
      double width, double height) {
    return GestureDetector(
      onTap: () {
        _updateAmount(btnTxt);
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: btnColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.center,
        child: Text(
          btnTxt,
          style: TextStyle(
            fontSize: btnTxt.length > 1 ? 20 : 35,
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
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(182, 255, 250, 1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: 'Cash',
                            items: finance.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Center(
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {},
                            icon: const Icon(Icons.keyboard_arrow_down,
                                color: Colors.black),
                            iconSize: 28,
                            isExpanded: true,
                            alignment: Alignment.center,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.black),
                            dropdownColor:
                                const Color.fromRGBO(182, 255, 250, 1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(186, 216, 182, 1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: 'Shopping',
                            items: shopping.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Center(
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {},
                            icon: const Icon(Icons.keyboard_arrow_down,
                                color: Colors.black),
                            iconSize: 28,
                            isExpanded: true,
                            alignment: Alignment.center,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.black),
                            dropdownColor:
                                const Color.fromRGBO(186, 216, 182, 1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                
                const Text(
                  'Expense',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                const SizedBox(height: 10),
                Text(
                  '\$$_amount',
                  style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 10),
                const Text('Add comment...',
                    style: TextStyle(fontSize: 13, color: Colors.black)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: ['1', '4', '7', '\$']
                      .map((btn) => Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: customSizeButton(
                                btn,
                                const Color.fromRGBO(35, 72, 106, 1),
                                Colors.black,
                                50,
                                50),
                          ))
                      .toList(),
                ),
                Column(
                  children: ['2', '5', '8', '0']
                      .map((btn) => Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: customSizeButton(
                                btn,
                                const Color.fromRGBO(35, 72, 106, 1),
                                Colors.black,
                                50,
                                50),
                          ))
                      .toList(),
                ),
                Column(
                  children: ['3', '6', '9', ',']
                      .map((btn) => Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: customSizeButton(
                                btn,
                                const Color.fromRGBO(35, 72, 106, 1),
                                Colors.black,
                                50,
                                50),
                          ))
                      .toList(),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: customSizeButton(
                          "Cal",
                          const Color.fromRGBO(35, 72, 106, 1),
                          Colors.black,
                          50,
                          50),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: customSizeButton(
                          "Del",
                          const Color.fromRGBO(35, 72, 106, 1),
                          Colors.black,
                          50,
                          50),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: customSizeButton(
                          "✔",
                          const Color.fromRGBO(23, 59, 69, 1),
                          Colors.black,
                          50,
                          100),
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
