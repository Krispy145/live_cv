import "dart:typed_data";

import "package:cv_app/data/models/header_model.dart";
import "package:cv_app/data/models/skill_model.dart";
import "package:cv_app/data/models/timeline_model.dart";
import "package:cv_app/data/models/user_details_model.dart";
import "package:flutter/material.dart" show Color;
import "package:pdf/pdf.dart";
import "package:pdf/widgets.dart" as pw;
import "package:theme/data/models/colors/color_model.dart";

/// Builds a paginated two-column PDF resume from [HeaderModel].
class PdfResumeService {
  static const _sidebarRatio = 0.25;
  static const _columnGutter = 24.0;
  static const _pageInset = 28.0;

  /// Generates resume bytes.
  static Future<Uint8List> generateResume(
    HeaderModel header, {
    ColorModel? colorModel,
    Uint8List? imageBytes,
  }) async {
    final document = pw.Document();
    final primary = _pdfColor(colorModel?.primary) ?? const PdfColor.fromInt(0xFF003898);
    final onPrimary = _pdfColor(colorModel?.onPrimary) ?? PdfColors.white;
    final details = header.userDetails;

    pw.ImageProvider? avatar;
    if (imageBytes != null) {
      avatar = pw.MemoryImage(imageBytes);
    }

    final sidebarWidth = PdfPageFormat.a4.width * _sidebarRatio;

    document.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.fromLTRB(sidebarWidth + _columnGutter, _pageInset, _columnGutter, _pageInset),
          buildBackground: (context) {
            return pw.FullPage(
              ignoreMargins: true,
              child: pw.Row(
                children: [
                  pw.Container(
                    width: sidebarWidth,
                    color: primary,
                    padding: const pw.EdgeInsets.fromLTRB(16, _pageInset, 18, 24),
                    child: _sidebar(
                      header: header,
                      details: details,
                      avatar: avatar,
                      onPrimary: onPrimary,
                    ),
                  ),
                  pw.Expanded(child: pw.Container(color: PdfColors.white)),
                ],
              ),
            );
          },
        ),
        header: (context) {
          if (context.pageNumber == 1) {
            return pw.SizedBox();
          }
          return pw.SizedBox(height: 36);
        },
        build: (context) => _mainWidgets(details: details, accent: primary),
      ),
    );

    return document.save();
  }

  static pw.Widget _sidebar({
    required HeaderModel header,
    required UserDetailsModel details,
    required pw.ImageProvider? avatar,
    required PdfColor onPrimary,
  }) {
    final muted = PdfColor(onPrimary.red, onPrimary.green, onPrimary.blue, 0.78);
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (avatar != null) ...[
          pw.Center(
            child: pw.ClipOval(
              child: pw.Image(avatar, width: 72, height: 72, fit: pw.BoxFit.cover),
            ),
          ),
          pw.SizedBox(height: 16),
        ],
        pw.Text(
          _pdfSafe(details.firstName.toUpperCase()),
          style: pw.TextStyle(
            fontSize: 13,
            fontWeight: pw.FontWeight.bold,
            color: onPrimary,
            letterSpacing: 0.6,
          ),
        ),
        pw.Text(
          _pdfSafe(details.lastName.toUpperCase()),
          style: pw.TextStyle(
            fontSize: 13,
            fontWeight: pw.FontWeight.bold,
            color: onPrimary,
            letterSpacing: 0.6,
          ),
        ),
        if (header.subtitle != null) ...[
          pw.SizedBox(height: 6),
          pw.Text(
            _pdfSafe(header.subtitle!),
            style: pw.TextStyle(fontSize: 8, color: muted, lineSpacing: 2),
          ),
        ],
        _sidebarHeading("Contact", onPrimary),
        if (details.email != null) _sidebarLine(details.email!, onPrimary),
        if (details.phone != null) _sidebarLine(details.phone!, onPrimary),
        if (details.location != null)
          _sidebarLine(
            details.location.toString().replaceAll("\n", ", "),
            onPrimary,
          ),
        if (details.githubUrl != null)
          _sidebarHyperlink(label: "GitHub", url: details.githubUrl!, color: onPrimary),
        if (details.linkedinUrl != null)
          _sidebarHyperlink(label: "LinkedIn", url: details.linkedinUrl!, color: onPrimary),
        if (header.skillsPairs.isNotEmpty) ...[
          _sidebarHeading("Skills", onPrimary),
          ...header.skillsPairs.map(
            (pair) => _skillGroup(pair.first, pair.second, onPrimary, muted),
          ),
        ],
        _sidebarHeading("References", onPrimary),
        pw.Text(
          "Available upon request",
          style: pw.TextStyle(fontSize: 8, color: muted, lineSpacing: 1.5),
        ),
      ],
    );
  }

  static List<pw.Widget> _mainWidgets({
    required UserDetailsModel details,
    required PdfColor accent,
  }) {
    return [
      if (details.summary != null) ...[
        _mainHeading("Profile", accent),
        pw.Text(
          _pdfSafe(details.summary!),
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey800, lineSpacing: 2),
        ),
        pw.SizedBox(height: 14),
      ],
      _mainHeading("Experience", accent),
      ...details.experience.map(_experienceBlock),
      pw.SizedBox(height: 10),
      _mainHeading("Education", accent),
      ...details.education.map(_educationBlock),
    ];
  }

  static pw.Widget _skillGroup(
    String category,
    List<SkillModel> skills,
    PdfColor onPrimary,
    PdfColor muted,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 7),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            _pdfSafe(category),
            style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: onPrimary),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            _pdfSafe(skills.map((skill) => skill.name).join(", ")),
            style: pw.TextStyle(fontSize: 7.5, color: muted, lineSpacing: 1.6),
          ),
        ],
      ),
    );
  }

  static pw.Widget _experienceBlock(TimelineModel item) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Text(
                  _pdfSafe(item.resumeHeading),
                  style: pw.TextStyle(fontSize: 10.5, fontWeight: pw.FontWeight.bold, color: PdfColors.grey900),
                ),
              ),
              pw.Text(
                _pdfSafe(item.dateRange),
                style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
              ),
            ],
          ),
          if (item.location != null)
            pw.Text(
              _pdfSafe(item.location!),
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
            ),
          if (item.description != null) ...[
            pw.SizedBox(height: 2),
            pw.Text(
              _pdfSafe(item.description!),
              style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey800, lineSpacing: 1.6),
            ),
          ],
          ...item.highlights.map(
            (highlight) => pw.Bullet(
              text: _pdfSafe(highlight),
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey800),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _educationBlock(TimelineModel item) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 7),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            _pdfSafe(item.title),
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.grey900),
          ),
          pw.Text(
            _pdfSafe("${item.organization}  ·  ${item.dateRange}"),
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
          ),
          if (item.description != null)
            pw.Text(
              _pdfSafe(item.description!),
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey800, lineSpacing: 1.5),
            ),
        ],
      ),
    );
  }

  static pw.Widget _sidebarHeading(String title, PdfColor color) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 14, bottom: 6),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title.toUpperCase(),
            style: pw.TextStyle(
              fontSize: 8.5,
              fontWeight: pw.FontWeight.bold,
              color: color,
              letterSpacing: 1.1,
            ),
          ),
          pw.SizedBox(height: 3),
          pw.Container(width: 24, height: 1, color: color),
        ],
      ),
    );
  }

  static pw.Widget _sidebarLine(String value, PdfColor color) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Text(
        _pdfSafe(value),
        style: pw.TextStyle(fontSize: 7.5, color: color, lineSpacing: 1.4),
      ),
    );
  }

  static pw.Widget _mainHeading(String title, PdfColor color) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title.toUpperCase(),
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
              color: color,
              letterSpacing: 1.1,
            ),
          ),
          pw.SizedBox(height: 3),
          pw.Container(width: 36, height: 1.5, color: color),
        ],
      ),
    );
  }

  static pw.Widget _sidebarHyperlink({
    required String label,
    required String url,
    required PdfColor color,
  }) {
    return pw.UrlLink(
      destination: _absoluteUrl(url),
      child: pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 6),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 7.5,
                fontWeight: pw.FontWeight.bold,
                color: color,
                decoration: pw.TextDecoration.underline,
              ),
            ),
            pw.Text(
              _pdfSafe(_hostPath(url)),
              style: pw.TextStyle(
                fontSize: 7,
                color: color,
                decoration: pw.TextDecoration.underline,
                lineSpacing: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _absoluteUrl(String url) {
    final trimmed = url.trim();
    if (trimmed.startsWith("http://") || trimmed.startsWith("https://")) {
      return trimmed;
    }
    return "https://$trimmed";
  }

  static String _hostPath(String url) {
    return url.replaceFirst(RegExp(r"^https?://(www\.)?"), "");
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
