// Model class for income source data to be stored
class IncomeSource {
  final String name;
  final double amount;

  IncomeSource({
    required this.name,
    required this.amount,
  });

  factory IncomeSource.fromJson(Map<String, dynamic> json) {
    return IncomeSource(
      name: json['name'] ?? '', // Fallback if 'name' is missing
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0, // Safely handle null 'amount'
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'amount': amount,
      };
}