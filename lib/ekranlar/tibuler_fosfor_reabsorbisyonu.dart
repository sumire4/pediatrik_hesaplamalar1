import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TubulerFosforReabsorbsiyonuScreen extends StatefulWidget {
  const TubulerFosforReabsorbsiyonuScreen({super.key});

  @override
  State<TubulerFosforReabsorbsiyonuScreen> createState() => _TubulerFosforReabsorbsiyonuScreenState();
}

class _TubulerFosforReabsorbsiyonuScreenState extends State<TubulerFosforReabsorbsiyonuScreen> {
  final TextEditingController _idrarFosforController = TextEditingController();
  final TextEditingController _plazmaKreatininController = TextEditingController();
  final TextEditingController _idrarKreatininController = TextEditingController();
  final TextEditingController _plazmaFosforController = TextEditingController();

  void _hesapla() {
    String idrFosforText = _idrarFosforController.text.replaceAll(',', '.');
    String plazmaKreatininText = _plazmaKreatininController.text.replaceAll(',', '.');
    String idrKreatininText = _idrarKreatininController.text.replaceAll(',', '.');
    String plazmaFosforText = _plazmaFosforController.text.replaceAll(',', '.');

    double? idrFosfor = double.tryParse(idrFosforText);
    double? plazmaKreatinin = double.tryParse(plazmaKreatininText);
    double? idrKreatinin = double.tryParse(idrKreatininText);
    double? plazmaFosfor = double.tryParse(plazmaFosforText);

    if ([idrFosfor, plazmaKreatinin, idrKreatinin, plazmaFosfor].contains(null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanlara geçerli değerler girin.')),
      );
      return;
    }

    double oran = (idrFosfor! * plazmaKreatinin!) / (idrKreatinin! * plazmaFosfor!);
    double reabsorpsiyon = (1 - oran) * 100;

    final sonucText = 'Tübüler Fosfor Reabsorpsiyonu: ${reabsorpsiyon.toStringAsFixed(2)} %';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tübüler Fosfor Reabsorbsiyonu'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildField(_idrarFosforController, 'İdrar Fosfor (mg/dl)'),
            const SizedBox(height: 16),
            _buildField(_plazmaKreatininController, 'Plazma Kreatinin (mg/dl)'),
            const SizedBox(height: 16),
            _buildField(_idrarKreatininController, 'İdrar Kreatinin (mg/dl)'),
            const SizedBox(height: 16),
            _buildField(_plazmaFosforController, 'Plazma Fosfor (mg/dl)'),
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
                          '[1 - ((İdrarFosfor × PlazmaKreatinin) / (İdrarKreatinin × PlazmaFosfor))] × 100 şeklinde hesaplanır.',
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
}
