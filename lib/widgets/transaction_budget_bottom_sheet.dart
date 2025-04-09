import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spend_wise/widgets/border_button.dart';

class TransactionBudgetBottomSheet extends StatefulWidget {
  final String title;
  final String category;
  final Function(Map<String, String>) onSubmit;

  const TransactionBudgetBottomSheet({
    super.key,
    required this.title,
    required this.category,
    required this.onSubmit,
  });

  /// Static method to show this bottom sheet as a modal
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String category,
    required Function(Map<String, String>) onSubmit,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
      ),
      builder: (context) => TransactionBudgetBottomSheet(
        title: title,
        category: category,
        onSubmit: onSubmit,
      ),
    );
  }

  static Future<void> updatePayment({
    required BuildContext context,
    required String title,
    required String category,
    required Function(Map<String, String>) onSubmit,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
      ),
      builder: (context) => TransactionBudgetBottomSheet(
        title: title,
        category: category,
        onSubmit: onSubmit,
      ),
    );
  }

  static Future<void> updateBudget({
    required BuildContext context,
    required String title,
    required String category,
    required Function(Map<String, String>) onSubmit,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
      ),
      builder: (context) => TransactionBudgetBottomSheet(
        title: title,
        category: category,
        onSubmit: onSubmit,
      ),
    );
  }
  

  @override
  State<TransactionBudgetBottomSheet> createState() =>
      _TransactionBudgetBottomSheetState();
}

class _TransactionBudgetBottomSheetState
    extends State<TransactionBudgetBottomSheet> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _paymentMethodController =
      TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool get isTransaction => widget.title == 'Transaction';

  @override
  void initState() {
    super.initState();
    // Set default values
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _timeController.text = DateFormat('hh:mm a').format(DateTime.now());
    _startDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final nextMonth = DateTime.now().add(const Duration(days: 30));
    _endDateController.text = DateFormat('yyyy-MM-dd').format(nextMonth);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _paymentMethodController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final data = {
      "amount": _amountController.text,
      "paymentMethod": isTransaction ? _paymentMethodController.text : "",
      "date": isTransaction ? _dateController.text : "",
      "time": isTransaction ? _timeController.text : "",
      "startDate": !isTransaction ? _startDateController.text : "",
      "endDate": !isTransaction ? _endDateController.text : "",
    };

    widget.onSubmit(data);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${widget.title} - ${widget.category}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Amount & Payment Method
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Amount",
                        border: OutlineInputBorder(),
                        prefixText: "\$ ",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: isTransaction
                        ? TextFormField(
                            controller: _paymentMethodController,
                            decoration: const InputDecoration(
                              labelText: "Payment Method",
                              border: OutlineInputBorder(),
                              hintText: "Cash, Card, etc.",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter payment method';
                              }
                              return null;
                            },
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Date & Time or Start Date
              Row(
                children: [
                  Expanded(
                    child: isTransaction
                        ? _buildDatePicker(
                            controller: _dateController,
                            labelText: "Date",
                            isRequired: true,
                          )
                        : _buildDatePicker(
                            controller: _startDateController,
                            labelText: "Start Date",
                            isRequired: true,
                          ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: isTransaction
                        ? _buildTimePicker(
                            controller: _timeController,
                            labelText: "Time",
                            isRequired: true,
                          )
                        : _buildDatePicker(
                            controller: _endDateController,
                            labelText: "End Date",
                            isRequired: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select end date';
                              }

                              final startDate =
                                  DateTime.parse(_startDateController.text);
                              final endDate = DateTime.parse(value);

                              if (endDate.isBefore(startDate)) {
                                return 'End date must be after start date';
                              }
                              return null;
                            },
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: BorderButton(
                  text: "Save ${widget.title}",
                  onPressed: _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker({
    required TextEditingController controller,
    required String labelText,
    bool isRequired = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      validator: validator ??
          (value) {
            if (isRequired && (value == null || value.isEmpty)) {
              return 'Please select a date';
            }
            return null;
          },
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: controller.text.isNotEmpty
              ? DateTime.parse(controller.text)
              : DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          setState(() {
            controller.text = DateFormat('yyyy-MM-dd').format(picked);
          });
        }
      },
    );
  }

  Widget _buildTimePicker({
    required TextEditingController controller,
    required String labelText,
    bool isRequired = false,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.access_time),
      ),
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'Please select a time';
        }
        return null;
      },
      onTap: () async {
        TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: controller.text.isNotEmpty
              ? TimeOfDay.fromDateTime(
                  DateFormat('hh:mm a').parse(controller.text))
              : TimeOfDay.now(),
        );
        if (picked != null) {
          setState(() {
            controller.text = DateFormat('hh:mm a').format(DateTime(
              0,
              0,
              0,
              picked.hour,
              picked.minute,
            ),);
          });
        }
      },
    );
  }
}
