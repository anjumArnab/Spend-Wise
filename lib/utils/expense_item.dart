import 'package:flutter/material.dart';

class TransctionItem extends StatelessWidget {
  final String category;
  final String method;
  final String date;
  final String time;
  final double amount;

  const TransctionItem({
    super.key,
    required this.category,
    required this.method,
    required this.date,
    required this.time,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(3),
      ),
      margin: const EdgeInsets.only(bottom: 3), // Reduced margin
      child: ListTile(
        title: Text(
          '$category | $method',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          "Date: $date | Time: $time",
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        trailing: Text(
          "\$${amount.toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
