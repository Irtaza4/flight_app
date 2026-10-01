import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flight_app/main.dart';
import 'package:flight_app/screens/jet_selection_screen.dart';

void main() {
  testWidgets('PrivateJetApp renders Welcome Screen and navigates to Flight Search', (WidgetTester tester) async {
    await tester.pumpWidget(const PrivateJetApp());
    await tester.pump(const Duration(milliseconds: 1400));

    // Verify Welcome elements
    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('aboard'), findsOneWidget);
    expect(find.text('Get started'), findsOneWidget);

    // Tap Get started to navigate to Flight Search
    await tester.tap(find.text('Get started'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1600));

    // Verify Flight Search elements
    expect(find.text('Your flight'), findsOneWidget);
    expect(find.text('From'), findsOneWidget);
    expect(find.text('To'), findsOneWidget);
    expect(find.text('Choose airplane'), findsOneWidget);
  });

  testWidgets('JetSelectionScreen displays luxury jets and navigates with Hero animation', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: JetSelectionScreen(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1600));

    expect(find.text('Choose your jet'), findsOneWidget);
    expect(find.text('Airplan'), findsOneWidget);
    expect(find.text('Private Jet'), findsOneWidget);
    expect(find.text('Famaly plane'), findsOneWidget);

    // Tap on first jet card to test Hero flight navigation to JetDetailScreen
    await tester.tap(find.text('Airplan'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Reserve Aircraft'), findsOneWidget);
    expect(find.text('Cabin Amenities & Comfort'), findsOneWidget);
  });
}
