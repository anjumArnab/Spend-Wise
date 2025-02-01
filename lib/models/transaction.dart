class Transaction {
  final DateTime date;
  final String category;
  final String description;
  final double amount;

  Transaction({
    required this.date,
    required this.category,
    required this.description,
    required this.amount,
  });
}