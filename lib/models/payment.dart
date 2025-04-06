class Payment {
  final String id; // Added for Firestore document ID
  final String category;
  final String method;
  final String date;
  final String time;
  final double amount;

  const Payment({
    required this.id,
    required this.category,
    required this.method,
    required this.date,
    required this.time,
    required this.amount,
  });

  factory Payment.fromJson(Map<String, dynamic> json, {String docId = ''}) {
    return Payment(
      id: docId, // Use Firestore document ID
      category: json['category'],
      method: json['method'],
      date: json['date'],
      time: json['time'],
      amount: json['amount'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // Exclude id as Firestore manages the document ID
      'category': category,
      'method': method,
      'date': date,
      'time': time,
      'amount': amount,
    };
  }
}