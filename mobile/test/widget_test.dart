import 'package:flutter_test/flutter_test.dart';
import 'package:swarsanket/main.dart';

void main() {
  testWidgets('SwarSanketApp launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SwarSanketApp());
    expect(find.textContaining('Voice Check'), findsWidgets);
  });
}
