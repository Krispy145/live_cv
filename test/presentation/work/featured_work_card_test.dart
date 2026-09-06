import "package:cv_app/data/showcase/showcase_catalog.dart";
import "package:cv_app/presentation/engineering/engineering_view.dart";
import "package:cv_app/presentation/work/components/featured_work_card.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  testWidgets("selected work card shows title and case-study action",
      (tester) async {
    final study = ShowcaseCatalog.featured.first;
    var opened = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FeaturedWorkCard(
            study: study,
            onOpen: () => opened = true,
          ),
        ),
      ),
    );

    expect(find.textContaining("KISBEY"), findsOneWidget);
    await tester.tap(find.text("View case study  →"));
    expect(opened, isTrue);
  });

  testWidgets("engineering view lists stack layers", (tester) async {
    await tester
        .pumpWidget(const MaterialApp(home: Scaffold(body: EngineeringView())));
    expect(find.text("APPLICATION"), findsOneWidget);
    expect(find.text("BACKEND"), findsOneWidget);
    expect(find.byType(MenuAnchor), findsNWidgets(5));
  });

  testWidgets("selecting a technology lists matching case studies",
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: EngineeringView())),
    );

    await tester.tap(find.text("APPLICATION"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Flutter").last);
    await tester.pumpAndSettle();

    expect(find.textContaining("Used in"), findsOneWidget);
    expect(find.text("Clear"), findsOneWidget);
  });
}
