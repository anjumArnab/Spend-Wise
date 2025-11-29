import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spend_wise/widgets/text_field.dart';
import '../gemeni_api_key.dart';
import '../models/payment.dart';
import '../models/budget.dart';
import '../services/image_picker_service.dart';
import '../services/text_recognition_service.dart';
import '../services/gemini_parser_service.dart';
import '../widgets/border_button.dart';
import '../widgets/show_snack_bar.dart';
import '../services/authentication.dart';
import '../services/cloud_store.dart';

class ReceiptScannerScreen extends StatefulWidget {
  final bool isPayment;

  const ReceiptScannerScreen({
    super.key,
    this.isPayment = true,
  });

  @override
  State<ReceiptScannerScreen> createState() => _ReceiptScannerScreenState();
}

class _ReceiptScannerScreenState extends State<ReceiptScannerScreen> {
  final ImagePickerService _imagePickerService = ImagePickerService();
  final TextRecognitionService _textRecognitionService =
      TextRecognitionService();
  late final GeminiParserService _geminiParserService;
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuthService _authService = FirebaseAuthService();

  XFile? _selectedImage;
  bool _isProcessing = false;
  Map<String, dynamic>? _parsedData;

  // Form controllers
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();
  final _dateController = TextEditingController();

  // Payment specific
  final _methodController = TextEditingController();
  final _timeController = TextEditingController();

  // Budget specific
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _geminiParserService = GeminiParserService(GEMENI_API_KEY);
  }

  @override
  void dispose() {
    _textRecognitionService.dispose();
    _amountController.dispose();
    _categoryController.dispose();
    _dateController.dispose();
    _methodController.dispose();
    _timeController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    setState(() {
      _isProcessing = true;
      _parsedData = null;
      _selectedImage = null;
    });

    try {
      // Pick image
      final XFile? image = source == ImageSource.gallery
          ? await _imagePickerService.pickFromGallery()
          : await _imagePickerService.pickFromCamera();

      if (image == null) {
        setState(() => _isProcessing = false);
        return;
      }

      setState(() => _selectedImage = image);

      // Extract text from image
      final extractedText =
          await _textRecognitionService.extractTextFromImage(image.path);

      if (extractedText.isEmpty) {
        if (mounted) {
          showSnackBar(context, 'No text found in the image');
        }
        setState(() => _isProcessing = false);
        return;
      }

      // Parse text with Gemini AI
      final parsedData = widget.isPayment
          ? await _geminiParserService.parsePaymentData(extractedText)
          : await _geminiParserService.parseBudgetData(extractedText);

      setState(() {
        _parsedData = parsedData;
        _populateFields(parsedData);
      });
    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'Error processing image: $e');
      }
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _populateFields(Map<String, dynamic> data) {
    _amountController.text = data['amount']?.toString() ?? '';
    _categoryController.text = data['category'] ?? '';

    if (widget.isPayment) {
      _methodController.text = data['method'] ?? '';
      _dateController.text = data['date'] ?? '';
      _timeController.text = data['time'] ?? '';
    } else {
      _startDateController.text = data['startDate'] ?? '';
      _endDateController.text = data['endDate'] ?? '';
    }
  }

  Future<void> _saveData() async {
    if (_amountController.text.isEmpty || _categoryController.text.isEmpty) {
      showSnackBar(context, 'Please fill in required fields');
      return;
    }

    try {
      setState(() => _isProcessing = true);

      final uid = _authService.currentUser?.uid;
      if (uid == null) {
        showSnackBar(context, 'User not authenticated');
        return;
      }

      if (widget.isPayment) {
        final payment = Payment(
          id: '', // Firestore will generate this
          amount: double.tryParse(_amountController.text) ?? 0.0,
          category: _categoryController.text,
          method: _methodController.text,
          date: _dateController.text,
          time: _timeController.text,
        );
        await _firestoreService.addPayment(uid, payment);
        if (mounted) {
          showSnackBar(context, 'Payment saved successfully');
        }
      } else {
        final budget = Budget(
          id: '', // Firestore will generate this
          amount: double.tryParse(_amountController.text) ?? 0.0,
          category: _categoryController.text,
          startDate: _startDateController.text,
          endDate: _endDateController.text,
        );
        await _firestoreService.addBudget(uid, budget);
        if (mounted) {
          showSnackBar(context, 'Budget saved successfully');
        }
      }

      // Clear form and image
      setState(() {
        _selectedImage = null;
        _parsedData = null;
      });
      _clearFields();

      // Navigate back or stay on screen
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'Error saving data: $e');
      }
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _clearFields() {
    _amountController.clear();
    _categoryController.clear();
    _dateController.clear();
    _methodController.clear();
    _timeController.clear();
    _startDateController.clear();
    _endDateController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan ${widget.isPayment ? 'Receipt' : 'Budget'}'),
      ),
      body: _isProcessing
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Processing image...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_selectedImage == null) ...[
                    // Image selection buttons
                    const Text(
                      'Select an image to extract data',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    BorderButton(
                      text: 'Pick from Gallery',
                      onPressed: () => _pickImage(ImageSource.gallery),
                    ),
                    const SizedBox(height: 16),
                    BorderButton(
                      text: 'Capture with Camera',
                      onPressed: () => _pickImage(ImageSource.camera),
                    ),
                  ] else ...[
                    // Display selected image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(_selectedImage!.path),
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedImage = null;
                          _parsedData = null;
                          _clearFields();
                        });
                      },
                      child: const Text(
                        'Select Different Image',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 24),

                    if (_parsedData != null) ...[
                      // Extracted data form
                      const Text(
                        'Extracted Data',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      AppTextField(
                        controller: _amountController,
                        labelText: 'Amount',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),

                      AppTextField(
                        controller: _categoryController,
                        labelText: 'Category',
                      ),
                      const SizedBox(height: 12),

                      if (widget.isPayment) ...[
                        AppTextField(
                          controller: _methodController,
                          labelText: 'Payment Method',
                        ),
                        const SizedBox(height: 12),
                        AppTextField(
                          controller: _dateController,
                          labelText: 'Date',
                        ),
                        const SizedBox(height: 12),
                        AppTextField(
                          controller: _timeController,
                          labelText: 'Time',
                        ),
                      ] else ...[
                        AppTextField(
                          controller: _startDateController,
                          labelText: 'Start Date',
                        ),
                        const SizedBox(height: 12),
                        AppTextField(
                          controller: _endDateController,
                          labelText: 'End Date',
                        ),
                      ],

                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _saveData,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
    );
  }
}
