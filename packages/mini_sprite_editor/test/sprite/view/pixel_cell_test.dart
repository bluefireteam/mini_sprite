// Ignoring for tests
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
          backgroundColor: Colors.white,
          body: PixelCell(
            color: Color(0xFFFFFFFF),
            hovered: false,
            pixelSize: 50,
            hasBorder: true,
          ),
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
          backgroundColor: Colors.white,
          body: PixelCell(
            color: Color(0xFFFFFFFF),
            hovered: true,
            pixelSize: 50,
            hasBorder: true,
          ),
        ),
      );

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/pixel_cell_hovered.png'),
      );
    });

    testWidgets('renders correctly when not selected or hovered', (
      tester,
    ) async {
      await tester.pumpApp(
        Scaffold(
          backgroundColor: Colors.white,
          body: PixelCell(
            color: Color(0xFFFFFFFF),
            hovered: false,
            pixelSize: 50,
            hasBorder: true,
          ),
        ),
      );

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/pixel_cell_empty.png'),
      );
    });

    testWidgets('renders correctly when there is no grid active', (
      tester,
    ) async {
      await tester.pumpApp(
        Scaffold(
          backgroundColor: Colors.white,
          body: PixelCell(
            color: Color(0xFFFFFFFF),
            hovered: false,
            pixelSize: 50,
            hasBorder: false,
          ),
        ),
      );

      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/pixel_cell_no_border.png'),
      );
    });

    testWidgets(
      'renders correctly when there is no grid active and is selected',
      (tester) async {
        await tester.pumpApp(
          Scaffold(
            backgroundColor: Colors.white,
            body: PixelCell(
              color: Color(0xFFFFFFFF),
              hovered: false,
              pixelSize: 50,
              hasBorder: false,
            ),
          ),
        );

        await expectLater(
          find.byType(Scaffold),
          matchesGoldenFile('goldens/selected_pixel_cell_no_border.png'),
        );
      },
    );
  });
}
