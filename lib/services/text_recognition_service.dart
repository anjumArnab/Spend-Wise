import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class TextRecognitionService {
  final TextRecognizer _textRecognizer = TextRecognizer();

  Future<String> extractTextFromImage(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final RecognizedText recognizedText =
          await _textRecognizer.processImage(inputImage);

      // Combine all text blocks into a single string
      final StringBuffer extractedText = StringBuffer();
      for (TextBlock block in recognizedText.blocks) {
        extractedText.writeln(block.text);
      }

      return extractedText.toString().trim();
    } catch (e) {
      print('Error extracting text from image: $e');
      rethrow;
    }
  }

  void dispose() {
    _textRecognizer.close();
  }
}
