import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_health_app/features/auth/presentation/views/splash_view.dart';

// The default "counter" smoke test of `flutter create` does not apply to this
// app (it needs Firebase), so this file now holds a small real widget test.
void main() {
  testWidgets('SplashView shows a loading indicator', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SplashView()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
