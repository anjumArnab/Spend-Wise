class Expense {
  final String category;
  final String method;
  final String date;
  final String time;
  final double amount;

  const Expense({
    required this.category,
    required this.method,
    required this.date,
    required this.time,
    required this.amount,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      category: json['category'],
      method: json['method'],
      date: json['date'],
      time: json['time'],
      amount: json['amount'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'method': method,
      'date': date,
      'time': time,
      'amount': amount,
    };
  }
}
