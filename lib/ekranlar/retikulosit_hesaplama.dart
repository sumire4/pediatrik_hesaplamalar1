import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DuzeltilmisRetikulositHesaplamaScreen extends StatefulWidget {
  const DuzeltilmisRetikulositHesaplamaScreen({super.key});

  @override
  State<DuzeltilmisRetikulositHesaplamaScreen> createState() => _DuzeltilmisRetikulositHesaplamaScreenState();
}

class _DuzeltilmisRetikulositHesaplamaScreenState extends State<DuzeltilmisRetikulositHesaplamaScreen> {
  final TextEditingController _retikulositController = TextEditingController();
  final TextEditingController _hematokritController = TextEditingController();

  String _sonuc = '';

  void _hesapla() {
    String retikulositText = _retikulositController.text.replaceAll(',', '.');
    String hematokritText = _hematokritController.text.replaceAll(',', '.');

    double? retikulosit = double.tryParse(retikulositText);
    double? hematokrit = double.tryParse(hematokritText);

    if (retikulosit == null || hematokrit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanlara geçerli değerler girin.')),
      );
      return;
    }

    // Formül: Düzeltilmiş Retikülosit = Retikülosit × (Hematokrit / 45)
    double duzeltilmisRetikulosit = retikulosit * (hematokrit / 45);

    final sonucText = 'Düzeltilmiş Retikülosit: ${duzeltilmisRetikulosit.toStringAsFixed(2)} %';

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
        title: const Text('Düzeltilmiş Retikülosit Hesaplama'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: _retikulositController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Retikülosit (%)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _hematokritController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Hematokrit (%)',
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
                          'Retikülosit × (Hematokrit / 45) şekilde hesaplanır.',
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
            // Sonuç ekranda gösterilmiyor, bottom sheet ile gösteriliyor
          ],
        ),
      ),
    );
  }
}
