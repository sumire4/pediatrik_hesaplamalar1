import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config.dart';

class FeedbackEkrani extends StatefulWidget {
  const FeedbackEkrani({super.key});

  @override
  State<FeedbackEkrani> createState() => _FeedbackEkraniState();
}

class _FeedbackEkraniState extends State<FeedbackEkrani> {
  final TextEditingController _controller = TextEditingController();
  bool _isSending = false;

  Future<void> _gonder() async {
    final mesaj = _controller.text.trim();
    if (mesaj.isEmpty) return;

    setState(() => _isSending = true);

    try {
      final response = await http.post(
        Uri.parse('$backendUrl/feedbacks'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'yorum': mesaj}),
      );

      print("Yanıt durumu: ${response.statusCode}");
      print("Yanıt gövdesi: ${response.body}");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Geri bildiriminiz alındı")),
        );
        _controller.clear();
      } else {
        throw Exception("Sunucu hatası");
      }
    } catch (e) {
      print("Gönderim hatası: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gönderim hatası: $e")),
      );
    } finally {
      setState(() => _isSending = false);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Geri Bildirim")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "Geri bildiriminizi yazın...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _isSending ? null : _gonder,
              child: _isSending
                  ? const CircularProgressIndicator()
                  : const Text("Gönder"),
            ),
          ],
        ),
      ),
    );
  }
}
