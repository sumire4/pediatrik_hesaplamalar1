import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DuzeltilmisKalsiyumHesaplamaScreen extends StatefulWidget {
  const DuzeltilmisKalsiyumHesaplamaScreen({super.key});

  @override
  State<DuzeltilmisKalsiyumHesaplamaScreen> createState() => _DuzeltilmisKalsiyumHesaplamaScreenState();
}

class _DuzeltilmisKalsiyumHesaplamaScreenState extends State<DuzeltilmisKalsiyumHesaplamaScreen> {
  final TextEditingController _kalsiyumController = TextEditingController();
  final TextEditingController _albuminController = TextEditingController();

  String _sonuc = '';

  void _hesapla() {
    String kalsiyumText = _kalsiyumController.text.replaceAll(',', '.');
    String albuminText = _albuminController.text.replaceAll(',', '.');

    double? kalsiyum = double.tryParse(kalsiyumText);
    double? albumin = double.tryParse(albuminText);

    if (kalsiyum == null || albumin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanlara geçerli değerler girin.')),
      );
      return;
    }

    // Formül: Düzeltilmiş Kalsiyum = Kalsiyum + (0.8 × (4 - Albümin))
    double duzeltilmisKalsiyum = kalsiyum + (0.8 * (4 - albumin));

    final sonucText = 'Düzeltilmiş Kalsiyum: ${duzeltilmisKalsiyum.toStringAsFixed(2)} mg/dl';

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
      _sonuc = sonucText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Düzeltilmiş Kalsiyum Hesaplama'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: _kalsiyumController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Kalsiyum (mg/dl)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _albuminController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Albümin (g/dl)',
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
                          'Düzeltilmiş Kalsiyum: = Kalsiyum + (0.8 × (4 - Albümin)) şekilde hesaplanır.',
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
