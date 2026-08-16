import "dart:typed_data";

import "package:cv_app/data/models/header_model.dart";
import "package:flutter/material.dart" show Color;
import "package:pdf/pdf.dart";
import "package:pdf/widgets.dart" as pw;
import "package:theme/data/models/colors/color_model.dart";

/// Builds a downloadable PDF resume from [HeaderModel].
class PdfResumeService {
  /// Generates resume bytes.
  static Future<Uint8List> generateResume(
    HeaderModel header, {
    ColorModel? colorModel,
    Uint8List? imageBytes,
  }) async {
    final document = pw.Document();
    final primary = _pdfColor(colorModel?.primary) ?? PdfColors.blueGrey800;
    final details = header.userDetails;

    pw.ImageProvider? avatar;
    if (imageBytes != null) {
      avatar = pw.MemoryImage(imageBytes);
    }

    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (context) => [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (avatar != null) ...[
                pw.ClipOval(
                  child: pw.Image(avatar, width: 72, height: 72, fit: pw.BoxFit.cover),
                ),
                pw.SizedBox(width: 16),
              ],
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(_pdfSafe(header.title), style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: primary)),
                    if (header.subtitle != null)
                      pw.Text(_pdfSafe(header.subtitle!), style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
                    pw.SizedBox(height: 8),
                    pw.Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      children: [
                        if (details.email != null) pw.Text(_pdfSafe(details.email!), style: const pw.TextStyle(fontSize: 10)),
                        if (details.phone != null) pw.Text(_pdfSafe(details.phone!), style: const pw.TextStyle(fontSize: 10)),
                        if (details.location != null)
                          pw.Text(
                            _pdfSafe(details.location.toString().replaceAll("\n", ", ")),
                            style: const pw.TextStyle(fontSize: 10),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (details.summary != null) ...[
            pw.SizedBox(height: 16),
            _sectionTitle("Profile", primary),
            pw.Text(_pdfSafe(details.summary!), style: const pw.TextStyle(fontSize: 11, lineSpacing: 2)),
          ],
          pw.SizedBox(height: 16),
          _sectionTitle("Experience", primary),
          ...details.experience.map((item) => _timelineBlock(item.title, item.organization, item.dateRange, item.highlights)),
          pw.SizedBox(height: 16),
          _sectionTitle("Education", primary),
          ...details.education.map((item) => _timelineBlock(item.title, item.organization, item.dateRange, item.highlights)),
          if (header.skills.isNotEmpty) ...[
            pw.SizedBox(height: 16),
            _sectionTitle("Skills", primary),
            pw.Wrap(
              spacing: 6,
              runSpacing: 6,
              children: header.skills
                  .map(
                    (skill) => pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: primary),
                        borderRadius: pw.BorderRadius.circular(8),
                      ),
                      child: pw.Text(_pdfSafe(skill.name), style: pw.TextStyle(fontSize: 9, color: primary)),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );

    return document.save();
  }

  static pw.Widget _sectionTitle(String title, PdfColor color) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Text(title, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: color)),
    );
  }

  static pw.Widget _timelineBlock(String title, String organization, String dates, List<String> highlights) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(_pdfSafe(title), style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.Text(_pdfSafe("$organization  ·  $dates"), style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
          ...highlights.map(
            (highlight) => pw.Bullet(text: _pdfSafe(highlight), style: const pw.TextStyle(fontSize: 10)),
          ),
        ],
      ),
    );
  }

  /// Helvetica cannot draw Unicode punctuation used in the CV copy.
  static String _pdfSafe(String value) {
    return value
        .replaceAll("\u2014", "-")
        .replaceAll("\u2013", "-")
        .replaceAll("\u2011", "-")
        .replaceAll("\u2212", "-")
        .replaceAll("\u00B7", "-")
        .replaceAll("\u2022", "-")
        .replaceAll("\u2018", "'")
        .replaceAll("\u2019", "'")
        .replaceAll("\u201C", '"')
        .replaceAll("\u201D", '"');
  }

  static PdfColor? _pdfColor(Color? color) {
    if (color == null) {
      return null;
    }
    return PdfColor(color.r, color.g, color.b, color.a);
  }
}
