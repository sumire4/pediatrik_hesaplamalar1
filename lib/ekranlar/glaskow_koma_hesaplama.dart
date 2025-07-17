import 'package:flutter/material.dart';

class GlaskowKomaSkalasiScreen extends StatefulWidget {
  const GlaskowKomaSkalasiScreen({super.key});

  @override
  State<GlaskowKomaSkalasiScreen> createState() => _GlaskowKomaSkalasiScreenState();
}

class _GlaskowKomaSkalasiScreenState extends State<GlaskowKomaSkalasiScreen> {
  bool _isChild = false;

  int? _gozYaniti;
  int? _sozluYaniti;
  int? _motorYaniti;

  final Map<String, int> gozYanitlari = {
    'Spontan': 4,
    'Sesle': 3,
    'Ağrıyla': 2,
    'Yok': 1,
  };

  final Map<String, int> sozluYanitlariYetiskin = {
  'Yönelimli': 5,
  'Konfüze': 4,
  'Uygunsuz Kelimeler': 3,
  'Anlaşılmaz Sesler': 2,
  'Yok': 1,
  };

  final Map<String, int> sozluYanitlariCocuk = {
    'Gülümseme/Koos': 5,
    'Ağlama ama teselli edilebilir': 4,
    'Uygunsuz ağlama': 3,
    'İnleme': 2,
    'Yok': 1,
  };

  final Map<String, int> motorYanitlari = {
    'Emirleri yerine getirir': 6,
    'Ağrıyı lokalize eder': 5,
    'Ağrıya karşı çekme': 4,
    'Anormal fleksiyon (dekortike)': 3,
    'Anormal ekstensiyon (deserebre)': 2,
    'Yok': 1,
  };

  void _hesapla() {
    if (_gozYaniti == null || _sozluYaniti == null || _motorYaniti == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları seçin.')),
      );
      return;
    }

    int toplamSkor = _gozYaniti! + _sozluYaniti! + _motorYaniti!;
    String sonuc = 'Glaskow Koma Skoru: $toplamSkor';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Text(
              'Hesaplama Sonucu',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              sonuc,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Kapat'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, int> sozluMap = _isChild ? sozluYanitlariCocuk : sozluYanitlariYetiskin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Glaskow Koma Skalası Hesaplama'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            SwitchListTile(
              title: const Text('2 yaş altı (modifiye ölçek)'),
              value: _isChild,
              onChanged: (val) => setState(() => _isChild = val),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: 'Göz Yanıtı',
                border: OutlineInputBorder(),
              ),
              items: gozYanitlari.entries
                  .map((e) => DropdownMenuItem(value: e.value, child: Text(e.key)))
                  .toList(),
              onChanged: (val) => setState(() => _gozYaniti = val),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: 'Sözlü Yanıtı',
                border: OutlineInputBorder(),
              ),
              items: sozluMap.entries
                  .map((e) => DropdownMenuItem(value: e.value, child: Text(e.key)))
                  .toList(),
              onChanged: (val) => setState(() => _sozluYaniti = val),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: 'Motor Yanıtı',
                border: OutlineInputBorder(),
              ),
              items: motorYanitlari.entries
                  .map((e) => DropdownMenuItem(value: e.value, child: Text(e.key)))
                  .toList(),
              onChanged: (val) => setState(() => _motorYaniti = val),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: _hesapla,
                  child: const Text('Hesapla'),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  tooltip: 'Hesaplama Bilgisi',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Hesaplama Bilgisi'),
                        content: const Text(
                          'Glaskow Koma Skalası : Göz + Sözlü + Motor yanıt değerlerinin toplamıdır.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Kapat'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
