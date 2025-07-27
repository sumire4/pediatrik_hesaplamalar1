import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:install_plugin/install_plugin.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> with TickerProviderStateMixin {
  String currentVersion = '...';
  String latestVersion = '...';
  String? updateUrl;
  String statusMessage = '';
  String releaseNotes = '';
  double progress = 0.0;
  bool isLoading = true;
  bool hasUpdate = false;
  bool isDownloading = false;

  @override
  void initState() {
    super.initState();
    _checkForUpdate();
  }

  List<int> parseVersion(String version) {
    return version.split('.').map((e) => int.tryParse(e) ?? 0).toList();
  }

  bool areVersionsEqual(String v1, String v2) {
    final a = parseVersion(v1);
    final b = parseVersion(v2);

    final maxLen = a.length > b.length ? a.length : b.length;

    for (var i = 0; i < maxLen; i++) {
      final ai = i < a.length ? a[i] : 0;
      final bi = i < b.length ? b[i] : 0;
      if (ai != bi) return false;
    }
    return true;
  }

  Future<void> _checkForUpdate() async {
    final loc = AppLocalizations.of(context)!;
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      currentVersion = packageInfo.version;

      final response = await http.get(
        Uri.parse('https://api.github.com/repos/sumire4/pediatrik_hesaplamalar1/releases/latest'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        latestVersion = (data['tag_name'] as String).replaceFirst(RegExp(r'^v'), '');
        releaseNotes = data['body'] ?? '';
        final apkAsset = (data['assets'] as List).firstWhere(
              (a) => a['name'].toString().endsWith('.apk'),
          orElse: () => null,
        );

        if (apkAsset == null) {
          setState(() {
            statusMessage = loc.updateScreenNoApkFound;
            isLoading = false;
            hasUpdate = false;
          });
          return;
        }

        updateUrl = apkAsset['browser_download_url'];

        print('Current Version: $currentVersion');
        print('Latest Version: $latestVersion');
        print('Has Update: ${currentVersion != latestVersion}');

        if (areVersionsEqual(currentVersion, latestVersion)) {
          setState(() {
            statusMessage = loc.updateScreenUpToDate;
            isLoading = false;
            hasUpdate = false;
          });
        } else {
          setState(() {
            statusMessage = 'Y${loc.updateScreenNewVersionAvailable}$latestVersion';
            isLoading = false;
            hasUpdate = true;
          });
        }
      } else {
        setState(() {
          statusMessage = loc.updateScreenStatusFetchingFailed;
          isLoading = false;
          hasUpdate = false;
        });
      }
    } catch (e) {
      setState(() {
        statusMessage = '${loc.updateScreenStatusErrorOccurred}: $e';
        isLoading = false;
        hasUpdate = false;
      });
    }
  }

  Future<void> _downloadAndInstall() async {
    final loc = AppLocalizations.of(context)!;
    if (updateUrl == null) return;

    setState(() {
      isDownloading = true;
      progress = 0;
      statusMessage = loc.updateScreenDownloading;
    });

    try {
      final tempDir = Directory.systemTemp;
      final apkPath = '${tempDir.path}/update.apk';

      final request = http.Request('GET', Uri.parse(updateUrl!));
      final response = await request.send();

      final contentLength = response.contentLength ?? 0;
      List<int> bytes = [];
      int received = 0;

      response.stream.listen(
            (chunk) {
          bytes.addAll(chunk);
          received += chunk.length;
          setState(() {
            progress = contentLength > 0 ? received / contentLength : 0;
          });
        },
        onDone: () async {
          final file = File(apkPath);
          await file.writeAsBytes(bytes);

          setState(() {
            statusMessage = 'İşleniyor';
          });

          try {
            await InstallPlugin.installApk(apkPath, appId: (await PackageInfo.fromPlatform()).packageName);
          } catch (e) {
            setState(() {
              statusMessage = '${loc.updateScreenInstallError} $e';
              isDownloading = false;
            });
          }
        },
        onError: (e) {
          setState(() {
            statusMessage = '${loc.updateScreenDownloadError} $e';
            isDownloading = false;
          });
        },
        cancelOnError: true,
      );
    } catch (e) {
      setState(() {
        statusMessage = '${loc.updateScreenStatusErrorOccurred} $e';
        isDownloading = false;
      });
    }
  }

  Widget _buildDownloadIconWithProgress(ThemeData theme) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 140,
          height: 140,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 10,
            color: theme.colorScheme.primary,
            backgroundColor: theme.colorScheme.primaryContainer.withOpacity(0.3),
          ),
        ),
        Icon(
          isDownloading ? Icons.download : Icons.download_for_offline,
          size: 72,
          color: isDownloading ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
        ),
        if (isDownloading)
          Positioned(
            bottom: 16,
            child: Text(
              '${(progress * 100).toStringAsFixed(1)}%',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(loc.updateScreenTitle),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: isLoading
            ? Center(
          child: CircularProgressIndicator(
            color: theme.colorScheme.primary,
            strokeWidth: 4,
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildDownloadIconWithProgress(theme),
            const SizedBox(height: 32),

            if (hasUpdate || releaseNotes.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: theme.colorScheme.secondaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: theme.colorScheme.onSecondaryContainer,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              hasUpdate
                                  ? '${loc.updateScreenNewVersionAvailable} $latestVersion'
                                  : loc.updateScreenUpToDate,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onSecondaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (hasUpdate && releaseNotes.isNotEmpty)
                    const SizedBox(height: 16),

                  if (releaseNotes.isNotEmpty)
                    Text(
                      loc.updateScreenReleaseNotesTitle,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),

                  if (releaseNotes.isNotEmpty)
                    const SizedBox(height: 8),

                  if (releaseNotes.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      constraints: const BoxConstraints(
                        maxHeight: 180,
                      ),
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          child: Text(
                            releaseNotes,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),

            const SizedBox(height: 32),

            Text(loc.updateScreenCurrentVersion, style: theme.textTheme.titleMedium),
            Text(
              currentVersion,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const Spacer(),

            if (hasUpdate && !isDownloading)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  label: Text(loc.updateScreenDownloadAndInstall),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onPressed: _downloadAndInstall,
                ),
              ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 24),

            if ((!hasUpdate || isDownloading))
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonal(
                  onPressed: () => Navigator.pop(context),
                  child: Text(loc.updateScreenClose),
                ),
              ),

            if (isDownloading)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: LinearProgressIndicator(
                  value: progress,
                  color: theme.colorScheme.primary,
                  backgroundColor: theme.colorScheme.primaryContainer.withOpacity(0.3),
                  minHeight: 6,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
