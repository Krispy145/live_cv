import "package:cv_app/data/showcase/secure_ai_case_study.dart";
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
}
