// Ignoring for test
// ignore_for_file: lines_longer_than_80_chars
import 'package:flutter/material.dart';
import 'package:flutter_mini_sprite/flutter_mini_sprite.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_sprite/mini_sprite.dart';

void main() {
  group('FlutterMiniSprite', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(
        Center(
          child: MiniSpriteWidget(
            pixelSize: 10,
            sprite: MiniSprite.fromDataString(
              '8,8;1,-1;3,1;4,-1;1,1;3,0;1,1;3,-1;1,1;4,0;2,1;1,-1;1,1;6,0;2,1;6,0;2,1;4,0;2,1;1,-1;1,1;3,0;1,1;4,-1;3,1;4,-1',
            ),
          ),
        ),
      );

      expect(
        find.byType(Center),
        matchesGoldenFile('goldens/flutter_mini_sprite_test.0.0.png'),
      );
    });
  });
}
