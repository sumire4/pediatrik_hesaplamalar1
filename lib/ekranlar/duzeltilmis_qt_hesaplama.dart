import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DuzeltilmisQTHesaplamaScreen extends StatefulWidget {
  const DuzeltilmisQTHesaplamaScreen({super.key});

  @override
  State<DuzeltilmisQTHesaplamaScreen> createState() => _DuzeltilmisQTHesaplamaScreenState();
}

class _DuzeltilmisQTHesaplamaScreenState extends State<DuzeltilmisQTHesaplamaScreen> {
  final TextEditingController _qtController = TextEditingController();
  final TextEditingController _rrController = TextEditingController();

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
      _gecmisHesaplamalar = prefs.getStringList('gecmis_qt') ?? [];
    });
  }

  Future<void> _saveGecmis() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('gecmis_qt', _gecmisHesaplamalar);
  }

  Future<void> _hesapla() async {
    final loc = AppLocalizations.of(context)!;
    String qtText = _qtController.text.replaceAll(',', '.');
    String rrText = _rrController.text.replaceAll(',', '.');

    double? qt = double.tryParse(qtText);
    double? rr = double.tryParse(rrText);

    if (qt == null || rr == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.validValueMessage)),
      );
      return;
    }

    double duzeltilmisQT = qt*(0.04) / sqrt(0.04*rr);

    final sonucText = '${loc.correctedQTResult} ${duzeltilmisQT.toStringAsFixed(3)} sn';

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
                      label: Text(loc.copyButton),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: sonucText));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(loc.resultCopied)),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
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

  void _showGecmis() {
    final loc = AppLocalizations.of(context)!;
    if (_gecmisHesaplamalar.isEmpty) {
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
        final bottomPadding = MediaQuery.of(context).viewPadding.bottom + 20; //navbar için
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, bottomPadding), //navbariçin
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
                            tooltip: loc.copyButton,
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: item));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(loc.copiedToClipboard)),
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
                    await prefs.remove('gecmis_qt');
                    setState(() {
                      _gecmisHesaplamalar.clear();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(loc.historyClearedMessage)),
                    );
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(loc.closeButton),
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
        title: Text(loc.titleQT),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: _qtController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: loc.qtLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _rrController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: loc.rrLabel,
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
                         loc.calculationInfo,
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
