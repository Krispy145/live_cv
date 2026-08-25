import "package:cv_app/data/models/header_model.dart";
import "package:cv_app/data/models/timeline_model.dart";
import "package:cv_app/data/models/user_details_model.dart";
import "package:cv_app/services/pdf_resume_service.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  test("resume headings include the employer", () {
    const item = TimelineModel(
      id: "poly",
      title: "Software Developer",
      organization: "Polymorph Systems",
    );
    expect(item.resumeHeading, "Software Developer - Polymorph Systems");
  });

  test("PDF attaches GitHub and LinkedIn URLs to the contact labels", () async {
    final bytes = await PdfResumeService.generateResume(HeaderModel.personal);
    final raw = String.fromCharCodes(bytes);

    expect(raw, contains("/URI(https://github.com/Krispy145)"));
    expect(raw, contains("/URI(https://www.linkedin.com/in/david-kisbey-green-24123a126)"));
  });

  test("education continues onto a second page instead of being clipped", () async {
    final education = List<TimelineModel>.generate(
      18,
      (index) => TimelineModel(
        id: "edu-$index",
        title: "Qualification $index",
        organization: "Institution $index",
        description: "Full education description for qualification $index that must remain visible when the resume paginates.",
        startDate: DateTime(2010 + index),
        endDate: DateTime(2011 + index),
      ),
    );
    final details = UserDetailsModel.personal.copyWith(
      experience: const [
        TimelineModel(
          id: "poly",
          title: "Software Developer",
          organization: "Polymorph Systems",
        ),
      ],
      education: education,
    );
    final bytes = await PdfResumeService.generateResume(HeaderModel.fromUserDetails(details));
    final raw = String.fromCharCodes(bytes);
    final match = RegExp(r"/Type/Pages/Kids\[[^\]]+\]/Count\s+(\d+)").firstMatch(raw);

    expect(int.parse(match!.group(1)!), greaterThanOrEqualTo(2));
    expect(
      RegExp(r"/Length\s+(\d+)>>stream").allMatches(raw).map((item) => int.parse(item.group(1)!)).where((length) => length > 400).length,
      greaterThanOrEqualTo(2),
      reason: "later pages should contain flowed education content, not an empty shell",
    );
  });
}
