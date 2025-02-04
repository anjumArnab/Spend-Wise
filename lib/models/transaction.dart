class Transaction {
  final String category;
  final DateTime dateAndTime;
  final String description;
  final double amount;

  Transaction({
    required this.category,
    required this.dateAndTime,
    required this.description,
    required this.amount,
  });
}