import 'package:flutter/material.dart';
import 'ekranlar/adrenalin_dozu_hesaplama.dart';
import 'ekranlar/anyon_gap_hesaplama.dart';
import 'ekranlar/apgar_skoru_hesaplama.dart';
import 'ekranlar/duzeltilmis_kalsiyum.dart';
import 'ekranlar/duzeltilmis_qt_hesaplama.dart';
import 'ekranlar/duzeltilmis_sodyum_hesaplama.dart';
import 'ekranlar/gfr_hesaplama.dart';
import 'ekranlar/glaskow_koma_hesaplama.dart';
import 'ekranlar/gunluk_kalori.dart';
import 'ekranlar/jreatin_atilimi_hesaplama.dart';
import 'ekranlar/retikulosit_hesaplama.dart';
import 'ekranlar/sodyum_fraksiyonel_atılım.dart';
import 'ekranlar/tibuler_fosfor_reabsorbisyonu.dart';
import 'ekranlar/vucut_kitle_hesaplama.dart';
import 'ekranlar/vucut_yuzey_sıvı_hesaplama.dart';
import 'ekranlar/yasa_gore_endotrakeal.dart';
import 'ekranlar/yenidogan_yuzeyalanı_mayiihtiyaci.dart';

void main() {
  runApp(const MedicalCalculationApp());
}

class MedicalCalculationApp extends StatelessWidget {
  const MedicalCalculationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pediatrik Hesaplamalar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<String> calculations = const [
    'Adrenalin Dozu Hesaplama',
    'Anyon Gap Hesaplama',
    'Apgar Skoru Hesaplama',
    'Düzeltilmiş Kalsiyum',
    'Düzeltilmiş Sodyum Hesaplama',
    'Düzeltilmiş QT Hesaplama',
    'Düzeltilmiş Retikülosit Hesaplama',
    'Yaşa Göre Endotrakeal Tüp Hesaplama',
    'Sodyum Fraksiyonel Atılım Hesaplama',
    'GFR Hesaplama (Kreatinin Klerensi)',
    'Glaskow Koma Skalası Hesaplama',
    'Kreatinin Atılımı ve Sıvı Dengesi Hesaplama',
    'Tübüler Fosfor Reabsorbsiyonu',
    'Vücut Kitle İndeksi (BMI) Hesaplama',
    'Vücut Yüzey Alanı ve Sıvı Miktarı Hesaplama',
    'Günlük Kalori Hesaplama',
    'Yenidoğan Yüzey Alanı ve Mayi İhtiyacı'
  ];

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double imageHeight = screenHeight * 0.4; // Resim yüksekliği, ekranın %40'ı

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pediatrik Hesaplamalar'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: calculations.length + 1, // +1 resim için
        itemBuilder: (context, index) {
          if (index == 0) {
            // En üstte resim
            return SizedBox(
              height: imageHeight,
              width: double.infinity,
              child: Image.asset(
                'assets/images/ust_resim.png', // Buraya resim yolunu koy
                fit: BoxFit.cover,
              ),
            );
          }

          final calculation = calculations[index - 1];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 1,
              child: ListTile(
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(
                  calculation,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: CircleAvatar(
                  backgroundColor: Colors.teal[100],
                  radius: 16,
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  // Burada eski if'ler yerine switch-case ya da başka yapı da olabilir
                  if (calculation == 'Adrenalin Dozu Hesaplama') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdrenalinHesaplamaScreen(),
                      ),
                    );
                  } else if (calculation == 'Anyon Gap Hesaplama') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AnyonGapHesaplamaScreen(),
                      ),
                    );
                  } else if (calculation == 'Apgar Skoru Hesaplama') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ApgarSkoruHesaplamaScreen(),
                      ),
                    );
                  } else if (calculation == 'Düzeltilmiş Kalsiyum') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const DuzeltilmisKalsiyumHesaplamaScreen(),
                      ),
                    );
                  } else if (calculation == 'Düzeltilmiş Sodyum Hesaplama') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const DuzeltilmisSodyumHesaplamaScreen(),
                      ),
                    );
                  } else if (calculation == 'Düzeltilmiş QT Hesaplama') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const DuzeltilmisQTHesaplamaScreen(),
                      ),
                    );
                  } else if (calculation == 'Düzeltilmiş Retikülosit Hesaplama') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const DuzeltilmisRetikulositHesaplamaScreen(),
                      ),
                    );
                  } else if (calculation == 'Yaşa Göre Endotrakeal Tüp Hesaplama') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EndotrakealTupHesaplamaScreen(),
                      ),
                    );
                  } else if (calculation == 'Sodyum Fraksiyonel Atılım Hesaplama') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const SodyumFraksiyonelAtilimScreen(),
                      ),
                    );
                  } else if (calculation == 'GFR Hesaplama (Kreatinin Klerensi)') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GfrHesaplamaScreen(),
                      ),
                    );
                  } else if (calculation == 'Glaskow Koma Skalası Hesaplama') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GlaskowKomaSkalasiScreen(),
                      ),
                    );
                  } else if (calculation == 'Kreatinin Atılımı ve Sıvı Dengesi Hesaplama') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KreatininSiviDengesiScreen(),
                      ),
                    );
                  } else if (calculation == 'Tübüler Fosfor Reabsorbsiyonu') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const TubulerFosforReabsorbsiyonuScreen(),
                      ),
                    );
                  } else if (calculation == 'Vücut Kitle İndeksi (BMI) Hesaplama') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BmiHesaplamaScreen(),
                      ),
                    );
                  } else if (calculation == 'Vücut Yüzey Alanı ve Sıvı Miktarı Hesaplama') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VucutYuzeyAlaniVeSiviScreen(),
                      ),
                    );
                  } else if (calculation == 'Günlük Kalori Hesaplama') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GunlukKaloriHesaplamaScreen(),
                      ),
                    );
                  } else if (calculation == 'Yenidoğan Yüzey Alanı ve Mayi İhtiyacı') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const YenidoganMayiHesaplamaScreen(),
                      ),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
