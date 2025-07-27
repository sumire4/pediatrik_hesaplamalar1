import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ApgarSkoruHesaplamaScreen extends StatefulWidget {
  const ApgarSkoruHesaplamaScreen({super.key});

  @override
  State<ApgarSkoruHesaplamaScreen> createState() => _ApgarSkoruHesaplamaScreenState();
}

class _ApgarSkoruHesaplamaScreenState extends State<ApgarSkoruHesaplamaScreen> {
  int? _gorusum;
  int? _refleks;
  int? _tonus;
  int? _solunum;
  int? _nabiz;

  String _sonuc = '';

  Map<int, String> _puanlarGorusum(BuildContext context) => {
    0: AppLocalizations.of(context)!.gorunum0,
    1: AppLocalizations.of(context)!.gorunum1,
    2: AppLocalizations.of(context)!.gorunum2,
  };

  Map<int, String> _puanlarRefleks(BuildContext context) => {
    0: AppLocalizations.of(context)!.refleks0,
    1: AppLocalizations.of(context)!.refleks1,
    2: AppLocalizations.of(context)!.refleks2,
  };

  Map<int, String> _puanlarTonus(BuildContext context) => {
    0: AppLocalizations.of(context)!.tonus0,
    1: AppLocalizations.of(context)!.tonus1,
    2: AppLocalizations.of(context)!.tonus2,
  };

  Map<int, String> _puanlarSolunum(BuildContext context) => {
    0: AppLocalizations.of(context)!.solunum0,
    1: AppLocalizations.of(context)!.solunum1,
    2: AppLocalizations.of(context)!.solunum2,
  };

  Map<int, String> _puanlarNabiz(BuildContext context) => {
    0: AppLocalizations.of(context)!.nabiz0,
    1: AppLocalizations.of(context)!.nabiz1,
    2: AppLocalizations.of(context)!.nabiz2,
  };


  List<String> _gecmisHesaplamalar = [];

  @override
  void initState() {
    super.initState();
    _loadGecmis();
  }

  Future<void> _loadGecmis() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _gecmisHesaplamalar = prefs.getStringList('gecmis_apgar') ?? [];
    });
  }

  Future<void> _saveGecmis() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('gecmis_apgar', _gecmisHesaplamalar);
  }


  Future<void> _hesapla() async {
    final loc = AppLocalizations.of(context)!;
    if (_gorusum == null || _refleks == null || _tonus == null || _solunum == null || _nabiz == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.plzSelectAll)),
      );
      return;
    }

    int toplam = _gorusum! + _refleks! + _tonus! + _solunum! + _nabiz!;
    int apgarSkoru = toplam;

    final sonucText = '${loc.resultPrefix} $apgarSkoru';

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
                    await prefs.remove('gecmis_apgar');
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


  Widget _buildDropdown(String label, int? currentValue, Map<int, String> puanlar, void Function(int?) onChanged) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButton<int>(
          isExpanded: true,
          value: currentValue,
          hint: Text(loc.selectText),
          items: puanlar.entries.map((entry) {
            return DropdownMenuItem<int>(
              value: entry.key,
              child: Text(entry.value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.apgarScreenTitle),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDropdown(loc.gorunumLabel, _gorusum, _puanlarGorusum(context), (val) {
              setState(() {
                _gorusum = val;
              });
            }),
            _buildDropdown(loc.refleksLabel, _refleks, _puanlarRefleks(context), (val) {
              setState(() {
                _refleks = val;
              });
            }),
            _buildDropdown(loc.tonusLabel, _tonus, _puanlarTonus(context), (val) {
              setState(() {
                _tonus = val;
              });
            }),
            _buildDropdown(loc.solunumLabel, _solunum, _puanlarSolunum(context), (val) {
              setState(() {
                _solunum = val;
              });
            }),
            _buildDropdown(loc.nabizLabel, _nabiz, _puanlarNabiz(context), (val) {
              setState(() {
                _nabiz = val;
              });
            }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.history),
                  tooltip: loc.historyTitle,
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
                            loc.calculationInfoContent,
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
