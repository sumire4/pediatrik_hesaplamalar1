import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KullanimLogEkrani extends StatefulWidget {
  const KullanimLogEkrani({super.key});

  @override
  State<KullanimLogEkrani> createState() => _KullanimLogEkraniState();
}

class _KullanimLogEkraniState extends State<KullanimLogEkrani> {
  List<Map<String, dynamic>> usageStats = [];

  @override
  void initState() {
    super.initState();
    loadUsageLogs();
  }

  Future<void> loadUsageLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = [
      'AdrenalinDozu',
      'AnyonGap',
      'Apgar',
      'DuzeltilmisKalsiyum',
      'DuzeltilmisSodyum',
      'DuzeltilmisQT',
      'DuzeltilmisRetikulosit',
      'EndotrakealTup',
      'SodyumFraksiyonelAtilim',
      'GFR',
      'GlaskowKomaSkalasi',
      'KreatininSiviDengesi',
      'TubulerFosforReabsorbsiyonu',
      'BMI',
      'VucutYuzeyAlaniVeSivi',
      'GunlukKalori',
      'YenidoganMayi',
      'PeriferikYayma',
      'KemikIligi',
    ];

    final List<Map<String, dynamic>> stats = [];

    for (var key in keys) {
      final count = prefs.getInt(key) ?? 0;
      stats.add({'key': key, 'count': count});
    }

    stats.sort((a, b) => b['count'].compareTo(a['count'])); // Büyükten küçüğe sırala

    setState(() {
      usageStats = stats;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kullanım Logları')),
      body: ListView.builder(
        itemCount: usageStats.length,
        itemBuilder: (context, index) {
          final stat = usageStats[index];
          return ListTile(
            title: Text(stat['key']),
            trailing: Text('${stat['count']} kez'),
          );
        },
      ),
    );
  }
}
