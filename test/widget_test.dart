import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:library_book_app/pages/login_page.dart';

void main() {
  testWidgets('shows validation errors for empty fields', (tester) async {
    await tester.view.setLogicalSize(const Size(1000, 900));
    await tester.view.setDevicePixelRatio(1);
    addTearDown(tester.view.resetLogicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(home: LoginPage(onLoginSuccess: () {})),
    );

    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Enter your email'), findsOneWidget);
    expect(find.text('Enter your password'), findsOneWidget);
  });
}
