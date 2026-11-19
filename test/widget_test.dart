import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tubigtugon/app/tubig_tugon_app.dart';

void main() {
  testWidgets('resident can switch language and open report form', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const TubigTugonApp());
    await tester.pumpAndSettle();

    expect(find.text('TubigTugon'), findsOneWidget);
    expect(find.text('Oras sa tubig karon'), findsOneWidget);

    await tester.tap(find.byKey(const Key('language-menu')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English').last);
    await tester.pumpAndSettle();

    expect(find.text("Today's water schedule"), findsOneWidget);
    await tester.tap(find.text('Report'));
    await tester.pumpAndSettle();
    expect(find.text('Report a Problem'), findsOneWidget);
    expect(find.byKey(const Key('submit-report-button')), findsOneWidget);
  });

  testWidgets('logo opens staff login and valid credentials enter admin area', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const TubigTugonApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('app-logo-button')));
    await tester.pumpAndSettle();
    expect(find.text('Staff Login'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('username-field')), 'admin');
    await tester.enterText(find.byKey(const Key('password-field')), 'admin123');
    await tester.tap(find.byKey(const Key('login-button')));
    await tester.pumpAndSettle();

    expect(find.text('Barangay Staff'), findsOneWidget);
    expect(find.byKey(const Key('print-advisory-button')), findsOneWidget);
    expect(find.byKey(const Key('save-pdf-button')), findsOneWidget);
    expect(find.byKey(const Key('publish-update-button')), findsOneWidget);
  });

  testWidgets('resident can submit a complete issue report', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const TubigTugonApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Pag-report'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('location-dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Duol sa tangke (pasong)').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('problem-dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Walay tubig').last);
    await tester.pumpAndSettle();

    final submitButton = find.byKey(const Key('submit-report-button'));
    await tester.ensureVisible(submitButton);
    await tester.pumpAndSettle();
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    expect(find.text('Nadawat na ang imong report'), findsOneWidget);
  });

  testWidgets('staff can publish and navigate management tools', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const TubigTugonApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('app-logo-button')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('username-field')), 'admin');
    await tester.enterText(find.byKey(const Key('password-field')), 'admin123');
    await tester.tap(find.byKey(const Key('login-button')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('admin-message-field')),
      'Test water update',
    );
    final publishButton = find.byKey(const Key('publish-update-button'));
    await tester.ensureVisible(publishButton);
    await tester.pumpAndSettle();
    await tester.tap(publishButton);
    await tester.pump();
    expect(find.text('Na-post na ang pahibalo.'), findsOneWidget);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Mga report'));
    await tester.pumpAndSettle();
    expect(find.text('Mga report gikan sa residente'), findsOneWidget);

    await tester.tap(find.text('Oras'));
    await tester.pumpAndSettle();
    final saveButton = find.byKey(const Key('save-schedule-button'));
    await tester.ensureVisible(saveButton);
    await tester.pumpAndSettle();
    await tester.tap(saveButton);
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(SnackBar), findsOneWidget);
    final snackText = tester.widget<Text>(
      find.descendant(of: find.byType(SnackBar), matching: find.byType(Text)),
    );
    expect(snackText.data, 'Na-update na ang oras sa tubig.');
  });
}
