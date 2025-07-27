import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AnyonGapHesaplamaScreen extends StatefulWidget {
  const AnyonGapHesaplamaScreen({super.key});

  @override
  State<AnyonGapHesaplamaScreen> createState() => _AnyonGapHesaplamaScreenState();
}

class _AnyonGapHesaplamaScreenState extends State<AnyonGapHesaplamaScreen> {
  final TextEditingController _sodyumController = TextEditingController();
  final TextEditingController _klorController = TextEditingController();
  final TextEditingController _bikarbonatController = TextEditingController();
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
      _gecmisHesaplamalar = prefs.getStringList('gecmis_anyongap') ?? [];
    });
  }

  Future<void> _saveGecmis() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('gecmis_anyongap', _gecmisHesaplamalar);
  }

  Future<void> _hesapla() async {
    String sodyumText = _sodyumController.text.replaceAll(',', '.');
    String klorText = _klorController.text.replaceAll(',', '.');
    String bikarbonatText = _bikarbonatController.text.replaceAll(',', '.');

    double? sodyum = double.tryParse(sodyumText);
    double? klor = double.tryParse(klorText);
    double? bikarbonat = double.tryParse(bikarbonatText);

    if (sodyum == null || klor == null || bikarbonat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanlara geçerli değerler girin.')),
      );
      return;
    }

    double anyonGap = sodyum - (klor + bikarbonat);
    final loc = AppLocalizations.of(context)!;
    final sonucText = '${loc.resultPrefixAg} ${anyonGap.toStringAsFixed(2)} mEq/L';

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
        final loc = AppLocalizations.of(context)!;
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
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  loc.historyTitle,
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
                                const SnackBar(content: Text('Geçmiş veri kopyalandı.')),
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
                    await prefs.remove('gecmis_anyongap');
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
        title: Text(loc.anyonGapScreenTitle),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: _sodyumController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: loc.sodyumLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _klorController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: loc.klorLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bikarbonatController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: loc.bikarbonatLabel,
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
                        title: Text(loc.calculationInfoTitle),
                        content: Text(
                          loc.calculationInfoContentAg,
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
            Text(
              _sonuc,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
