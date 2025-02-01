import 'package:flutter/material.dart';
import 'package:spend_wise/screens/homepage.dart';

void main() {
  runApp(const SpendWise());
}

class SpendWise extends StatelessWidget {
  const SpendWise({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
      title: 'Spend Wise',
      home: const HomePage(),
    );
  }
}
