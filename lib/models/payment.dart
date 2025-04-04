class Payment {
  final String category;
  final String method;
  final String date;
  final String time;
  final double amount;

  const Payment({
    required this.category,
    required this.method,
    required this.date,
    required this.time,
    required this.amount,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
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
