// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:mini_sprite_editor/sprite/sprite.dart';

void main() {
  group('SpriteState', () {
    test('can be instantiated', () {
      expect(
        SpriteState(
          pixelSize: 10,
          pixels: const [],
          cursorPosition: Offset.zero,
          tool: SpriteTool.brush,
          toolActive: false,
        ),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        SpriteState(
          pixelSize: 10,
          pixels: const [],
          cursorPosition: Offset.zero,
          tool: SpriteTool.brush,
          toolActive: false,
        ),
        equals(
          SpriteState(
            pixelSize: 10,
            pixels: const [],
            cursorPosition: Offset.zero,
            tool: SpriteTool.brush,
            toolActive: false,
          ),
        ),
      );

      expect(
        SpriteState(
          pixelSize: 10,
          pixels: const [],
          cursorPosition: Offset.zero,
          tool: SpriteTool.brush,
          toolActive: false,
        ),
        isNot(
          equals(
            SpriteState(
              pixelSize: 11,
              pixels: const [],
              cursorPosition: Offset.zero,
              tool: SpriteTool.brush,
              toolActive: false,
            ),
          ),
        ),
      );

      expect(
        SpriteState(
          pixelSize: 10,
          pixels: const [],
          cursorPosition: Offset.zero,
          tool: SpriteTool.brush,
          toolActive: false,
        ),
        isNot(
          equals(
            SpriteState(
              pixelSize: 10,
              pixels: const [
                [true]
              ],
              cursorPosition: Offset.zero,
              tool: SpriteTool.brush,
              toolActive: false,
            ),
          ),
        ),
      );

      expect(
        SpriteState(
          pixelSize: 10,
          pixels: const [],
          cursorPosition: Offset.zero,
          tool: SpriteTool.brush,
          toolActive: false,
        ),
        isNot(
          equals(
            SpriteState(
              pixelSize: 10,
              pixels: const [],
              cursorPosition: Offset(1, 1),
              tool: SpriteTool.brush,
              toolActive: false,
            ),
          ),
        ),
      );

      expect(
        SpriteState(
          pixelSize: 10,
          pixels: const [],
          cursorPosition: Offset.zero,
          tool: SpriteTool.brush,
          toolActive: false,
        ),
        isNot(
          equals(
            SpriteState(
              pixelSize: 10,
              pixels: const [],
              cursorPosition: Offset.zero,
              tool: SpriteTool.eraser,
              toolActive: false,
            ),
          ),
        ),
      );

      expect(
        SpriteState(
          pixelSize: 10,
          pixels: const [],
          cursorPosition: Offset.zero,
          tool: SpriteTool.brush,
          toolActive: false,
        ),
        isNot(
          equals(
            SpriteState(
              pixelSize: 10,
              pixels: const [],
              cursorPosition: Offset.zero,
              tool: SpriteTool.brush,
              toolActive: true,
            ),
          ),
        ),
      );
    });

    test('copyWith returns a new isntance with the field updated', () {
      expect(
        SpriteState(
          pixelSize: 10,
          pixels: const [],
          cursorPosition: Offset.zero,
          tool: SpriteTool.brush,
          toolActive: false,
        ).copyWith(pixelSize: 11),
        equals(
          SpriteState(
            pixelSize: 11,
            pixels: const [],
            cursorPosition: Offset.zero,
            tool: SpriteTool.brush,
            toolActive: false,
          ),
        ),
      );

      expect(
        SpriteState(
          pixelSize: 10,
          pixels: const [],
          cursorPosition: Offset.zero,
          tool: SpriteTool.brush,
          toolActive: false,
        ).copyWith(
          pixels: [
            [true]
          ],
        ),
        equals(
          SpriteState(
            pixelSize: 10,
            pixels: const [
              [true]
            ],
            cursorPosition: Offset.zero,
            tool: SpriteTool.brush,
            toolActive: false,
          ),
        ),
      );

      expect(
        SpriteState(
          pixelSize: 10,
          pixels: const [],
          cursorPosition: Offset.zero,
          tool: SpriteTool.brush,
          toolActive: false,
        ).copyWith(cursorPosition: Offset(1, 1)),
        equals(
          SpriteState(
            pixelSize: 10,
            pixels: const [],
            cursorPosition: Offset(1, 1),
            tool: SpriteTool.brush,
            toolActive: false,
          ),
        ),
      );

      expect(
        SpriteState(
          pixelSize: 10,
          pixels: const [],
          cursorPosition: Offset.zero,
          tool: SpriteTool.brush,
          toolActive: false,
        ).copyWith(tool: SpriteTool.eraser),
        equals(
          SpriteState(
            pixelSize: 10,
            pixels: const [],
            cursorPosition: Offset.zero,
            tool: SpriteTool.eraser,
            toolActive: false,
          ),
        ),
      );

      expect(
        SpriteState(
          pixelSize: 10,
          pixels: const [],
          cursorPosition: Offset.zero,
          tool: SpriteTool.brush,
          toolActive: false,
        ).copyWith(toolActive: true),
        equals(
          SpriteState(
            pixelSize: 10,
            pixels: const [],
            cursorPosition: Offset.zero,
            tool: SpriteTool.brush,
            toolActive: true,
          ),
        ),
      );
    });
  });
}
