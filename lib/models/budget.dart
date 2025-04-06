class Budget {
  final String id; // Changed from int to String for Firestore document ID
  final String category;
  final double amount;
  final String startDate;
  final String endDate;

  Budget({
    required this.id,
    required this.category,
    required this.amount,
    required this.startDate,
    required this.endDate,
  });
  
  factory Budget.fromJson(Map<String, dynamic> json, {String docId = ''}) {
    return Budget(
      id: docId, // Use Firestore document ID
      category: json['category'],
      amount: json['amount'].toDouble(),
      startDate: json['start_date'],
      endDate: json['end_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // Exclude id as Firestore manages the document ID
      'category': category,
      'amount': amount,
      'start_date': startDate,
      'end_date': endDate,
    };
  }
}