import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../core/app_strings.dart';
import '../models/app_models.dart';

abstract final class WaterAdvisoryPdfService {
  static Future<Uint8List> build({
    required AppStrings strings,
    required WaterSchedule schedule,
    required List<WaterPost> notices,
    PdfPageFormat pageFormat = PdfPageFormat.a4,
  }) async {
    final document = pw.Document(
      title: 'TubigTugon ${strings.t('waterAdvisory')}',
      author: 'TubigTugon Barangay Water Supply Monitoring System',
      subject: strings.t('waterAdvisory'),
    );
    final blue = PdfColor.fromHex('#1769E0');
    final darkBlue = PdfColor.fromHex('#0E4EA8');
    final darkText = PdfColor.fromHex('#17212B');
    final muted = PdfColor.fromHex('#52606D');
    final border = PdfColor.fromHex('#DDE3EA');
    final lightBlue = PdfColor.fromHex('#EAF3FF');

    document.addPage(
      pw.MultiPage(
        pageFormat: pageFormat,
        margin: const pw.EdgeInsets.all(36),
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            '${context.pageNumber} / ${context.pagesCount}',
            style: pw.TextStyle(fontSize: 9, color: muted),
          ),
        ),
        build: (context) => [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Container(
                width: 34,
                height: 34,
                decoration: pw.BoxDecoration(
                  color: blue,
                  shape: pw.BoxShape.circle,
                ),
                alignment: pw.Alignment.center,
                child: pw.Text(
                  'T',
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(width: 10),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'TubigTugon',
                    style: pw.TextStyle(
                      color: darkBlue,
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    strings.t('community'),
                    style: pw.TextStyle(color: muted, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 24),
          pw.Text(
            strings.t('waterAdvisory'),
            style: pw.TextStyle(
              color: darkText,
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 14),
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(18),
            decoration: pw.BoxDecoration(
              color: lightBlue,
              borderRadius: pw.BorderRadius.circular(10),
              border: pw.Border.all(color: blue, width: .8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  strings.t('todaySchedule'),
                  style: pw.TextStyle(
                    color: darkBlue,
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Text(
                  '${strings.formatTime(schedule.start)} - ${strings.formatTime(schedule.end)}',
                  style: pw.TextStyle(
                    color: darkBlue,
                    fontSize: 26,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 22),
          pw.Text(
            strings.t('publishedNotices'),
            style: pw.TextStyle(
              color: darkText,
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          ...notices.map(
            (notice) => pw.Container(
              width: double.infinity,
              margin: const pw.EdgeInsets.only(bottom: 10),
              padding: const pw.EdgeInsets.all(13),
              decoration: pw.BoxDecoration(
                color: PdfColors.white,
                borderRadius: pw.BorderRadius.circular(8),
                border: pw.Border.all(color: border),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    strings.waterStatus(notice.status),
                    style: pw.TextStyle(
                      color: _statusColor(notice.status),
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    strings.valueOrKey(notice.message),
                    style: pw.TextStyle(
                      color: darkText,
                      fontSize: 12,
                      lineSpacing: 3,
                    ),
                  ),
                  if (notice.returnTime != null) ...[
                    pw.SizedBox(height: 5),
                    pw.Text(
                      '${strings.t('expectedReturn')}: '
                      '${strings.formatTime(notice.returnTime!)}',
                      style: pw.TextStyle(
                        color: darkText,
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                  pw.SizedBox(height: 5),
                  pw.Text(
                    strings.formatDateTime(notice.createdAt),
                    style: pw.TextStyle(color: muted, fontSize: 9),
                  ),
                ],
              ),
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Divider(color: border),
          pw.SizedBox(height: 6),
          pw.Text(
            '${strings.t('generatedOn')}: ${strings.formatDateTime(DateTime.now())}',
            style: pw.TextStyle(color: muted, fontSize: 9),
          ),
        ],
      ),
    );

    return document.save();
  }

  static PdfColor _statusColor(WaterStatus status) {
    return PdfColor.fromHex(switch (status) {
      WaterStatus.normal => '#237A45',
      WaterStatus.interrupted => '#B45309',
      WaterStatus.pumpProblem => '#B42318',
      WaterStatus.restored => '#1769E0',
    });
  }
}
