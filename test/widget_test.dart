import 'package:flutter_test/flutter_test.dart';

import 'package:color_palette/main.dart';

void main() {
  testWidgets('shows palettes and copy hint', (WidgetTester tester) async {
    await tester.pumpWidget(const ColorPaletteApp());

    expect(find.text('Color Palette'), findsOneWidget);
    expect(find.text('Sunset'), findsOneWidget);
    expect(find.text('Ocean'), findsOneWidget);
  });
}
