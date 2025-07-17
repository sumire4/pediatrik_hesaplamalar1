import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EndotrakealTupHesaplamaScreen extends StatefulWidget {
  const EndotrakealTupHesaplamaScreen({super.key});

  @override
  State<EndotrakealTupHesaplamaScreen> createState() => _EndotrakealTupHesaplamaScreenState();
}

class _EndotrakealTupHesaplamaScreenState extends State<EndotrakealTupHesaplamaScreen> {
  final TextEditingController _yasController = TextEditingController();

  void _hesapla() {
    String yasText = _yasController.text.replaceAll(',', '.');

    double? yas = double.tryParse(yasText);

    if (yas == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen geçerli bir yaş değeri girin.')),
      );
      return;
    }

    // Formüller:
    // Kafsiz Tüp Çapı = (Yaş / 4) + 4
    // Kafli Tüp Çapı = (Yaş / 4) + 3.5
    // ETT Derinliği = Tüp Çapı × 3  (Burada tüp çapı olarak kaflı tüp çapını alıyoruz)
    double kafsizTupCap = (yas / 4) + 4;
    double kafliTupCap = (yas / 4) + 3.5;
    double ettDerinligi = kafliTupCap * 3;

    final sonucText =
        'Kafsız Tüp Çapı: ${kafsizTupCap.toStringAsFixed(2)} mm\n'
        'Kaflı Tüp Çapı: ${kafliTupCap.toStringAsFixed(2)} mm\n'
        'ETT Derinliği: ${ettDerinligi.toStringAsFixed(2)} cm';

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
                  style: const TextStyle(fontSize: 16, height: 1.5),
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
        title: const Text('Yaşa Göre Endotrakeal Tüp Hesaplama'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: _yasController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Yaş (yıl)',
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
                          'Yaşa Göre Endotrakeal Tüp Hesaplama :'
                              'Kafsiz Tüp Çapı = (Yaş / 4) + 4\n'
                              'Kafli Tüp Çapı = (Yaş / 4) + 3.5\n'
                              'ETT Derinliği = Tüp Çapı × 3\n'
                              'şeklinde hesaplanır.',
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
