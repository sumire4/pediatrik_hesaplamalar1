import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GunlukKaloriHesaplamaScreen extends StatefulWidget {
  const GunlukKaloriHesaplamaScreen({super.key});

  @override
  State<GunlukKaloriHesaplamaScreen> createState() => _GunlukKaloriHesaplamaScreenState();
}

class _GunlukKaloriHesaplamaScreenState extends State<GunlukKaloriHesaplamaScreen> {
  final _primerController = TextEditingController();
  final _velipController = TextEditingController();
  final _dekstrozController = TextEditingController();
  final _mamaController = TextEditingController();
  final _aminosolController = TextEditingController();
  final _suplementController = TextEditingController();
  final _cuproteinController = TextEditingController();
  final _kiloController = TextEditingController();

  void _hesapla() {
    try {
      double primer = double.tryParse(_primerController.text.replaceAll(',', '.')) ?? 0;
      double velip = double.tryParse(_velipController.text.replaceAll(',', '.')) ?? 0;
      double dekstroz = double.tryParse(_dekstrozController.text.replaceAll(',', '.')) ?? 0;
      double mama = double.tryParse(_mamaController.text.replaceAll(',', '.')) ?? 0;
      double aminosol = double.tryParse(_aminosolController.text.replaceAll(',', '.')) ?? 0;
      double suplement = double.tryParse(_suplementController.text.replaceAll(',', '.')) ?? 0;
      double cuprotein = double.tryParse(_cuproteinController.text.replaceAll(',', '.')) ?? 0;
      double kilo = double.tryParse(_kiloController.text.replaceAll(',', '.')) ?? 0;

      if (kilo <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen geçerli bir kilo girin.')),
        );
        return;
      }

      double toplamKalori = ((primer * 0.4) +
          (velip * 0.9) +
          (dekstroz * 0.4) +
          (mama * 0.7) +
          (aminosol * 0.67) +
          (suplement * 20) +
          (cuprotein * 3.875)) * kilo;

      String sonucText = 'Günlük Kalori İhtiyacı: ${toplamKalori.toStringAsFixed(2)} kcal/gün';

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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hesaplama sırasında bir hata oluştu.')),
      );
    }
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
        title: const Text('Günlük Kalori Hesaplama'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField('Primer', _primerController),
              _buildTextField('Velip', _velipController),
              _buildTextField('Dekstroz', _dekstrozController),
              _buildTextField('Mama', _mamaController),
              _buildTextField('Aminosol', _aminosolController),
              _buildTextField('Suplement', _suplementController),
              _buildTextField('Cuprotein', _cuproteinController),
              _buildTextField('Kilo (kg)', _kiloController),
              const SizedBox(height: 8),
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
