import 'package:flutter_test/flutter_test.dart';
import 'package:tka_app/app.dart';

void main() {
  testWidgets('TKA App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TkaApp());
    await tester.pumpAndSettle();

    // Bottom nav harus ada: Belajar, Live, Tryout, Pembelian.
    expect(find.text('Belajar'), findsOneWidget);
    expect(find.text('Tryout'), findsWidgets);
    expect(find.text('Pembelian'), findsOneWidget);
  });
}
