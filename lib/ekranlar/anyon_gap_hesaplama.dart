import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnyonGapHesaplamaScreen extends StatefulWidget {
  const AnyonGapHesaplamaScreen({super.key});

  @override
  State<AnyonGapHesaplamaScreen> createState() => _AnyonGapHesaplamaScreenState();
}

class _AnyonGapHesaplamaScreenState extends State<AnyonGapHesaplamaScreen> {
  final TextEditingController _sodyumController = TextEditingController();
  final TextEditingController _klorController = TextEditingController();
  final TextEditingController _bikarbonatController = TextEditingController();

  String _sonuc = '';

  void _hesapla() {
    String sodyumText = _sodyumController.text.replaceAll(',', '.');
    String klorText = _klorController.text.replaceAll(',', '.');
    String bikarbonatText = _bikarbonatController.text.replaceAll(',', '.');

    double? sodyum = double.tryParse(sodyumText);
    double? klor = double.tryParse(klorText);
    double? bikarbonat = double.tryParse(bikarbonatText);

    if (sodyum == null || klor == null || bikarbonat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanlara geçerli değerler girin.')),
      );
      return;
    }

    double anyonGap = sodyum - (klor + bikarbonat);

    final sonucText = 'Anyon Gap: ${anyonGap.toStringAsFixed(2)} mEq/L';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
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
                  sonucText,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.copy),
                      label: const Text('Kopyala'),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: sonucText));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sonuç panoya kopyalandı.')),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Kapat'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anyon Gap Hesaplama'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: _sodyumController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Sodyum (mEq/L)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _klorController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Klor (mEq/L)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bikarbonatController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Bikarbonat (mEq/L)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
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
                          'Anyon Gap: Sodyum – (Klor + Bikarbonat) şekilde hesaplanır.\n\n'
                              'Normal Değerler : 9 - 17 mEq/L arasındadır.',
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

            const SizedBox(height: 16),
            Text(
              _sonuc,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
