import 'package:flutter/material.dart';

class BudgetProgress extends StatelessWidget {
  final String category;
  final String startDate;
  final String endDate;
  final double amount;
  final double progress; // Progress value (0.0 to 1.0)

  const BudgetProgress({
    super.key,
    required this.category,
    required this.startDate,
    required this.endDate,
    required this.amount,
    required this.progress,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4), // Space before progress bar
                SizedBox(
                  width: double.infinity,
                  height: 6,
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
            subtitle: Text(
              "Start Date: $startDate | End Date: $endDate",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            trailing: Text(
              "\$${amount.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
