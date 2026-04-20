import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'ai_chat_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StatCardScreen(),
    );
  }
}

class StatCardScreen extends StatelessWidget {
  const StatCardScreen({super.key});

  static final GlobalKey globalKey = GlobalKey();

  final String name = "Alishba";
  final int score = 1200;
  final int rank = 5;
  final int wins = 20;

  Future<void> captureAndShare() async {
    try {
      RenderRepaintBoundary boundary =
      globalKey.currentContext!.findRenderObject()
      as RenderRepaintBoundary;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData =
      await image.toByteData(format: ImageByteFormat.png);

      final pngBytes = byteData!.buffer.asUint8List();

      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/stat_card.png');

      await file.writeAsBytes(pngBytes);

      const String shareText =
          "Track your matches and stats with our app!\n\n"
          "Download now:\n"
          "Play Store: https://play.google.com/store/apps/details?id=yourapp\n"
          "App Store: https://apps.apple.com/app/id000000";

      await Share.shareXFiles(
        [XFile(file.path)],
        text: shareText,
      );
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Player Stat Card")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RepaintBoundary(
              key: globalKey,
              child: _statCard(),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: captureAndShare,
              child: const Text("Share Card"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AIChatScreen(),
                  ),
                );
              },
              child: const Text("Padel AI"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard() {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            Color(0xff0F2027),
            Color(0xff203A43),
            Color(0xff2C5364),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 42,
            backgroundImage: NetworkImage(
              "https://randomuser.me/api/portraits/women/44.jpg",
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              statItem("Score", score.toString()),
              statItem("Rank", "#$rank"),
              statItem("Wins", wins.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget statItem(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}