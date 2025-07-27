import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BmiHesaplamaScreen extends StatefulWidget {
  const BmiHesaplamaScreen({super.key});

  @override
  State<BmiHesaplamaScreen> createState() => _BmiHesaplamaScreenState();
}

class _BmiHesaplamaScreenState extends State<BmiHesaplamaScreen> {
  final TextEditingController _boyController = TextEditingController();
  final TextEditingController _kiloController = TextEditingController();

  void _hesapla() {
    final loc = AppLocalizations.of(context)!;
    String boyText = _boyController.text.replaceAll(',', '.');
    String kiloText = _kiloController.text.replaceAll(',', '.');

    double? boyCm = double.tryParse(boyText);
    double? kilo = double.tryParse(kiloText);

    if (boyCm == null || kilo == null || boyCm == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.bmiInvalidInput)),
      );
      return;
    }

    double boyMetre = boyCm / 100;
    double bmi = kilo / (boyMetre * boyMetre);
    String bmiDegeri = bmi.toStringAsFixed(2);

    String kategori = '';
    if (bmi < 18.5) {
      kategori = loc.bmiCategoryUnderweight;
    } else if (bmi < 25) {
      kategori = loc.bmiCategoryNormal;
    } else if (bmi < 30) {
      kategori = loc.bmiCategoryOverweight;
    } else {
      kategori = loc.bmiCategoryObese;
    }

    final sonucText = '${loc.bmiResultText} ${bmi.toStringAsFixed(2)} kg/m²';

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
                  loc.bmiResultTitle,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  sonucText,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  kategori,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.copy),
                      label: Text(loc.copyButton),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: sonucText));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(loc.bmiCopiedMessage)),
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
        title: Text(loc.bmiTitle),
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
              decoration: InputDecoration(
                labelText: loc.bmiHeightLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _kiloController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: loc.bmiWeightLabel,
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
                  child: Text(loc.bmiCalculate),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  tooltip: loc.bmiTooltip,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(loc.bmiTooltip),
                        content: Text(
                          loc.bmiInfoContent,
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
