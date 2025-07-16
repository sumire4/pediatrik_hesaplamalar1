import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  void _hesapla() {
    if (_gorusum == null || _refleks == null || _tonus == null || _solunum == null || _nabiz == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm parametreleri seçin.')),
      );
      return;
    }

    int toplam = _gorusum! + _refleks! + _tonus! + _solunum! + _nabiz!;
    int apgarSkoru = toplam - 5;

    final sonucText = 'Apgar Skoru: $apgarSkoru';

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
            ElevatedButton(
              onPressed: _hesapla,
              child: const Text('Hesapla'),
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
