import 'package:flutter/material.dart';

class PaymentItem extends StatelessWidget {
  final int index;
  final String date;
  final String time;
  final double amount;

  const PaymentItem({
    super.key,
    required this.index,
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
        leading: const Icon(
          Icons.credit_card,
          color: Colors.blue,
          size: 20, // Smaller icon
        ),
        title: Text(
          "Credit card payment $index",
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
