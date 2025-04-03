import 'package:flutter/material.dart';

class BudgetProgress extends StatelessWidget {
  final String title;
  final double budget;
  final double progress;

  const BudgetProgress({
    super.key,
    required this.title,
    required this.budget,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.black, fontSize: 12)),
              Text("\$${budget.toStringAsFixed(2)}", style: const TextStyle(color: Colors.black, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: double.infinity,
            height: 6,
            child: LinearProgressIndicator(
              borderRadius: BorderRadius.circular(8),
              value: progress,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
              backgroundColor: Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }
}
