import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final loc = AppLocalizations.of(context)!;
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
          SnackBar(content: Text(loc.feedbackSuccess)),
        );
        _controller.clear();
      } else {
        throw Exception("Sunucu hatası");
      }
    } catch (e) {
      print("Gönderim hatası: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${loc.errorFetchingData} $e")),
      );
    } finally {
      setState(() => _isSending = false);
    }

  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.feedbackScreenTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: loc.feedbackHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _isSending ? null : _gonder,
              child: _isSending
                  ? const CircularProgressIndicator()
                  : Text(loc.feedbackButton),
            ),
          ],
        ),
      ),
    );
  }
}
