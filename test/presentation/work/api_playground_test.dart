import "package:cv_app/data/showcase/secure_ai_case_study.dart";
import "package:cv_app/domain/showcase/showcase_models.dart";
import "package:cv_app/presentation/work/components/api_playground.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  testWidgets("simulated Send Request shows fixture response", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ApiPlayground(endpoints: secureAiCaseStudy.endpoints),
          ),
        ),
      ),
    );

    expect(find.text("Send Request"), findsOneWidget);
    await tester.tap(find.text("Send Request"));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining("Simulated response"), findsOneWidget);
    expect(find.textContaining("access_token"), findsOneWidget);
  });

  testWidgets("switching endpoint ignores a stale simulated send", (tester) async {
    const endpoints = [
      ShowcaseEndpoint(
        id: "slow",
        method: "GET",
        path: "/slow",
        summary: "Slow fixture",
        group: "demo",
        requestJson: "{}",
        responseJson: '{"from":"slow"}',
        responseMs: 400,
      ),
      ShowcaseEndpoint(
        id: "fast",
        method: "GET",
        path: "/fast",
        summary: "Fast fixture",
        group: "demo",
        requestJson: "{}",
        responseJson: '{"from":"fast"}',
        responseMs: 40,
      ),
    ];

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ApiPlayground(endpoints: endpoints),
          ),
        ),
      ),
    );

    await tester.tap(find.text("Send Request"));
    await tester.pump();
    await tester.tap(find.text("/fast"));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.textContaining("Simulated response"), findsNothing);
    expect(find.textContaining('"from":"slow"'), findsNothing);
    expect(find.textContaining('"from":"fast"'), findsNothing);
  });
}
