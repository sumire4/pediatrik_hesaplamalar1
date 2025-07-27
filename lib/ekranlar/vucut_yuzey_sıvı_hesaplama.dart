import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VucutYuzeyAlaniVeSiviScreen extends StatefulWidget {
  const VucutYuzeyAlaniVeSiviScreen({super.key});

  @override
  State<VucutYuzeyAlaniVeSiviScreen> createState() => _VucutYuzeyAlaniVeSiviScreenState();
}

class _VucutYuzeyAlaniVeSiviScreenState extends State<VucutYuzeyAlaniVeSiviScreen> {
  final TextEditingController _kiloController = TextEditingController();
  final TextEditingController _carpanController = TextEditingController();

  void _hesapla() {
    final loc = AppLocalizations.of(context)!;
    String kiloText = _kiloController.text.replaceAll(',', '.');
    String carpanText = _carpanController.text.replaceAll(',', '.');

    double? kilo = double.tryParse(kiloText);
    double? carpan = double.tryParse(carpanText);

    if (kilo == null || carpan == null || kilo <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.bsaInvalidInput)),
      );
      return;
    }

    // Yüzey Alanı (m²)
    double yuzeyAlani = ((kilo * 4) + 7) / (kilo + 90);

    // Sıvı Miktarları
    double gunlukSivi = yuzeyAlani * carpan;
    double saatlikSivi = gunlukSivi / 24;

    final sonucText =
        '${loc.bsaResultText1} ${yuzeyAlani.toStringAsFixed(2)} m²\n'
        '${loc.bsaResultcontext2} ${saatlikSivi.toStringAsFixed(2)} ${loc.bsaHour}\n'
        '${loc.bsaResultText3} ${gunlukSivi.toStringAsFixed(2)} ${loc.bsaDay}';

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
                Text(
                  loc.bsaResultTitle,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      label: Text(loc.bsaCopy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: sonucText));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(loc.bsaCopiedMessage)),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(loc.closeButton),
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
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.bsaTitle),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: _kiloController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: loc.bsaWeightLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _carpanController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: loc.bsaFluidPerM2Label,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: _hesapla,
                  child: Text(loc.bsaCalculate),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  tooltip: loc.bmiTooltip,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(loc.bmiInfoTitle),
                        content: Text(
                              loc.bsaInfoContent,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(loc.closeButton),
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
