import 'package:flutter_test/flutter_test.dart';

import 'package:design_overhaul/main.dart';

void main() {
  testWidgets('App builds without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const CookieDealApp());
    expect(find.text('기업 탐색'), findsWidgets);
  });
}
