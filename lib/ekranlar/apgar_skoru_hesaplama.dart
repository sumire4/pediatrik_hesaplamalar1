import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  final Map<int, String> _puanlarGorusum = {
    0: 'Siyonozlu veya Soluk (0)',
    1: 'Gövde Pembe Extremiteler Siyanozlu (1)',
    2: 'Pembe (2)',
  };

  final Map<int, String> _puanlarRefleks = {
    0: 'Yok (0)',
    1: 'Yüzde Hafif Mimik (1)',
    2: 'Aksırma Ağlama (2)',
  };

  final Map<int, String> _puanlarTonus = {
    0: 'Genel Hipotoni (0)',
    1: 'Extremitelerde Hafif Fleksion (1)',
    2: 'Aktif Hareketler (2)',
  };

  final Map<int, String> _puanlarSolunum = {
    0: 'Yok (0)',
    1: 'Yüzeysel Düzensiz İç Çekme (1)',
    2: 'Ağlıyor Düzenli (2)',
  };

  final Map<int, String> _puanlarNabiz = {
    0: 'Yok (0)',
    1: '<100/dk (1)',
    2: '>100/dk (2)',
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
    if (_gorusum == null || _refleks == null || _tonus == null || _solunum == null || _nabiz == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm parametreleri seçin.')),
      );
      return;
    }

    int toplam = _gorusum! + _refleks! + _tonus! + _solunum! + _nabiz!;
    int apgarSkoru = toplam;

    final sonucText = 'Apgar Skoru: $apgarSkoru';

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
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        Navigator.of(context).pop();
                      },
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

  void _showGecmis() {
    if (_gecmisHesaplamalar.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Henüz geçmiş hesaplama yok.')),
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
                const Text(
                  'Geçmiş Hesaplamalar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                            tooltip: 'Kopyala',
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
                  label: const Text('Geçmişi Temizle'),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('gecmis_apgar');
                    setState(() {
                      _gecmisHesaplamalar.clear();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Geçmiş temizlendi.')),
                    );
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Kapat'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _buildDropdown(String label, int? currentValue, Map<int, String> puanlar, void Function(int?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButton<int>(
          isExpanded: true,
          value: currentValue,
          hint: const Text('Seçiniz'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apgar Skoru Hesaplama'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDropdown('Görünüm', _gorusum, _puanlarGorusum, (val) {
              setState(() {
                _gorusum = val;
              });
            }),
            _buildDropdown('Refleks', _refleks, _puanlarRefleks, (val) {
              setState(() {
                _refleks = val;
              });
            }),
            _buildDropdown('Tonus', _tonus, _puanlarTonus, (val) {
              setState(() {
                _tonus = val;
              });
            }),
            _buildDropdown('Solunum', _solunum, _puanlarSolunum, (val) {
              setState(() {
                _solunum = val;
              });
            }),
            _buildDropdown('Nabız', _nabiz, _puanlarNabiz, (val) {
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
                  tooltip: 'Geçmiş Hesaplamalar',
                  onPressed: _showGecmis,
                ),
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
                          '7–10 puan: Normal (iyi durumda)\n'
                          '4–6 puan: Orta derecede depresyon (yakın takip gerekir)\n'
                          '0–3 puan: Ciddi durum, acil müdahale gerekir (resüsitasyon gibi)',
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
