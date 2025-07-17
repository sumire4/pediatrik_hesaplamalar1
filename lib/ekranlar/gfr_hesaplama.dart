import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GfrHesaplamaScreen extends StatefulWidget {
  const GfrHesaplamaScreen({super.key});

  @override
  State<GfrHesaplamaScreen> createState() => _GfrHesaplamaScreenState();
}

class _GfrHesaplamaScreenState extends State<GfrHesaplamaScreen> {
  final TextEditingController _kiloController = TextEditingController();
  final TextEditingController _idrarKreatininController = TextEditingController();
  final TextEditingController _plazmaKreatininController = TextEditingController();
  final TextEditingController _idrarUreController = TextEditingController();
  final TextEditingController _plazmaUreController = TextEditingController();
  final TextEditingController _idrarHacmiController = TextEditingController();

  void _hesapla() {
    String kiloText = _kiloController.text.replaceAll(',', '.');
    String idrarKreatininText = _idrarKreatininController.text.replaceAll(',', '.');
    String plazmaKreatininText = _plazmaKreatininController.text.replaceAll(',', '.');
    String idrarUreText = _idrarUreController.text.replaceAll(',', '.');
    String plazmaUreText = _plazmaUreController.text.replaceAll(',', '.');
    String idrarHacmiText = _idrarHacmiController.text.replaceAll(',', '.');

    double? kilo = double.tryParse(kiloText);
    double? idrarKreatinin = double.tryParse(idrarKreatininText);
    double? plazmaKreatinin = double.tryParse(plazmaKreatininText);
    double? idrarUre = double.tryParse(idrarUreText);
    double? plazmaUre = double.tryParse(plazmaUreText);
    double? idrarHacmi = double.tryParse(idrarHacmiText);

    if (kilo == null ||
        idrarKreatinin == null ||
        plazmaKreatinin == null ||
        idrarUre == null ||
        plazmaUre == null ||
        idrarHacmi == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanlara geçerli değerler girin.')),
      );
      return;
    }

    // Metrekare hesabı
    double metrekare = (kilo * 1.73) / 60;

    // Kreatinin Klerensi
    double kreatininKlerensi =
        (idrarKreatinin * idrarHacmi) / (plazmaKreatinin * 1440 * metrekare);

    // Üre Klerensi
    double ureKlerensi = (idrarUre * idrarHacmi) / (plazmaUre * 1440 * metrekare);

    // GFR
    double gfr = (kreatininKlerensi + ureKlerensi) / 2;

    final sonucText =
        'GFR (ml/dk/1.73 m²): ${gfr.toStringAsFixed(2)}\n'
        'Kreatinin Klerensi: ${kreatininKlerensi.toStringAsFixed(2)}\n'
        'Üre Klerensi: ${ureKlerensi.toStringAsFixed(2)}';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
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
                      onPressed: () { Navigator.of(context).pop();FocusScope.of(context).unfocus();},
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
        title: const Text('GFR Hesaplama (Kreatinin Klerensi)'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
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
              controller: _idrarKreatininController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'İdrar Kreatinin (mg/dL)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _plazmaKreatininController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Plazma Kreatinin (mg/dL)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _idrarUreController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'İdrar Üre (mg/dL)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _plazmaUreController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Plazma Üre (mg/dL)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _idrarHacmiController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'İdrar Hacmi (ml)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
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
                          '24 saatlik idrar, plazma kreatinin, kilo ve idrar hacmine göre glomerüler filtrasyon hızı hesaplanır.\n'
                          'Formüller:\n'
                          '• Metrekare = (Kilo × 1.73) / 60\n\n'
                          '• Kreatinin Klerensi = (İdrarKreatinin × Hacim) / (PlazmaKreatinin × 1440 × Metrekare)\n\n'
                          '• Üre Klerensi = (İdrarÜre × Hacim) / (PlazmaÜre × 1440 × Metrekare)\n\n'
                          '• GFR = (Kreatinin Klerensi + Üre Klerensi) / 2'
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
