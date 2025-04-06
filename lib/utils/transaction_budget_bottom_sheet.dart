import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionBudgetBottomSheet extends StatefulWidget {
  final String title;
  final String category;
  final Function(Map<String, String>)? onSubmit;

  const TransactionBudgetBottomSheet({
    super.key,
    required this.title,
    required this.category,
    this.onSubmit,
  });

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

  @override
  void dispose() {
    _amountController.dispose();
    _paymentMethodController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _startDateController.dispose();
    super.dispose();
  }

  void _submit() {
    final data = {
      "amount": _amountController.text,
      "paymentMethod": _paymentMethodController.text,
      "date": _dateController.text,
      "time": _timeController.text,
      "startDate": _startDateController.text,
    };
    widget.onSubmit?.call(data);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${widget.title} - ${widget.category}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Amount & Payment Method
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Amount",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: widget.title == 'Transaction'
                      ? TextField(
                          controller: _paymentMethodController,
                          decoration: const InputDecoration(
                            labelText: "Payment Method",
                            border: OutlineInputBorder(),
                          ),
                        )
                      : const SizedBox(),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Date & Time or Start Date
            Row(
              children: [
                Expanded(
                  child: widget.title == 'Transaction'
                      ? TextField(
                          controller: _dateController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: "Date",
                            border: OutlineInputBorder(),
                          ),
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(picked);
                              setState(() {
                                _dateController.text = formattedDate;
                              });
                            }
                          },
                        )
                      : TextField(
                          controller: _startDateController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: "Start Date",
                            border: OutlineInputBorder(),
                          ),
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(picked);
                              setState(() {
                                _startDateController.text = formattedDate;
                              });
                            }
                          },
                        ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: widget.title == 'Transaction'
                      ? TextField(
                          controller: _timeController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: "Time",
                            border: OutlineInputBorder(),
                          ),
                          onTap: () async {
                            TimeOfDay? time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (time != null) {
                              String formattedTime =
                                  DateFormat('hh:mm a').format(DateTime(
                                0,
                                0,
                                0,
                                time.hour,
                                time.minute,
                              ));
                              setState(() {
                                _timeController.text = formattedTime;
                              });
                            }
                          },
                        )
                      : const SizedBox(),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _submit,
                child: Text("Submit ${widget.title}"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
