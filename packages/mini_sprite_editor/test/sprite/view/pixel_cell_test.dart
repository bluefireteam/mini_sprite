// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_sprite_editor/sprite/sprite.dart';

import '../../helpers/helpers.dart';

void main() {
  group('PixelCell', () {
    testWidgets('renders correctly when selected', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: PixelCell(selected: true, hovered: false, pixelSize: 50),
        ),
      );

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/pixel_cell_selected.png'),
      );
    });

    testWidgets('renders correctly when hovered', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: PixelCell(selected: false, hovered: true, pixelSize: 50),
        ),
      );

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/pixel_cell_hovered.png'),
      );
    });

    testWidgets(
      'renders correctly when not selected or hovered',
      (tester) async {
        await tester.pumpApp(
          Scaffold(
            body: PixelCell(selected: false, hovered: false, pixelSize: 50),
          ),
        );

        await expectLater(
          find.byType(Scaffold),
          matchesGoldenFile('goldens/pixel_cell_empty.png'),
        );
      },
    );
  });
}
