import 'package:flutter/material.dart';

class CategoryTab extends StatelessWidget {
  final String label;
  final String selectedCategory;
  final Function(String) onTap;

  const CategoryTab({
    super.key,
    required this.label,
    required this.selectedCategory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selectedCategory == label;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(label),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Colors.blueGrey : Colors.black,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(3),
            color: isSelected ? Colors.blue.withOpacity(0.1) : null,
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
