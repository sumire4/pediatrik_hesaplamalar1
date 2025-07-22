import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KreatininSiviDengesiScreen extends StatefulWidget {
  const KreatininSiviDengesiScreen({super.key});

  @override
  State<KreatininSiviDengesiScreen> createState() => _KreatininSiviDengesiScreenState();
}

class _KreatininSiviDengesiScreenState extends State<KreatininSiviDengesiScreen> {
  final _idrarkreatininController = TextEditingController();
  final _idrarHacmiController = TextEditingController();
  final _plazmaKreatininController = TextEditingController();
  final _boyController = TextEditingController();
  final _kiloController = TextEditingController();

  void _hesapla() {
    // Kullanıcıdan alınan verileri parse et
    String ikText = _idrarkreatininController.text.replaceAll(',', '.');
    String ihText = _idrarHacmiController.text.replaceAll(',', '.');
    String pkText = _plazmaKreatininController.text.replaceAll(',', '.');
    String boyText = _boyController.text.replaceAll(',', '.');
    String kiloText = _kiloController.text.replaceAll(',', '.');

    double? ik = double.tryParse(ikText);
    double? ih = double.tryParse(ihText);
    double? pk = double.tryParse(pkText);
    double? boy = double.tryParse(boyText);
    double? kilo = double.tryParse(kiloText);

    if ([ik, ih, pk, boy, kilo].contains(null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanlara geçerli değerler girin.')),
      );
      return;
    }

    double gfr = (ik! * ih!) / (pk! * 1440);
    double bsa = (boy! * kilo!) / 3600;
    double gfrNormalized = (gfr / bsa) * 1.73;

    String yorum = gfrNormalized < 30
        ? '⚠️ GFR < 30 → Sıvı kısıtlaması önerilir.'
        : '✅ GFR normal → Sıvı kısıtlaması gerekmez.';

    final sonucText = '''
Günlük GFR: ${gfr.toStringAsFixed(2)} ml/dk
Vücut Yüzey Alanı: ${bsa.toStringAsFixed(2)} m²
GFR (normalize): ${gfrNormalized.toStringAsFixed(2)} ml/dk/1.73m²

$yorum
''';

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
                Text(sonucText, style: const TextStyle(fontSize: 16)),
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
        title: const Text('Kreatinin Atılımı ve Sıvı Dengesi'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            _buildField(_idrarkreatininController, 'İdrar Kreatinin (mg/dl)'),
            const SizedBox(height: 12),
            _buildField(_idrarHacmiController, 'İdrar Hacmi (ml)'),
            const SizedBox(height: 12),
            _buildField(_plazmaKreatininController, 'Plazma Kreatinin (mg/dl)'),
            const SizedBox(height: 12),
            _buildField(_boyController, 'Boy (cm)'),
            const SizedBox(height: 12),
            _buildField(_kiloController, 'Kilo (kg)'),
            const SizedBox(height: 20),
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
                          'İdrar çıkışı ve kreatinin değerlerine göre sıvı dengesi ve atılım hesaplanır.\n\n'
                          '• Günlük GFR = (İdrarKreatinin × İdrarHacmi) / (PlazmaKreatinin × 1440)\n'
                          '• Vücut yüzey alanı = (Boy × Kilo) / 3600\n'
                          '• GFR normalleştirilmiş = GFR / 1.73',
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

  Widget _buildField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
