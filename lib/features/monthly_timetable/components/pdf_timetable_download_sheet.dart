import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';

import '../../../l10n/app_localizations.dart';
import '../../../networking/mpt_fetch_api.dart';

/// Opens a bottom sheet to download the PDF timetable for the given JAKIM zone code
void openPdfTimetableDownloadSheet(BuildContext context, String jakimZoneCode) {
  showModalBottomSheet(
    context: context,
    builder: (context) =>
        PdfTimetableDownloadSheet(jakimZoneCode: jakimZoneCode),
  );
}

/// The bottom sheet widget to download the PDF timetable
class PdfTimetableDownloadSheet extends StatefulWidget {
  const PdfTimetableDownloadSheet({super.key, required this.jakimZoneCode});

  /// The JAKIM zone code.
  final String jakimZoneCode;

  @override
  State<PdfTimetableDownloadSheet> createState() =>
      _PdfTimetableDownloadSheetState();
}

class _PdfTimetableDownloadSheetState extends State<PdfTimetableDownloadSheet> {
  late Future<File> _downloadTimetableFuture;
  @override
  void initState() {
    super.initState();
    _downloadTimetableFuture =
        MptApiFetch.downloadJadualSolat(widget.jakimZoneCode);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
          future: _downloadTimetableFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.timetableExportSuccess,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Gap(12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          icon: const FaIcon(
                              FontAwesomeIcons.squareArrowUpRight,
                              size: 14),
                          onPressed: () {
                            OpenFile.open(snapshot.data!.path);
                            Navigator.pop(context);
                          },
                          label: Text(AppLocalizations.of(context)!
                              .timetableExportOpen),
                        ),
                        const SizedBox(width: 5),
                        ElevatedButton.icon(
                          icon: const FaIcon(
                            FontAwesomeIcons.share,
                            size: 14,
                          ),
                          onPressed: () {
                            SharePlus.instance.share(
                              ShareParams(
                                files: [
                                  XFile(snapshot.data!.path),
                                ],
                                subject: AppLocalizations.of(context)!
                                    .timetableExportFileShareSubject(
                                        'https://waktusolat.app'),
                              ),
                            );
                          },
                          label: Text(
                            AppLocalizations.of(context)!.genericShare,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(AppLocalizations.of(context)!
                    .timetableExportError(snapshot.error.toString())),
              );
            }
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.timetableExportExporting),
                  const SizedBox(width: 20),
                  SpinKitDualRing(
                    color: Theme.of(context).colorScheme.primary,
                    size: 30,
                    lineWidth: 5,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
