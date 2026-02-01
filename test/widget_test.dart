import 'package:flutter_test/flutter_test.dart';

import 'package:pearl/main.dart';

void main() {
  testWidgets('App renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PearlApp());
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
  });
}
