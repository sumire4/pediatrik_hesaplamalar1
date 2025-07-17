import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SodyumFraksiyonelAtilimScreen extends StatefulWidget {
  const SodyumFraksiyonelAtilimScreen({super.key});

  @override
  State<SodyumFraksiyonelAtilimScreen> createState() => _SodyumFraksiyonelAtilimScreenState();
}

class _SodyumFraksiyonelAtilimScreenState extends State<SodyumFraksiyonelAtilimScreen> {
  final TextEditingController _idrarNaController = TextEditingController();
  final TextEditingController _plazmaKreatininController = TextEditingController();
  final TextEditingController _idrarKreatininController = TextEditingController();
  final TextEditingController _plazmaNaController = TextEditingController();

  void _hesapla() {
    String idrarNaText = _idrarNaController.text.replaceAll(',', '.');
    String plazmaKreatininText = _plazmaKreatininController.text.replaceAll(',', '.');
    String idrarKreatininText = _idrarKreatininController.text.replaceAll(',', '.');
    String plazmaNaText = _plazmaNaController.text.replaceAll(',', '.');

    double? idrarNa = double.tryParse(idrarNaText);
    double? plazmaKreatinin = double.tryParse(plazmaKreatininText);
    double? idrarKreatinin = double.tryParse(idrarKreatininText);
    double? plazmaNa = double.tryParse(plazmaNaText);

    if (idrarNa == null || plazmaKreatinin == null || idrarKreatinin == null || plazmaNa == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanlara geçerli değerler girin.')),
      );
      return;
    }

    // Formül: FE Na (%) = (İdrarNa × PlazmaKreatinin) / (İdrarKreatinin × PlazmaNa) × 100
    double feNa = (idrarNa * plazmaKreatinin) / (idrarKreatinin * plazmaNa) * 100;

    final sonucText = 'FE Na (Fraksiyonel Sodyum Atılımı): ${feNa.toStringAsFixed(2)} %';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sodyum Fraksiyonel Atılım Hesaplama'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: _idrarNaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'İdrar Na',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _plazmaKreatininController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Plazma Kreatinin',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _idrarKreatininController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'İdrar Kreatinin',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _plazmaNaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Plazma Na',
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
                          'Sodyum Fraksiyonel Atılım : FE Na (%) = (İdrarNa × PlazmaKreatinin) / (İdrarKreatinin × PlazmaNa) × 100 şekilde hesaplanır.',
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
