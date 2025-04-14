import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spend_wise/models/income_source.dart';
import 'package:spend_wise/screens/homepage.dart';
import 'package:spend_wise/services/authentication.dart';
import 'package:spend_wise/services/cloud_store.dart';
import 'package:spend_wise/widgets/border_button.dart';
import 'package:spend_wise/widgets/custom_text_field.dart';
import 'package:spend_wise/widgets/show_snack_bar.dart';
import 'package:spend_wise/models/finance.dart';

// UI class for handling income source form fields
class IncomeSourceField {
  final TextEditingController nameController;
  final TextEditingController amountController;

  IncomeSourceField({
    required this.nameController,
    required this.amountController,
  });
}

class FinancePlan extends StatefulWidget {
  const FinancePlan({super.key});
  @override
  State<FinancePlan> createState() => _FinancePlanState();
}

class _FinancePlanState extends State<FinancePlan> {
  final TextEditingController _initialDateController = TextEditingController();
  final TextEditingController _finalDateController = TextEditingController();

  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _db = FirestoreService();

  // List to hold all income source controllers
  final List<IncomeSourceField> _incomeSources = [];
  double _totalIncome = 0.0;
  bool _areAllFieldsFilled = false;

  @override
  void initState() {
    super.initState();
    // Set the initial date to current date
    _initialDateController.text =
        DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Set the final date to the last day of the current month
    final now = DateTime.now();
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    _finalDateController.text = DateFormat('yyyy-MM-dd').format(lastDayOfMonth);

    // Add initial income source field
    _addIncomeSource();
  }

  @override
  void dispose() {
    _initialDateController.dispose();
    _finalDateController.dispose();

    // Dispose all income source controllers
    for (var source in _incomeSources) {
      source.nameController.dispose();
      source.amountController.dispose();
    }

    super.dispose();
  }

  void _addIncomeSource() {
    final nameController = TextEditingController();
    final amountController = TextEditingController();

    // Add listeners to controllers to check for input changes
    nameController.addListener(_checkFieldsAndAddIfNeeded);
    amountController.addListener(_checkFieldsAndAddIfNeeded);

    setState(() {
      _incomeSources.add(
        IncomeSourceField(
          nameController: nameController,
          amountController: amountController,
        ),
      );
    });

    _validateAllFields();
  }

  void _checkFieldsAndAddIfNeeded() {
    // If the last row's fields are filled, add a new row
    if (_incomeSources.isNotEmpty) {
      final lastSource = _incomeSources.last;
      if (lastSource.nameController.text.trim().isNotEmpty &&
          lastSource.amountController.text.trim().isNotEmpty) {
        // Check if this is already the last field
        if (lastSource == _incomeSources.last) {
          _addIncomeSource();
        }
      }
    }

    _calculateTotalIncome();
    _validateAllFields();
  }

  void _calculateTotalIncome() {
    double total = 0.0;
    for (var source in _incomeSources) {
      if (source.amountController.text.isNotEmpty) {
        total += double.tryParse(source.amountController.text) ?? 0.0;
      }
    }
    setState(() {
      _totalIncome = total;
    });
  }

  void _validateAllFields() {
    bool allFilled = true;

    // Skip the last empty field that's provided for adding a new entry
    for (int i = 0; i < _incomeSources.length - 1; i++) {
      final source = _incomeSources[i];
      if (source.nameController.text.trim().isEmpty ||
          source.amountController.text.trim().isEmpty) {
        allFilled = false;
        break;
      }
    }

    setState(() {
      _areAllFieldsFilled = allFilled && _incomeSources.length > 1;
    });
  }

  Future<void> _selectInitialDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _initialDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectFinalDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _finalDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
  
  void _navToHomePage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(totalIncome: _totalIncome,),
      ),
    );
  }

  void _saveFinancePlan() async {
    // Remove the last empty field before saving
    if (_incomeSources.isNotEmpty) {
      final lastSource = _incomeSources.last;
      if (lastSource.nameController.text.trim().isEmpty &&
          lastSource.amountController.text.trim().isEmpty) {
        // Don't save the last empty row
        _incomeSources.removeLast();
      }
    }
    
    try {
      // Get current user ID
      final user = _authService.currentUser;
      if (user == null) {
        showSnackBar(context, 'User not logged in');
        return;
      }
      
      // Convert UI data model to persistence data model
      final List<IncomeSource> sources = _incomeSources.map((source) {
        return IncomeSource(
          name: source.nameController.text.trim(),
          amount: double.tryParse(source.amountController.text.trim()) ?? 0.0,
        );
      }).toList();
      
      // Create the finance plan object
      final plan = FinancePlanModel(
        startDate: DateFormat('yyyy-MM-dd').parse(_initialDateController.text),
        endDate: DateFormat('yyyy-MM-dd').parse(_finalDateController.text),
        incomeSources: sources,
        totalIncome: _totalIncome,
      );
      
      await _db.saveFinancePlan(user.uid, plan);
      
      // Navigate to homepage and show success message
      _navToHomePage(context);
      showSnackBar(context, 'Finance plan saved successfully');
    } catch (e) {
      showSnackBar(context, 'Error saving finance plan: $e');
      print("Error in _saveFinancePlan: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Finance Plan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Set your finance plan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            const Text(
              'Plan period:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _initialDateController,
                    hintText: 'Start Date',
                    keyboardType: TextInputType.datetime,
                    readOnly: true,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectInitialDate(context),
                    ),
                    onTap: () => _selectInitialDate(context),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomTextField(
                    controller: _finalDateController,
                    hintText: 'End Date',
                    keyboardType: TextInputType.datetime,
                    readOnly: true,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectFinalDate(context),
                    ),
                    onTap: () => _selectFinalDate(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Income Sources:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _incomeSources.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: CustomTextField(
                            controller: _incomeSources[index].nameController,
                            hintText: 'Source name',
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CustomTextField(
                            controller: _incomeSources[index].amountController,
                            hintText: 'Amount',
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Income: \$${_totalIncome.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  BorderButton(
                    text: 'Done',
                    onPressed: _areAllFieldsFilled ? _saveFinancePlan : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}