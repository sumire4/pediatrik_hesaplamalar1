import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BmiHesaplamaScreen extends StatefulWidget {
  const BmiHesaplamaScreen({super.key});

  @override
  State<BmiHesaplamaScreen> createState() => _BmiHesaplamaScreenState();
}

class _BmiHesaplamaScreenState extends State<BmiHesaplamaScreen> {
  final TextEditingController _boyController = TextEditingController();
  final TextEditingController _kiloController = TextEditingController();

  void _hesapla() {
    String boyText = _boyController.text.replaceAll(',', '.');
    String kiloText = _kiloController.text.replaceAll(',', '.');

    double? boyCm = double.tryParse(boyText);
    double? kilo = double.tryParse(kiloText);

    if (boyCm == null || kilo == null || boyCm == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanlara geçerli değerler girin.')),
      );
      return;
    }

    double boyMetre = boyCm / 100;
    double bmi = kilo / (boyMetre * boyMetre);

    final sonucText = 'Vücut Kitle İndeksi (BMI): ${bmi.toStringAsFixed(2)} kg/m²';

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
        title: const Text('Vücut Kitle İndeksi (BMI) Hesaplama'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: _boyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Boy (cm)',
                border: OutlineInputBorder(),
              ),
            ),
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
            ElevatedButton(
              onPressed: _hesapla,
              child: const Text('Hesapla'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
