import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final loc = AppLocalizations.of(context)!;
    String retikulositText = _retikulositController.text.replaceAll(',', '.');
    String hematokritText = _hematokritController.text.replaceAll(',', '.');

    double? retikulosit = double.tryParse(retikulositText);
    double? hematokrit = double.tryParse(hematokritText);

    if (retikulosit == null || hematokrit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.validValueMessage)),
      );
      return;
    }

    // Formül: Düzeltilmiş Retikülosit = Retikülosit × (Hematokrit / 45)
    double duzeltilmisRetikulosit = retikulosit * (hematokrit / 45);

    final sonucText = '${loc.resultText} ${duzeltilmisRetikulosit.toStringAsFixed(2)} %';

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
                  loc.resultDialogTitle,
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
                      label: Text(loc.copyButton),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: sonucText));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(loc.copySuccess)),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
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

    setState(() {
      _sonuc = sonucText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.retikulositTitle),
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
              decoration: InputDecoration(
                labelText: loc.retikulositFieldLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _hematokritController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: loc.hematokritFieldLabel,
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
                  child: Text(loc.calculateButton),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  tooltip: loc.infoButtonTooltip,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(loc.infoButtonTooltip),
                        content: Text(
                          loc.infoDialogContentrt,
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
            // Sonuç ekranda gösterilmiyor, bottom sheet ile gösteriliyor
          ],
        ),
      ),
    );
  }
}
