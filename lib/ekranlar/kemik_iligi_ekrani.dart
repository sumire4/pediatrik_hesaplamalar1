import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class KemikIligiScreen extends StatefulWidget {
  const KemikIligiScreen({super.key});

  @override
  State<KemikIligiScreen> createState() => _KemikIligiScreenState();
}

class _KemikIligiScreenState extends State<KemikIligiScreen> {
  late Map<String, int> counts;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final loc = AppLocalizations.of(context)!;

    counts = {
      loc.bmNormoblast: 0,
      loc.bmNotrofil: 0,
      loc.bmBand: 0,
      loc.bmMetamiyelosit: 0,
      loc.bmMiyelosit: 0,
      loc.bmPromiyelosit: 0,
      loc.bmBlast: 0,
      loc.bmLenfosit: 0,
      loc.bmMonosit: 0,
      loc.bmPlazmaHucresi: 0,
      loc.bmEozinofil: 0,
      loc.bmBazofil: 0,
      loc.bmDiger: 0,
    };
  }

  final GlobalKey _globalKey = GlobalKey();
  List<String> history = [];
  bool decreaseMode = false;

  void updateCount(String key) {
    setState(() {
      if (decreaseMode) {
        if (counts[key]! > 0) counts[key] = counts[key]! - 1;
      } else {
        counts[key] = counts[key]! + 1;
        history.add(key);
      }
    });
  }

  void deleteLast() {
    if (history.isNotEmpty) {
      String last = history.removeLast();
      setState(() {
        if (counts[last]! > 0) counts[last] = counts[last]! - 1;
      });
    }
  }

  void reset() {
    setState(() {
      for (var key in counts.keys) {
        counts[key] = 0;
      }
      history.clear();
    });
  }

  int get total => counts.values.reduce((a, b) => a + b);

  Map<String, String> getPercentages() {
    if (total == 0) return {for (var k in counts.keys) k: '0%'};
    return {
      for (var k in counts.keys)
        k: '${((counts[k]! / total) * 100).toStringAsFixed(1)}%'
    };
  }

  Future<void> _exportToPDF() async {
    final loc = AppLocalizations.of(context)!;
    final pdfDoc = pw.Document();

    final totalCount = total;
    final percentages = getPercentages();

    final timesNewRoman = await PdfGoogleFonts.newsreaderRegular();

    pdfDoc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  loc.pdfBaslik,
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    font: timesNewRoman,
                  ),
                ),
                pw.SizedBox(height: 12),
                pw.Text(
                  '${loc.hucresayisii} $totalCount',
                  style: pw.TextStyle(fontSize: 16, font: timesNewRoman),
                ),
                pw.SizedBox(height: 16),
                pw.Table.fromTextArray(
                  headers: [loc.hucreTuru, loc.adet, loc.yuzde],
                  headerStyle: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14,
                    font: timesNewRoman,
                    color: PdfColors.black,
                  ),
                  headerDecoration: const pw.BoxDecoration(
                    color: PdfColors.white,
                  ),
                  data: counts.entries.map((entry) {
                    return [
                      entry.key,
                      entry.value.toString(),
                      percentages[entry.key] ?? '0%'
                    ];
                  }).toList(),
                  cellAlignment: pw.Alignment.centerLeft,
                  cellStyle: pw.TextStyle(fontSize: 12, font: timesNewRoman),
                  cellHeight: 25,
                  border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey800),
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdfDoc.save(),
    );
  }




  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final percentages = getPercentages();

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.kemikIligiTitle),
        // AppBar'daki PDF butonunu kaldırıyoruz
        // actions: [],
      ),
      body: Column(
        children: [
          Expanded(
            child: RepaintBoundary(
              key: _globalKey,
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text(loc.azaltmaModu),
                    value: decreaseMode,
                    onChanged: (val) {
                      setState(() => decreaseMode = val);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Text(
                          '${loc.toplama} $total',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: (total == 50 || total == 100) ? FontWeight.bold : FontWeight.normal,
                            color: (total == 50 || total == 100) ? Colors.orange[100] : Colors.black,
                          ),
                        ),

                        const Spacer(),
                        ElevatedButton(
                            onPressed: deleteLast, child: Text(loc.sonSil)),
                        const SizedBox(width: 8),
                        ElevatedButton(
                            onPressed: reset, child: Text(loc.sifirla)),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: GridView.count(
                      padding: const EdgeInsets.all(12),
                      crossAxisCount: 2,
                      childAspectRatio: 3.5,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: counts.keys.map((key) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[100],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          onPressed: () => updateCount(key),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  key,
                                  style: const TextStyle(fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('${counts[key]}'),
                                  Text(
                                    percentages[key]!,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity, // Buton genişliği tüm satır
              child: ElevatedButton.icon(
                icon: const Icon(Icons.picture_as_pdf),
                label: Text(loc.pdfyeCevir),
                onPressed: _exportToPDF,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
