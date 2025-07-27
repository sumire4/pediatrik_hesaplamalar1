import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pediatrik_hesaplamalar/config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FeedbackListEkrani extends StatefulWidget {
  const FeedbackListEkrani({super.key});

  @override
  State<FeedbackListEkrani> createState() => _FeedbackListEkraniState();
}

class _FeedbackListEkraniState extends State<FeedbackListEkrani> {
  List<String> yorumlar = [];
  bool yukleniyor = true;
  String? hata;

  @override
  void initState() {
    super.initState();
    _geriBildirimleriGetir();
  }

  Future<void> _geriBildirimleriGetir() async {
    setState(() {
      yukleniyor = true;
      hata = null;
    });

    try {
      final response = await http.get(
        Uri.parse('$backendUrl/feedbacks'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> list = data['yorumlar'];
        setState(() {
          yorumlar = list.cast<String>();
          yukleniyor = false;
        });
      } else {
        setState(() {
          hata = "Sunucudan veri alınamadı: ${response.statusCode}";
          yukleniyor = false;
        });
      }
    } catch (e) {
      setState(() {
        hata = "Hata oluştu: $e";
        yukleniyor = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    if (yukleniyor) {
      return Scaffold(
        appBar:  AppBar(title: Text(loc.feedbacksTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (hata != null) {
      return Scaffold(
        appBar:  AppBar(title: Text(loc.feedbacksTitle)),
        body: Center(child: Text(hata!)),
      );
    }

    if (yorumlar.isEmpty) {
      return Scaffold(
        appBar:  AppBar(title: Text(loc.feedbacksTitle)),
        body: Center(child: Text(loc.noFeedbacks)),
      );
    }

    return Scaffold(
      appBar:  AppBar(title: Text(loc.feedbacksTitle)),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: yorumlar.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text(yorumlar[index]),
          );
        },
      ),
    );
  }
}
