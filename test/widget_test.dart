import 'package:flutter_test/flutter_test.dart';
import 'package:avaliacao_2/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const DeliveryHubApp());
    expect(find.text('Delivery Hub - Avaliação 2'), findsOneWidget);
  });
}
