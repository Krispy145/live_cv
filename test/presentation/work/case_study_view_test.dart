import "package:cv_app/presentation/work/case_study_view.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  testWidgets("kisbey case study shows overview and switches to API playground", (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CaseStudyView(slug: "kisbey-pos"),
        ),
      ),
    );

    expect(find.textContaining("KISBEY"), findsWidgets);
    expect(find.text("THE CHALLENGE"), findsOneWidget);

    await tester.ensureVisible(find.text("API"));
    await tester.tap(find.text("API"));
    await tester.pumpAndSettle();

    expect(find.text("Send Request"), findsOneWidget);
    expect(find.text("/auth/sign-in"), findsOneWidget);
  });
}
