import 'dart:convert';
import 'package:http/http.dart' as http;
import 'app_knowledge.dart';

class AIService {
  static const String apiKey = "AIzaSyD3wAO9HaNLg33Q6psMaSHUu-1MjFlvlFY";

  // ---------------------------
  // Guard Rule for PadelDuo
  // ---------------------------
  static const String guardRule = """
You are the official AI assistant of the PadelDuo mobile application.

You must ONLY answer questions related to the PadelDuo app:
- scoring system
- app features
- match rules
- BLE scoring buttons
- troubleshooting
- how to use the app

Keep all answers VERY SHORT (max 2 lines).

If the question is NOT related to PadelDuo, reply EXACTLY with:

"Sorry, this question is outside the scope of PadelDuo. I can only help with PadelDuo app related queries."

Do not answer anything else.
""";

  // ---------------------------
  // Check if question is related to Padel
  // ---------------------------
  static bool isPadelQuestion(String question) {
    final q = question.toLowerCase();

    final keywords = [
      "padel",
      "score",
      "match",
      "button",
      "ble",
      "connect",
      "game",
      "player"
    ];

    return keywords.any((k) => q.contains(k));
  }

  // ---------------------------
  // Ask AI function
  // ---------------------------
  static Future<String> askAI(String question) async {
    // Step 1: check question first
    if (!isPadelQuestion(question)) {
      return "Sorry, this question is outside the scope of PadelDuo. I can only help with PadelDuo app related queries.";
    }

    try {
      final url =
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey";

      // Step 2: API body
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "system_instruction": {
            "parts": [
              {"text": guardRule}
            ]
          },
          "contents": [
            {
              "role": "user",
              "parts": [
                {"text": "App Knowledge:\n$appKnowledge"}
              ]
            },
            {
              "role": "user",
              "parts": [
                {"text": question}
              ]
            }
          ]
        }),
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["candidates"][0]["content"]["parts"][0]["text"];
      } else {
        return "API Error: ${response.statusCode}\n${response.body}";
      }
    } catch (e) {
      return "Exception: $e";
    }
  }
}