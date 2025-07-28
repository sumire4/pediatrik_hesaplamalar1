import 'package:flutter/material.dart';
import 'package:pediatrik_hesaplamalar/ekranlar/geribildirim_geli%C5%9Fmi%C5%9F.dart';
import 'package:pediatrik_hesaplamalar/ekranlar/update_ekrani.dart';
import 'ekranlar/anyon_gap_hesaplama.dart';
import 'ekranlar/apgar_skoru_hesaplama.dart';
import 'ekranlar/feedback_list_ekrani.dart';
import 'ekranlar/kullanım_ekrani.dart';
import 'ekranlar/duzeltilmis_kalsiyum.dart';
import 'ekranlar/duzeltilmis_qt_hesaplama.dart';
import 'ekranlar/duzeltilmis_sodyum_hesaplama.dart';
import 'ekranlar/glaskow_koma_hesaplama.dart';
import 'ekranlar/kemik_iligi_ekrani.dart';
import 'ekranlar/periferik_yayma_screen.dart';
import 'ekranlar/retikulosit_hesaplama.dart';
import 'ekranlar/vucut_kitle_hesaplama.dart';
import 'ekranlar/vucut_yuzey_sıvı_hesaplama.dart';
import 'ekranlar/yenidogan_yuzeyalanı_mayiihtiyaci.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MedicalCalculationApp());
}

class MedicalCalculationApp extends StatefulWidget {
  const MedicalCalculationApp({super.key});

  @override
  State<MedicalCalculationApp> createState() => _MedicalCalculationAppState();
}

