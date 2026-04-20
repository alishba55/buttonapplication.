import 'package:flutter/material.dart';
import 'ai_service.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController controller = TextEditingController();
  String response = "";
  bool loading = false;

  void askQuestion() async {
    setState(() {
      loading = true;
      response = "";
    });

    final reply = await AIService.askAI(controller.text);

    setState(() {
      response = reply;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ask AI Assistant")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Ask something about the app...",
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: askQuestion,
              child: const Text("Ask AI"),
            ),
            const SizedBox(height: 20),
            loading
                ? const CircularProgressIndicator()
                : Expanded(
              child: SingleChildScrollView(
                child: Text(response),
              ),
            ),
          ],
        ),
      ),
    );
  }
}