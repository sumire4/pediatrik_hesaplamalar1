import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DuzeltilmisQTHesaplamaScreen extends StatefulWidget {
  const DuzeltilmisQTHesaplamaScreen({super.key});

  @override
  State<DuzeltilmisQTHesaplamaScreen> createState() => _DuzeltilmisQTHesaplamaScreenState();
}

class _DuzeltilmisQTHesaplamaScreenState extends State<DuzeltilmisQTHesaplamaScreen> {
  final TextEditingController _qtController = TextEditingController();
  final TextEditingController _rrController = TextEditingController();

  String _sonuc = '';

  void _hesapla() {
    String qtText = _qtController.text.replaceAll(',', '.');
    String rrText = _rrController.text.replaceAll(',', '.');

    double? qt = double.tryParse(qtText);
    double? rr = double.tryParse(rrText);

    if (qt == null || rr == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanlara geçerli değerler girin.')),
      );
      return;
    }

    double duzeltilmisQT = qt * sqrt(0.04 / rr);

    final sonucText = 'Düzeltilmiş QT: ${duzeltilmisQT.toStringAsFixed(3)} sn';

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
        title: const Text('Düzeltilmiş QT Hesaplama'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: _qtController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'QT (sn)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _rrController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'RR (sn)',
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
                          'Düzeltilmiş QT : QT × √(0.04 / RR) şekilde hesaplanır.\n\n'
                              'Normal Değerler : <0.44sn',
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
