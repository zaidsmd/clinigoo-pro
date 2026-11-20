import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clinigoo_pro/app/app.dart';
import 'package:clinigoo_pro/features/auth/widgets/auth_scaffold.dart';

void main() {
  testWidgets('ClinigooProApp builds and displays splash screen smoke test',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: ClinigooProApp(),
      ),
    );

    expect(find.byType(ClinigooProApp), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('AuthScaffold renders logo-long svg without errors',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AuthScaffold(
          showBrand: true,
          title: 'Test Title',
          child: SizedBox(),
        ),
      ),
    );

    expect(find.byType(AuthScaffold), findsOneWidget);
    await tester.pumpAndSettle();
  });
}
