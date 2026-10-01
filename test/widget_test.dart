import 'package:flutter_test/flutter_test.dart';
import 'package:flight_app/main.dart';

void main() {
  testWidgets('PrivateJetApp renders Welcome Screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PrivateJetApp());
    await tester.pumpAndSettle();

    // Verify Welcome text and Get started button are present
    expect(find.text('Welcome\naboard —'), findsOneWidget);
    expect(find.text('Get started'), findsOneWidget);
  });
}
