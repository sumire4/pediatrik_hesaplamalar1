import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DuzeltilmisKalsiyumHesaplamaScreen extends StatefulWidget {
  const DuzeltilmisKalsiyumHesaplamaScreen({super.key});

  @override
  State<DuzeltilmisKalsiyumHesaplamaScreen> createState() => _DuzeltilmisKalsiyumHesaplamaScreenState();
}

class _DuzeltilmisKalsiyumHesaplamaScreenState extends State<DuzeltilmisKalsiyumHesaplamaScreen> {
  final TextEditingController _kalsiyumController = TextEditingController();
  final TextEditingController _albuminController = TextEditingController();

  String _sonuc = '';

  List<String> _gecmisHesaplamalar = [];

  @override
  void initState() {
    super.initState();
    _loadGecmis();
  }

  Future<void> _loadGecmis() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _gecmisHesaplamalar = prefs.getStringList('gecmis_kalsiyum') ?? [];
    });
  }

  Future<void> _saveGecmis() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('gecmis_kalsiyum', _gecmisHesaplamalar);
  }


  Future<void> _hesapla() async {
    String kalsiyumText = _kalsiyumController.text.replaceAll(',', '.');
    String albuminText = _albuminController.text.replaceAll(',', '.');

    double? kalsiyum = double.tryParse(kalsiyumText);
    double? albumin = double.tryParse(albuminText);

    if (kalsiyum == null || albumin == null) {
      final loc = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.validValueMessage)),
      );
      return;
    }

    // Formül: Düzeltilmiş Kalsiyum = Kalsiyum + (0.8 × (4 - Albümin))
    double duzeltilmisKalsiyum = kalsiyum + (0.8 * (4 - albumin));
    final loc = AppLocalizations.of(context)!;

    final sonucText = '${loc.correctedCalciumResult} ${duzeltilmisKalsiyum.toStringAsFixed(2)} mg/dl';

    // Geçmişe ekle ve kaydet
    _gecmisHesaplamalar.add(sonucText);
    await _saveGecmis();


    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        final bottomPadding = MediaQuery.of(context).viewPadding.bottom + 20; //navbar için
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
                  loc.resultTitle,
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
                      label: Text(loc.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: sonucText));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(loc.copiedToClipboard)),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        Navigator.of(context).pop();
                      },
                      child: Text(loc.close),
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

  void _showGecmis() {
    if (_gecmisHesaplamalar.isEmpty) {
      final loc = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.noHistoryMessage)),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        final loc = AppLocalizations.of(context)!;
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  loc.historyTooltip,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: _gecmisHesaplamalar.length,
                    itemBuilder: (context, index) {
                      final item = _gecmisHesaplamalar[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(item),
                          trailing: IconButton(
                            icon: const Icon(Icons.copy),
                            tooltip: loc.copy,
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: item));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(loc.resultCopied)),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  icon: const Icon(Icons.delete_forever),
                  label: Text(loc.clearHistory),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('gecmis_kalsiyum');
                    setState(() {
                      _gecmisHesaplamalar.clear();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(loc.historyCleared)),
                    );
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(loc.close),
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
        title: Text(loc.clcTitle),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: _kalsiyumController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: loc.calciumLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _albuminController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: loc.albuminLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.history),
                  tooltip: loc.historyTooltip,
                  onPressed: _showGecmis,
                ),
                ElevatedButton(
                  onPressed: _hesapla,
                  child: Text(loc.calculateButton),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  tooltip: loc.infoTooltip,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(loc.infoTooltip),
                        content: Text(
                          loc.calculationInfoCcal,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(loc.close),
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
