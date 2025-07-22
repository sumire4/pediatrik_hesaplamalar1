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
import 'ekranlar/kemik_iligi_ekrani.dart';
import 'ekranlar/periferik_yayma_screen.dart';
import 'ekranlar/retikulosit_hesaplama.dart';
import 'ekranlar/sodyum_fraksiyonel_atılım.dart';
import 'ekranlar/tibuler_fosfor_reabsorbisyonu.dart';
import 'ekranlar/vucut_kitle_hesaplama.dart';
import 'ekranlar/vucut_yuzey_sıvı_hesaplama.dart';
import 'ekranlar/yasa_gore_endotrakeal.dart';
import 'ekranlar/yenidogan_yuzeyalanı_mayiihtiyaci.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';



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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> sikKullanilanlar = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bu uygulama sadece sağlık profesyonelleri için geliştirilmiştir. Hesaplamalar bilgilendirme amaçlıdır ve klinik kararlarda tek başına kullanılmamalıdır.',
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.grey,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(16),
        ),
      );
    });
    loadTopUsedCalculations();
  }
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
    'Yenidoğan Yüzey Alanı ve Mayi İhtiyacı',
    'Periferik Yayma Değerlendirme',
    'Kemik İliği Değerlendirme'
  ];

  Future<void> incrementUsage(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt(key) ?? 0;
    await prefs.setInt(key, count + 1);
  }

  Future<void> loadTopUsedCalculations() async {
    final topUsed = await getTopUsedCalculations();
    setState(() {
      sikKullanilanlar = topUsed;
    });
  }



  Future<List<Map<String, dynamic>>> getTopUsedCalculations() async {
    final prefs = await SharedPreferences.getInstance();

    final allItems = [
      {
        'key': 'AdrenalinDozu',
        'baslik': 'Adrenalin Dozu Hesaplama',
        'icon': Icons.medical_services,
        'widget': const AdrenalinHesaplamaScreen(),
      },
      {
        'key': 'AnyonGap',
        'baslik': 'Anyon Gap Hesaplama',
        'icon': Icons.calculate,
        'widget': const AnyonGapHesaplamaScreen(),
      },
      {
        'key': 'Apgar',
        'baslik': 'Apgar Skoru Hesaplama',
        'icon': Icons.child_care,
        'widget': const ApgarSkoruHesaplamaScreen(),
      },
      {
        'key': 'DuzeltilmisKalsiyum',
        'baslik': 'Düzeltilmiş Kalsiyum',
        'icon': Icons.bloodtype,
        'widget': const DuzeltilmisKalsiyumHesaplamaScreen(),
      },
      {
        'key': 'DuzeltilmisSodyum',
        'baslik': 'Düzeltilmiş Sodyum Hesaplama',
        'icon': Icons.opacity,
        'widget': const DuzeltilmisSodyumHesaplamaScreen(),
      },
      {
        'key': 'DuzeltilmisQT',
        'baslik': 'Düzeltilmiş QT Hesaplama',
        'icon': Icons.timer,
        'widget': const DuzeltilmisQTHesaplamaScreen(),
      },
      {
        'key': 'DuzeltilmisRetikulosit',
        'baslik': 'Düzeltilmiş Retikülosit Hesaplama',
        'icon': Icons.healing,
        'widget': const DuzeltilmisRetikulositHesaplamaScreen(),
      },
      {
        'key': 'EndotrakealTup',
        'baslik': 'Yaşa Göre Endotrakeal Tüp Hesaplama',
        'icon': Icons.airline_seat_recline_extra,
        'widget': const EndotrakealTupHesaplamaScreen(),
      },
      {
        'key': 'SodyumFraksiyonelAtilim',
        'baslik': 'Sodyum Fraksiyonel Atılım Hesaplama',
        'icon': Icons.bubble_chart,
        'widget': const SodyumFraksiyonelAtilimScreen(),
      },
      {
        'key': 'GFR',
        'baslik': 'GFR Hesaplama (Kreatinin Klerensi)',
        'icon': Icons.water_damage,
        'widget': const GfrHesaplamaScreen(),
      },
      {
        'key': 'Glaskow',
        'baslik': 'Glaskow Koma Skalası Hesaplama',
        'icon': Icons.visibility,
        'widget': const GlaskowKomaSkalasiScreen(),
      },
      {
        'key': 'KreatininSiviDengesi',
        'baslik': 'Kreatinin Atılımı ve Sıvı Dengesi Hesaplama',
        'icon': Icons.local_drink,
        'widget': const KreatininSiviDengesiScreen(),
      },
      {
        'key': 'TubulerFosforReabsorbsiyonu',
        'baslik': 'Tübüler Fosfor Reabsorbsiyonu',
        'icon': Icons.biotech,
        'widget': const TubulerFosforReabsorbsiyonuScreen(),
      },
      {
        'key': 'BMI',
        'baslik': 'Vücut Kitle İndeksi (BMI) Hesaplama',
        'icon': Icons.fitness_center,
        'widget': const BmiHesaplamaScreen(),
      },
      {
        'key': 'VucutYuzeyAlaniVeSivi',
        'baslik': 'Vücut Yüzey Alanı ve Sıvı Miktarı Hesaplama',
        'icon': Icons.line_weight,
        'widget': const VucutYuzeyAlaniVeSiviScreen(),
      },
      {
        'key': 'GunlukKalori',
        'baslik': 'Günlük Kalori Hesaplama',
        'icon': Icons.restaurant,
        'widget': const GunlukKaloriHesaplamaScreen(),
      },
      {
        'key': 'YenidoganMayi',
        'baslik': 'Yenidoğan Yüzey Alanı ve Mayi İhtiyacı',
        'icon': Icons.baby_changing_station,
        'widget': const YenidoganMayiHesaplamaScreen(),
      },
      {
        'key': 'PeriferikYayma',
        'baslik': 'Periferik Yayma Değerlendirme',
        'icon': Icons.analytics,
        'widget': const PeriferikYaymaScreen(),
      },
      {
        'key': 'KemikIligi',
        'baslik': 'Kemik İliği Değerlendirme',
        'icon': Icons.science,
        'widget': const KemikIligiScreen(),
      },
    ];


    // Sayılara göre büyükten küçüğe sırala
    allItems.sort((a, b) {
      final countA = prefs.getInt(a['key'] as String) ?? 0;
      final countB = prefs.getInt(b['key'] as String) ?? 0;
      return countB.compareTo(countA);
    });

    // En çok kullanılan ilk 3 öğeyi döndür
    return allItems.take(3).toList();
  }


  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double imageHeight = screenHeight * 0.4; // Resim yüksekliği, ekranın %40'ı

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pediatrik Hesaplamalar'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Pediatrik Hesaplamalar'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: const <Widget>[
                          Text(
                            'Bu uygulama, pediatri alanında çalışan sağlık profesyonelleri için hazırlanmıştır. '
                                'Yalnızca bilgi verme amacı taşır ve klinik karar verme sürecinde tek başına kullanılmamalıdır.',
                            textAlign: TextAlign.justify,
                          ),
                          SizedBox(height: 16),
                          Text('© 2025 Tüm Hakları Saklıdır.', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('KAPAT'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('Proje Sayfası'),
                        onPressed: () async {
                          final Uri url = Uri.parse('https://github.com/sumire4/pediatrik_hesaplamalar1');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('GitHub sayfası açılamadı')),
                            );
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },

          ),
        ],
      ),

      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: calculations.length + 1, // +1 resim için
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: imageHeight,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/ust_resim.png',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Sık Kullanılanlar',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: sikKullanilanlar.isEmpty
                      ? const Center(child: Text('Henüz sık kullanılan yok'))
                      : Row(
                    children: sikKullanilanlar.map((item) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: const BorderSide(color: Colors.teal),
                            ),
                            elevation: 2,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () async {
                                final topUsed = await getTopUsedCalculations();
                                final selected = topUsed.firstWhere((element) => element['baslik'] == item['baslik']);

                                await incrementUsage(selected['key']);
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => selected['widget']),
                                );
                                await loadTopUsedCalculations(); // Sık kullanılanlar güncellensin
                              },
                              child: SizedBox(
                                height: 120, // Sabit yükseklik (kendine göre ayarlayabilirsin)
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(item['icon'], size: 28, color: Colors.teal),
                                      const SizedBox(height: 6),
                                      Text(
                                        item['baslik'],
                                        textAlign: TextAlign.center,
                                        maxLines: 2,             // Maksimum 2 satır
                                        overflow: TextOverflow.ellipsis, // Taşan kısmı ... yap
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                ),
                const SizedBox(height: 16),
              ],
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
                onTap: () async {
                  // Burada eski if'ler yerine switch-case ya da başka yapı da olabilir
                  if (calculation == 'Adrenalin Dozu Hesaplama') {
                    await incrementUsage('AdrenalinDozu');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdrenalinHesaplamaScreen(),
                      ),
                    );
                  } else if (calculation == 'Anyon Gap Hesaplama') {
                    await incrementUsage('AnyonGap');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AnyonGapHesaplamaScreen(),
                      ),
                    );
                  } else if (calculation == 'Apgar Skoru Hesaplama') {
                    await incrementUsage('Apgar');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ApgarSkoruHesaplamaScreen(),
                      ),
                    );
                  } else if (calculation == 'Düzeltilmiş Kalsiyum') {
                    await incrementUsage('DuzeltilmisKalsiyum');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const DuzeltilmisKalsiyumHesaplamaScreen(),
                      ),
                    );
                  } else if (calculation == 'Düzeltilmiş Sodyum Hesaplama') {
                    await incrementUsage('DuzeltilmisSodyum');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const DuzeltilmisSodyumHesaplamaScreen(),
                      ),
                    );
                  } else if (calculation == 'Düzeltilmiş QT Hesaplama') {
                    await incrementUsage('DuzeltilmisQT');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const DuzeltilmisQTHesaplamaScreen(),
                      ),
                    );
                  } else if (calculation == 'Düzeltilmiş Retikülosit Hesaplama') {
                    await incrementUsage('DuzeltilmisRetikulosit');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const DuzeltilmisRetikulositHesaplamaScreen(),
                      ),
                    );
                  } else if (calculation == 'Yaşa Göre Endotrakeal Tüp Hesaplama') {
                    await incrementUsage('EndotrakealTup');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EndotrakealTupHesaplamaScreen(),
                      ),
                    );
                  } else if (calculation == 'Sodyum Fraksiyonel Atılım Hesaplama') {
                    await incrementUsage('SodyumFraksiyonelAtilim');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const SodyumFraksiyonelAtilimScreen(),
                      ),
                    );
                  } else if (calculation == 'GFR Hesaplama (Kreatinin Klerensi)') {
                    await incrementUsage('GFR');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GfrHesaplamaScreen(),
                      ),
                    );
                  } else if (calculation == 'Glaskow Koma Skalası Hesaplama') {
                    await incrementUsage('GlaskowKomaSkalasi');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GlaskowKomaSkalasiScreen(),
                      ),
                    );
                  } else if (calculation == 'Kreatinin Atılımı ve Sıvı Dengesi Hesaplama') {
                    await incrementUsage('KreatininSiviDengesi');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KreatininSiviDengesiScreen(),
                      ),
                    );
                  } else if (calculation == 'Tübüler Fosfor Reabsorbsiyonu') {
                    await incrementUsage('TubulerFosforReabsorbsiyonu');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const TubulerFosforReabsorbsiyonuScreen(),
                      ),
                    );
                  } else if (calculation == 'Vücut Kitle İndeksi (BMI) Hesaplama') {
                    await incrementUsage('VücutKitleIndeksi');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BmiHesaplamaScreen(),
                      ),
                    );
                  } else if (calculation == 'Vücut Yüzey Alanı ve Sıvı Miktarı Hesaplama') {
                    await incrementUsage('VucutYuzeyAlaniVeSivi');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VucutYuzeyAlaniVeSiviScreen(),
                      ),
                    );
                  } else if (calculation == 'Günlük Kalori Hesaplama') {
                    await incrementUsage('GunlukKalori');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GunlukKaloriHesaplamaScreen(),
                      ),
                    );
                  } else if (calculation == 'Yenidoğan Yüzey Alanı ve Mayi İhtiyacı') {
                    await incrementUsage('YenidoganMayi');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const YenidoganMayiHesaplamaScreen(),
                      ),
                    );
                  }
                  else if(calculation == 'Periferik Yayma Değerlendirme')
                    {
                      await incrementUsage('PeriferikYayma');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PeriferikYaymaScreen(),
                        ),
                      );
                    }
                  else if(calculation == 'Kemik İliği Değerlendirme')
                    {
                      await incrementUsage('KemikIligi');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const KemikIligiScreen(),
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