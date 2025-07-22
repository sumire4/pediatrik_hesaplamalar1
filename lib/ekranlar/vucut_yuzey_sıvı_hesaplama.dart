import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VucutYuzeyAlaniVeSiviScreen extends StatefulWidget {
  const VucutYuzeyAlaniVeSiviScreen({super.key});

  @override
  State<VucutYuzeyAlaniVeSiviScreen> createState() => _VucutYuzeyAlaniVeSiviScreenState();
}

class _VucutYuzeyAlaniVeSiviScreenState extends State<VucutYuzeyAlaniVeSiviScreen> {
  final TextEditingController _kiloController = TextEditingController();
  final TextEditingController _carpanController = TextEditingController();

  void _hesapla() {
    String kiloText = _kiloController.text.replaceAll(',', '.');
    String carpanText = _carpanController.text.replaceAll(',', '.');

    double? kilo = double.tryParse(kiloText);
    double? carpan = double.tryParse(carpanText);

    if (kilo == null || carpan == null || kilo <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanlara geçerli değerler girin.')),
      );
      return;
    }

    // Yüzey Alanı (m²)
    double yuzeyAlani = ((kilo * 4) + 7) / (kilo + 90);

    // Sıvı Miktarları
    double gunlukSivi = yuzeyAlani * carpan;
    double saatlikSivi = gunlukSivi / 24;

    final sonucText =
        'Vücut Yüzey Alanı: ${yuzeyAlani.toStringAsFixed(2)} m²\n'
        'Saatlik Sıvı Miktarı: ${saatlikSivi.toStringAsFixed(2)} cc/saat\n'
        'Günlük Sıvı Miktarı: ${gunlukSivi.toStringAsFixed(2)} cc/gün';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        final bottomPadding = MediaQuery.of(context).viewPadding.bottom + 20;
        return Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, bottomPadding),
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
                      onPressed: () => Navigator.of(context).pop(),
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
        title: const Text('Vücut Yüzey Alanı ve Sıvı Miktarı'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: _kiloController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Kilo (kg)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _carpanController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'm²ye verilecek sıvı miktarı',
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
                              'Yüzey Alanı (m²) = [(Kilo × 4) + 7] / (Kilo + 90)\n'
                              'Saatlik Sıvı Miktarı = Yüzey Alanı × Çarpan\n'
                              'Günlük Sıvı Miktarı = Saatlik Sıvı Miktarı × 24\n'
                              'şeklinde hesaplanır',
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
          ],
        ),
      ),
    );
  }
}
