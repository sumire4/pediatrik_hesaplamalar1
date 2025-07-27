import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GlaskowKomaSkalasiScreen extends StatefulWidget {
  const GlaskowKomaSkalasiScreen({super.key});

  @override
  State<GlaskowKomaSkalasiScreen> createState() => _GlaskowKomaSkalasiScreenState();
}

class _GlaskowKomaSkalasiScreenState extends State<GlaskowKomaSkalasiScreen> {
  bool _isChild = false;

  int? _gozYaniti;
  int? _sozluYaniti;
  int? _motorYaniti;

  late Map<String, int> gozYanitlari;
  late Map<String, int> sozluYanitlariYetiskin;
  late Map<String, int> sozluYanitlariCocuk;
  late Map<String, int> motorYanitlari;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final loc = AppLocalizations.of(context)!;

    gozYanitlari = {
      loc.gksEyeSpontan: 4,
      loc.gksEyeSesle: 3,
      loc.gksEyeAgrili: 2,
      loc.gksEyeYok: 1,
    };

    sozluYanitlariYetiskin = {
      loc.gksVerbalYonelimli: 5,
      loc.gksVerbalKonfuze: 4,
      loc.gksVerbalUygunsuzKelimeler: 3,
      loc.gksVerbalAnlasilmazSesler: 2,
      loc.gksVerbalYok: 1,
    };

    sozluYanitlariCocuk = {
      loc.gksVerbalGulumsme: 5,
      loc.gksVerbalAglamaTeselli: 4,
      loc.gksVerbalUygunsuzAglama: 3,
      loc.gksVerbalInleme: 2,
      loc.gksVerbalYok: 1,
    };

    motorYanitlari = {
      loc.gksMotorEmirler: 6,
      loc.gksMotorAgriLokalize: 5,
      loc.gksMotorAgriCekme: 4,
      loc.gksMotorDekortike: 3,
      loc.gksMotorDeserebre: 2,
      loc.gksMotorYok: 1,
    };
  }

  void _hesapla() {
    final loc = AppLocalizations.of(context)!;
    if (_gozYaniti == null || _sozluYaniti == null || _motorYaniti == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.gksMissingFields)),
      );
      return;
    }

    int toplamSkor = _gozYaniti! + _sozluYaniti! + _motorYaniti!;
    String sonuc = '${loc.gksScoreResult} $toplamSkor';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 60),
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
              loc.gksResultTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              sonuc,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(loc.closeButton),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final Map<String, int> sozluMap = _isChild ? sozluYanitlariCocuk : sozluYanitlariYetiskin;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.gksTitle),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            SwitchListTile(
              title: Text(loc.gksIsChildSwitch),
              value: _isChild,
              onChanged: (val) => setState(() => _isChild = val),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: loc.gksEyeResponse,
                border: const OutlineInputBorder(),
              ),
              items: gozYanitlari.entries
                  .map((e) => DropdownMenuItem(value: e.value, child: Text(e.key)))
                  .toList(),
              onChanged: (val) => setState(() => _gozYaniti = val),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: loc.gksVerbalResponse,
                border: const OutlineInputBorder(),
              ),
              items: sozluMap.entries
                  .map((e) => DropdownMenuItem(value: e.value, child: Text(e.key)))
                  .toList(),
              onChanged: (val) => setState(() => _sozluYaniti = val),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: loc.gksMotorResponse,
                border: const OutlineInputBorder(),
              ),
              items: motorYanitlari.entries
                  .map((e) => DropdownMenuItem(value: e.value, child: Text(e.key)))
                  .toList(),
              onChanged: (val) => setState(() => _motorYaniti = val),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: _hesapla,
                  child: Text(loc.gksCalculate),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  tooltip: loc.gksInfoTooltip,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(loc.gksInfoTitle),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(loc.gksInfoEyeTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(loc.gksInfoEye4),
                              Text(loc.gksInfoEye3),
                              Text(loc.gksInfoEye2),
                              Text(loc.gksInfoEye1),
                              const SizedBox(height: 12),

                              Text(loc.gksInfoVerbalTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(loc.gksInfoVerbal5),
                              Text(loc.gksInfoVerbal4),
                              Text(loc.gksInfoVerbal3),
                              Text(loc.gksInfoVerbal2),
                              Text(loc.gksInfoVerbal1),
                              const SizedBox(height: 12),

                              Text(loc.gksInfoMotorTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(loc.gksInfoMotor6),
                              Text(loc.gksInfoMotor5),
                              Text(loc.gksInfoMotor4),
                              Text(loc.gksInfoMotor3),
                              Text(loc.gksInfoMotor2),
                              Text(loc.gksInfoMotor1),
                              const SizedBox(height: 12),

                              Text(loc.gksInfoCalculationTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(loc.gksInfoCalculationDesc),
                              const SizedBox(height: 12),

                              Text(loc.gksInfoScoreInterpretationTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(loc.gksInfoScoreInterpretation13_15),
                              Text(loc.gksInfoScoreInterpretation9_12),
                              Text(loc.gksInfoScoreInterpretation8less),
                            ],
                          ),
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
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
