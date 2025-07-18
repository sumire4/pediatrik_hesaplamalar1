import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdrenalinHesaplamaScreen extends StatefulWidget {
  const AdrenalinHesaplamaScreen({super.key});

  @override
  State<AdrenalinHesaplamaScreen> createState() => _AdrenalinHesaplamaScreenState();
}

class _AdrenalinHesaplamaScreenState extends State<AdrenalinHesaplamaScreen> {
  final TextEditingController _kiloController = TextEditingController();
  double? _selectedKonsantrasyon;
  String _sonuc = '';

  final List<double> _konsantrasyonlar = [0.25, 0.5, 1.0];

  Future<void> _hesapla() async {
    FocusScope.of(context).unfocus();
    await Future.delayed(const Duration(milliseconds: 100));
    String girilenKilo = _kiloController.text.replaceAll(',', '.');
    double? kilo = double.tryParse(girilenKilo);

    if (kilo == null || _selectedKonsantrasyon == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen geçerli kilo ve konsantrasyon girin.')),
      );
      return;
    }

    double dozMg = 0.01 * kilo;
    double hacimMl = 0.1 * kilo;

    if (_selectedKonsantrasyon == 1.0 && dozMg > 1.0) {
      dozMg = 1.0;
    }

    final sonucText = 'Doz: ${dozMg.toStringAsFixed(2)} mg\n'
        'Hacim: ${hacimMl.toStringAsFixed(2)} ml\n'
        'Konsantrasyon: $_selectedKonsantrasyon mg/ml';

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
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        await Future.delayed(const Duration(milliseconds: 200));
                        if (mounted) Navigator.of(context).pop();
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
        title: const Text('Adrenalin Dozu Hesaplama'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _kiloController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Kilo (kg)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Konsantrasyon Seçin:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                children: _konsantrasyonlar.map((value) {
                  return RadioListTile<double>(
                    title: Text('$value mg/ml'),
                    value: value,
                    groupValue: _selectedKonsantrasyon,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedKonsantrasyon = newValue;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
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
                                'Doz (mg) = 0.01 × kilo\n'
                                'Hacim (ml) = 0.1 × kilo\n'
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
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade100),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 60,
                      color: Colors.white60,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Her hasta için en iyi tedavi şeklini, en doğru ilaçları ve dozları belirlemek uygulamayı yapan hekimin sorumluluğundadır',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
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
      ),
    );
  }
}
