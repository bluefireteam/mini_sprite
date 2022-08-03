// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:mini_sprite_editor/sprite/cubit/tools_cubit.dart';
import 'package:mini_sprite_editor/sprite/sprite.dart';

void main() {
  group('ToolsState', () {
    test('can be instantiated', () {
      expect(
        ToolsState(
          pixelSize: 10,
          tool: SpriteTool.brush,
          gridActive: true,
        ),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        ToolsState(
          pixelSize: 10,
          tool: SpriteTool.brush,
          gridActive: true,
        ),
        equals(
          ToolsState(
            pixelSize: 10,
            tool: SpriteTool.brush,
            gridActive: true,
          ),
        ),
      );

      expect(
        ToolsState(
          pixelSize: 10,
          tool: SpriteTool.brush,
          gridActive: true,
        ),
        isNot(
          equals(
            ToolsState(
              pixelSize: 11,
              tool: SpriteTool.brush,
              gridActive: true,
            ),
          ),
        ),
      );

      expect(
        ToolsState(
          pixelSize: 10,
          tool: SpriteTool.brush,
          gridActive: true,
        ),
        isNot(
          equals(
            ToolsState(
              pixelSize: 10,
              tool: SpriteTool.eraser,
              gridActive: true,
            ),
          ),
        ),
      );

      expect(
        ToolsState(
          pixelSize: 10,
          tool: SpriteTool.brush,
          gridActive: true,
        ),
        isNot(
          equals(
            ToolsState(
              pixelSize: 10,
              tool: SpriteTool.brush,
              gridActive: false,
            ),
          ),
        ),
      );
    });

    test('copyWith returns a new isntance with the field updated', () {
      expect(
        ToolsState(
          pixelSize: 10,
          tool: SpriteTool.brush,
          gridActive: false,
        ).copyWith(pixelSize: 11),
        equals(
          ToolsState(
            pixelSize: 11,
            tool: SpriteTool.brush,
            gridActive: false,
          ),
        ),
      );

      expect(
        ToolsState(
          pixelSize: 10,
          tool: SpriteTool.brush,
          gridActive: false,
        ).copyWith(tool: SpriteTool.eraser),
        equals(
          ToolsState(
            pixelSize: 10,
            tool: SpriteTool.eraser,
            gridActive: false,
          ),
        ),
      );

      expect(
        ToolsState(
          pixelSize: 10,
          tool: SpriteTool.brush,
          gridActive: false,
        ).copyWith(gridActive: true),
        equals(
          ToolsState(
            pixelSize: 10,
            tool: SpriteTool.brush,
            gridActive: true,
          ),
        ),
      );
    });
  });
}
