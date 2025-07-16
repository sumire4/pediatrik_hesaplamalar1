import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class YenidoganMayiHesaplamaScreen extends StatefulWidget {
  const YenidoganMayiHesaplamaScreen({super.key});

  @override
  State<YenidoganMayiHesaplamaScreen> createState() => _YenidoganMayiHesaplamaScreenState();
}

class _YenidoganMayiHesaplamaScreenState extends State<YenidoganMayiHesaplamaScreen> {
  final TextEditingController _kiloController = TextEditingController();
  final TextEditingController _textbox1Controller = TextEditingController();

  void _hesapla() {
    String kiloText = _kiloController.text.replaceAll(',', '.');
    String textbox1Text = _textbox1Controller.text.replaceAll(',', '.');

    double? kilo = double.tryParse(kiloText);
    double? textbox1 = double.tryParse(textbox1Text);

    if (kilo == null || textbox1 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanlara geçerli değerler girin.')),
      );
      return;
    }

    double yuzeyAlani = (kilo * 0.05) + 0.05;
    double gunlukMayi = textbox1 * yuzeyAlani;
    double saatlikMayi = gunlukMayi / 24;

    final sonucText =
        'Yüzey Alanı: ${yuzeyAlani.toStringAsFixed(2)} m²\nGünlük Mayi: ${gunlukMayi.toStringAsFixed(2)} cc/gün\nSaatlik Mayi: ${saatlikMayi.toStringAsFixed(2)} cc/saat';

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

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yenidoğan Mayi İhtiyacı'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField('Kilo (kg)', _kiloController),
              _buildTextField('TextBox1 (çarpan değeri)', _textbox1Controller),
              ElevatedButton(
                onPressed: _hesapla,
                child: const Text('Hesapla'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
