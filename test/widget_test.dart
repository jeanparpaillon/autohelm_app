import 'package:flutter_test/flutter_test.dart';
import 'package:autohelm_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AutohelmApp());

    // Verify that the app title is displayed.
    expect(find.text('Autohelm Remote'), findsOneWidget);
    expect(find.text('Autohelm App - Ready for development'), findsOneWidget);
  });
}
