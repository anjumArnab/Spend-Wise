import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiParserService {
  final String apiKey;
  static const String baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models';
  static const String model = 'gemini-2.5-flash';

  GeminiParserService(this.apiKey);

  /// Parse extracted text to get Payment model data
  Future<Map<String, dynamic>> parsePaymentData(String extractedText) async {
    final prompt = '''
You are a receipt data extraction assistant. Extract payment information from the following receipt text and return ONLY valid JSON.

RECEIPT TEXT:
$extractedText

EXTRACT THESE FIELDS:
- amount (number): The total payment amount (extract only the number, no currency symbols)
- category (string): Choose ONE from [Housing, Utilities, Groceries, Toiletries & Hygiene, Apparel, Transportation, Healthcare, Debt Payment, Dining Out, Entertainment, Subscriptions & Memberships, Personal Care, Emergency Fund, Retirement Contributions, Education & Learning, Gifts & Donations, Insurance, Childcare & Education, Pets, Miscellaneous Transctions]. Infer from merchant name or items.
- method (string): Payment method - choose ONE from [Cash, Card, Mobile Banking, Online, Others]
- date (string): Transaction date in format YYYY-MM-DD
- time (string): Transaction time in format HH:MM (24-hour format)

RULES:
- Return ONLY valid JSON, no markdown code blocks or explanations
- Use null for any field you cannot find or infer
- For category, make an intelligent guess based on merchant name or items
- If multiple amounts exist, choose the total/final amount
- Current date is ${DateTime.now().toString().split(' ')[0]} - use this if date not found

RESPOND EXACTLY IN THIS FORMAT:
{
  "amount": 1234.56,
  "category": "Dining Out",
  "method": "Card",
  "date": "2024-11-28",
  "time": "14:30"
}
''';

    return await _callGeminiAPI(prompt);
  }

  /// Parse extracted text to get Budget model data
  Future<Map<String, dynamic>> parseBudgetData(String extractedText) async {
    final prompt = '''
You are a budget document extraction assistant. Extract budget information from the following text and return ONLY valid JSON.

DOCUMENT TEXT:
$extractedText

EXTRACT THESE FIELDS:
- amount (number): The budget amount (extract only the number, no currency symbols)
- category (string): Budget category - choose ONE from [Housing, Utilities, Groceries, Toiletries & Hygiene, Apparel, Transportation, Healthcare, Debt Payment, Dining Out, Entertainment, Subscriptions & Memberships, Personal Care, Emergency Fund, Retirement Contributions, Education & Learning, Gifts & Donations, Insurance, Childcare & Education, Pets, Miscellaneous Transctions]
- startDate (string): Budget start date in format YYYY-MM-DD
- endDate (string): Budget end date in format YYYY-MM-DD

RULES:
- Return ONLY valid JSON, no markdown code blocks or explanations
- Use null for any field you cannot find
- For category, make an intelligent guess based on context
- If date range is mentioned as "monthly", set startDate to first day of current month and endDate to last day
- If no dates found, use null
- Current date is ${DateTime.now().toString().split(' ')[0]}

RESPOND EXACTLY IN THIS FORMAT:
{
  "amount": 5000.00,
  "category": "Dining Out",
  "startDate": "2024-11-01",
  "endDate": "2024-11-30"
}
''';

    return await _callGeminiAPI(prompt);
  }

  /// Make API call to Gemini REST API
  Future<Map<String, dynamic>> _callGeminiAPI(String prompt) async {
    final url = Uri.parse('$baseUrl/$model:generateContent?key=$apiKey');

    final requestBody = {
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ],
      "generationConfig": {
        "temperature": 0.1,
        "topK": 1,
        "topP": 1,
        "maxOutputTokens": 2048,
      }
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      final candidates = responseData['candidates'] as List?;
      if (candidates == null || candidates.isEmpty) {
        throw Exception('No response from Gemini API');
      }

      final content = candidates[0]['content'];
      final parts = content['parts'] as List;
      final text = parts[0]['text'] as String;

      final cleanJson = text
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      final parsedData = jsonDecode(cleanJson) as Map<String, dynamic>;

      return parsedData;
    } else {
      throw Exception('Gemini API error: ${response.statusCode} - ${response.body}');
    }
  }
}