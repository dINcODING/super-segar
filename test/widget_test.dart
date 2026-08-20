import 'package:cleanserviceweb/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('premium detailing homepage renders', (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const DetailApp());
    expect(find.text('Dalaman kereta anda. Kembali sempurna.'), findsOneWidget);
    expect(find.text('Tempah sekarang'), findsOneWidget);
    await tester.tap(find.text('BI'));
    await tester.pumpAndSettle();
    expect(find.text('Your car’s best interior. Recovered.'), findsOneWidget);
  });

  testWidgets('mobile layout has no overflow', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const DetailApp());
    await tester.pumpAndSettle();
    expect(find.text('BM'), findsOneWidget);
    expect(find.text('Tempah sekarang'), findsOneWidget);

    for (var i = 0; i < 10; i++) {
      await tester.drag(
        find.byType(SingleChildScrollView).first,
        const Offset(0, -600),
      );
      await tester.pumpAndSettle();
    }
  });

  testWidgets('vehicle choice opens booking with matching amount', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const DetailApp());

    await tester.ensureVisible(find.text('Pilih kenderaan').first);
    await tester.tap(find.text('Pilih kenderaan').first);
    await tester.pumpAndSettle();

    expect(find.text('Seterusnya: Pilih servis'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(0), 'Nur Ahmad');
    await tester.enterText(find.byType(TextFormField).at(1), '0139281004');
    await tester.enterText(find.byType(TextFormField).at(2), 'Honda City');
    await tester.enterText(find.byType(TextFormField).at(3), 'Shah Alam');
    await tester.tap(find.byIcon(Icons.calendar_today_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('${DateTime.now().day}').last);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Seterusnya: Pilih servis'));
    await tester.tap(find.text('Seterusnya: Pilih servis'));
    await tester.pumpAndSettle();

    expect(find.text('Servis tambahan (pilihan)'), findsOneWidget);
    expect(find.text('Sedan · RM 115'), findsOneWidget);
    await tester.tap(find.text('Cuci bumbung  +RM 47'));
    await tester.pumpAndSettle();
    expect(find.text('RM 162'), findsOneWidget);
    await tester.tap(find.text('Cuci karpet lantai badan  +RM 47'));
    await tester.pumpAndSettle();
    expect(find.text('TAHNIAH! CUCI BADAN KERETA PERCUMA'), findsOneWidget);
    expect(find.text('RM 209'), findsOneWidget);
    expect(find.textContaining('Cuci karpet kaki'), findsNothing);
  });
}
