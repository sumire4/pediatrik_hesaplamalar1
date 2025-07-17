import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DuzeltilmisSodyumHesaplamaScreen extends StatefulWidget {
  const DuzeltilmisSodyumHesaplamaScreen({super.key});

  @override
  State<DuzeltilmisSodyumHesaplamaScreen> createState() => _DuzeltilmisSodyumHesaplamaScreenState();
}

class _DuzeltilmisSodyumHesaplamaScreenState extends State<DuzeltilmisSodyumHesaplamaScreen> {
  final TextEditingController _sodyumController = TextEditingController();
  final TextEditingController _glikozController = TextEditingController();

  String _sonuc = '';

  void _hesapla() {
    String sodyumText = _sodyumController.text.replaceAll(',', '.');
    String glikozText = _glikozController.text.replaceAll(',', '.');

    double? sodyum = double.tryParse(sodyumText);
    double? glikoz = double.tryParse(glikozText);

    if (sodyum == null || glikoz == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanlara geçerli değerler girin.')),
      );
      return;
    }

    // Formül: Düzeltilmiş Sodyum = Sodyum + ((Glikoz – 100) / 100) × 1.6
    double duzeltilmisSodyum = sodyum + ((glikoz - 100) / 100) * 1.6;

    final sonucText = 'Düzeltilmiş Sodyum: ${duzeltilmisSodyum.toStringAsFixed(2)} mmol/l';

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

    setState(() {
      _sonuc = sonucText; // Bu satır artık sonuç ekranında gösterilmiyor ama istersen kaldırabilirsin.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Düzeltilmiş Sodyum Hesaplama'),
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
                labelText: 'Sodyum (mmol/l)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _glikozController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Glikoz (mg/dl)',
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
                          'Düzeltilmiş Sodyum : Sodyum + ((Glikoz – 100) / 100) × 1.6 şekilde hesaplanır.',
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
            // Sonuç ekranda gösterilmiyor, sadece bottom sheet açılıyor.
          ],
        ),
      ),
    );
  }
}