class _MedicalCalculationAppState extends State<MedicalCalculationApp> {
  Locale _locale = const Locale('tr'); // Varsayılan dil Türkçe

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  // Kaydedilmiş dili yükle
  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('selected_language') ?? 'tr';
    setState(() {
      _locale = Locale(savedLanguage);
    });
  }

  // Dil değiştirme fonksiyonu
  Future<void> changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', languageCode);
    setState(() {
      _locale = Locale(languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('tr'),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        // Seçilen dili kullan
        return _locale;
      },
      debugShowCheckedModeBanner: false,
      title: 'Pediatrik Hesaplamalar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: HomeScreen(onLanguageChange: changeLanguage),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final Function(String) onLanguageChange;

  const HomeScreen({super.key, required this.onLanguageChange});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> sikKullanilanlar = [];
  int _titleTapCount = 0;
  DateTime? _lastTapTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() {
        final loc = AppLocalizations.of(context);
        if (loc == null) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              loc.snackbarInfo,
              style: const TextStyle(color: Colors.white),
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.grey,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );
      });
    });

    loadTopUsedCalculations();
  }

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
    final loc = AppLocalizations.of(context)!;

    final allItems = [
      {
        'key': 'AnyonGap',
        'baslik': loc.calculationTitlesAnyonGap,
        'icon': Icons.calculate,
        'widget': const AnyonGapHesaplamaScreen(),
      },
      {
        'key': 'Apgar',
        'baslik': loc.calculationTitlesApgar,
        'icon': Icons.child_care,
        'widget': const ApgarSkoruHesaplamaScreen(),
      },
      {
        'key': 'DuzeltilmisKalsiyum',
        'baslik': loc.calculationTitlesCorrectedCalcium,
        'icon': Icons.bloodtype,
        'widget': const DuzeltilmisKalsiyumHesaplamaScreen(),
      },
      {
        'key': 'DuzeltilmisSodyum',
        'baslik': loc.calculationTitlesCorrectedSodium,
        'icon': Icons.opacity,
        'widget': const DuzeltilmisSodyumHesaplamaScreen(),
      },
      {
        'key': 'DuzeltilmisQT',
        'baslik': loc.calculationTitlesCorrectedQT,
        'icon': Icons.timer,
        'widget': const DuzeltilmisQTHesaplamaScreen(),
      },
      {
        'key': 'DuzeltilmisRetikulosit',
        'baslik': loc.calculationTitlesCorrectedReticulocyte,
        'icon': Icons.healing,
        'widget': const DuzeltilmisRetikulositHesaplamaScreen(),
      },
      {
        'key': 'Glaskow',
        'baslik': loc.calculationTitlesGlasgowComaScale,
        'icon': Icons.visibility,
        'widget': const GlaskowKomaSkalasiScreen(),
      },
      {
        'key': 'BMI',
        'baslik': loc.calculationTitlesBMI,
        'icon': Icons.fitness_center,
        'widget': const BmiHesaplamaScreen(),
      },
      {
        'key': 'VucutYuzeyAlaniVeSivi',
        'baslik': loc.calculationTitlesBodySurfaceAreaAndFluid,
        'icon': Icons.line_weight,
        'widget': const VucutYuzeyAlaniVeSiviScreen(),
      },
      {
        'key': 'YenidoganMayi',
        'baslik': loc.calculationTitlesNewbornBodySurfaceArea,
        'icon': Icons.baby_changing_station,
        'widget': const YenidoganYuzeyAlaniScreen(),
      },
      {
        'key': 'PeriferikYayma',
        'baslik': loc.calculationTitlesPeripheralSmear,
        'icon': Icons.analytics,
        'widget': const PeriferikYaymaScreen(),
      },
      {
        'key': 'KemikIligi',
        'baslik': loc.calculationTitlesBoneMarrowEvaluation,
        'icon': Icons.science,
        'widget': const KemikIligiScreen(),
      },
    ];

    allItems.sort((a, b) {
      final countA = prefs.getInt(a['key'] as String) ?? 0;
      final countB = prefs.getInt(b['key'] as String) ?? 0;
      return countB.compareTo(countA);
    });

    return allItems.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double imageHeight = screenHeight * 0.4;

    final calculationKeys = {
      loc.calculationTitlesAnyonGap: 'AnyonGap',
      loc.calculationTitlesApgar: 'Apgar',
      loc.calculationTitlesCorrectedCalcium: 'DuzeltilmisKalsiyum',
      loc.calculationTitlesCorrectedSodium: 'DuzeltilmisSodyum',
      loc.calculationTitlesCorrectedQT: 'DuzeltilmisQT',
      loc.calculationTitlesCorrectedReticulocyte: 'DuzeltilmisRetikulosit',
      loc.calculationTitlesGlasgowComaScale: 'GlaskowKomaSkalasi',
      loc.calculationTitlesBMI: 'VücutKitleIndeksi',
      loc.calculationTitlesBodySurfaceAreaAndFluid: 'VucutYuzeyAlaniVeSivi',
      loc.calculationTitlesNewbornBodySurfaceArea: 'YenidoganMayi',
      loc.calculationTitlesPeripheralSmear: 'PeriferikYayma',
      loc.calculationTitlesBoneMarrowEvaluation: 'KemikIligi',
    };

    final List<String> calculations = [
      loc.calculationTitlesAnyonGap,
      loc.calculationTitlesApgar,
      loc.calculationTitlesCorrectedCalcium,
      loc.calculationTitlesCorrectedSodium,
      loc.calculationTitlesCorrectedQT,
      loc.calculationTitlesCorrectedReticulocyte,
      loc.calculationTitlesGlasgowComaScale,
      loc.calculationTitlesBMI,
      loc.calculationTitlesBodySurfaceAreaAndFluid,
      loc.calculationTitlesNewbornBodySurfaceArea,
      loc.calculationTitlesPeripheralSmear,
      loc.calculationTitlesBoneMarrowEvaluation,
    ];

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            final now = DateTime.now();
            if (_lastTapTime == null || now.difference(_lastTapTime!) > const Duration(seconds: 2)) {
              _titleTapCount = 1;
            } else {
              _titleTapCount += 1;
            }

            _lastTapTime = now;

            if (_titleTapCount == 5) {
              _titleTapCount = 0;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const KullanimLogEkrani()),
              );
            }
          },
          child: Text(loc.appTitle),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onLongPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FeedbackListEkrani()),
            );
          },
          child: IconButton(
            icon: const Icon(Icons.feedback_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FeedbackEkrani()),
              );
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.system_update),
            tooltip: loc.updateTooltip,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UpdateScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(loc.appTitle),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text(
                            loc.infoDialogContent,
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 16),
                          Text(loc.infoDialogCopyright, style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      // Dil değiştirme butonu
                      TextButton.icon(
                        icon: const Icon(Icons.language),
                        label: Text(
                            Localizations.localeOf(context).languageCode == 'tr'
                                ? 'Switch to English'
                                : 'Türkçeye Geç'
                        ),
                        onPressed: () {
                          final currentLanguage = Localizations.localeOf(context).languageCode;
                          final newLanguage = currentLanguage == 'tr' ? 'en' : 'tr';
                          widget.onLanguageChange(newLanguage);
                          Navigator.of(context).pop(); // Dialog'u kapat
                        },
                      ),
                      TextButton(
                        child: Text(loc.closeButton),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.open_in_new),
                        label: Text(loc.projectPage),
                        onPressed: () async {
                          final Uri url = Uri.parse('https://github.com/sumire4/pediatrik_hesaplamalar1');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(loc.errorGithubOpen)),
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
        itemCount: calculations.length + 1,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    loc.frequentlyUsed,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: sikKullanilanlar.isEmpty
                      ? Center(child: Text(loc.noFrequentlyUsed))
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
                                await loadTopUsedCalculations();
                              },
                              child: SizedBox(
                                height: 120,
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
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  String? key = calculationKeys[calculation];
                  if (key == null) return;

                  await incrementUsage(key);

                  Widget? screen;
                  switch (key) {
                    case 'AnyonGap':
                      screen = const AnyonGapHesaplamaScreen();
                      break;
                    case 'Apgar':
                      screen = const ApgarSkoruHesaplamaScreen();
                      break;
                    case 'DuzeltilmisKalsiyum':
                      screen = const DuzeltilmisKalsiyumHesaplamaScreen();
                      break;
                    case 'DuzeltilmisSodyum':
                      screen = const DuzeltilmisSodyumHesaplamaScreen();
                      break;
                    case 'DuzeltilmisQT':
                      screen = const DuzeltilmisQTHesaplamaScreen();
                      break;
                    case 'DuzeltilmisRetikulosit':
                      screen = const DuzeltilmisRetikulositHesaplamaScreen();
                      break;
                    case 'GlaskowKomaSkalasi':
                      screen = const GlaskowKomaSkalasiScreen();
                      break;
                    case 'VücutKitleIndeksi':
                      screen = const BmiHesaplamaScreen();
                      break;
                    case 'VucutYuzeyAlaniVeSivi':
                      screen = const VucutYuzeyAlaniVeSiviScreen();
                      break;
                    case 'YenidoganMayi':
                      screen = const YenidoganYuzeyAlaniScreen();
                      break;
                    case 'PeriferikYayma':
                      screen = const PeriferikYaymaScreen();
                      break;
                    case 'KemikIligi':
                      screen = const KemikIligiScreen();
                      break;
                    default:
                      return;
                  }

                  if (screen != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => screen!),
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