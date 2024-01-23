// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:mini_sprite_editor/sprite/sprite.dart';

void main() {
  group('SpriteState', () {
    test('can be instantiated', () {
      expect(
        SpriteState(
          pixels: const [],
          cursorPosition: Offset.zero,
        ),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        SpriteState(
          pixels: const [],
          cursorPosition: Offset.zero,
        ),
        equals(
          SpriteState(
            pixels: const [],
            cursorPosition: Offset.zero,
          ),
        ),
      );

      expect(
        SpriteState(
          pixels: const [],
          cursorPosition: Offset.zero,
        ),
        isNot(
          equals(
            SpriteState(
              pixels: const [
                [1],
              ],
              cursorPosition: Offset.zero,
            ),
          ),
        ),
      );

      expect(
        SpriteState(
          pixels: const [],
          cursorPosition: Offset.zero,
        ),
        isNot(
          equals(
            SpriteState(
              pixels: const [],
              cursorPosition: Offset(1, 0),
            ),
          ),
        ),
      );
    });

    test('copyWith returns a new isntance with the field updated', () {
      expect(
        SpriteState(
          pixels: const [],
          cursorPosition: Offset.zero,
        ).copyWith(
          pixels: [
            [1],
          ],
        ),
        equals(
          SpriteState(
            pixels: const [
              [1],
            ],
            cursorPosition: Offset.zero,
          ),
        ),
      );

      expect(
        SpriteState(
          pixels: const [],
          cursorPosition: Offset.zero,
        ).copyWith(cursorPosition: Offset(1, 1)),
        equals(
          SpriteState(
            pixels: const [],
            cursorPosition: Offset(1, 1),
          ),
        ),
      );
    });
  });
}
