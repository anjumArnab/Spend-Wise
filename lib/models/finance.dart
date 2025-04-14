import 'package:spend_wise/models/income_source.dart';

class FinancePlanModel {
  final String? id; // Optional Firestore document ID
  final DateTime startDate;
  final DateTime endDate;
  final List<IncomeSource> incomeSources;
  final double totalIncome;

  FinancePlanModel({
    this.id,
    required this.startDate,
    required this.endDate,
    required this.incomeSources,
    required this.totalIncome,
  });

  factory FinancePlanModel.fromJson(Map<String, dynamic> json, {String? docId}) {
    return FinancePlanModel(
      id: docId,
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      incomeSources: (json['incomeSources'] as List)
          .map((e) => IncomeSource.fromJson(e))
          .toList(),
      totalIncome: (json['totalIncome'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'incomeSources': incomeSources.map((e) => e.toJson()).toList(),
        'totalIncome': totalIncome,
      };
}