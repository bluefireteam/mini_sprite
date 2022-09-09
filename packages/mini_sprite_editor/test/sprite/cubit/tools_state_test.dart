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
          currentColor: 0,
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
          currentColor: 0,
        ),
        equals(
          ToolsState(
            pixelSize: 10,
            tool: SpriteTool.brush,
            gridActive: true,
            currentColor: 0,
          ),
        ),
      );

      expect(
        ToolsState(
          pixelSize: 10,
          tool: SpriteTool.brush,
          gridActive: true,
          currentColor: 0,
        ),
        isNot(
          equals(
            ToolsState(
              pixelSize: 11,
              tool: SpriteTool.brush,
              gridActive: true,
              currentColor: 0,
            ),
          ),
        ),
      );

      expect(
        ToolsState(
          pixelSize: 10,
          tool: SpriteTool.brush,
          gridActive: true,
          currentColor: 0,
        ),
        isNot(
          equals(
            ToolsState(
              pixelSize: 10,
              tool: SpriteTool.eraser,
              gridActive: true,
              currentColor: 0,
            ),
          ),
        ),
      );

      expect(
        ToolsState(
          pixelSize: 10,
          tool: SpriteTool.brush,
          gridActive: true,
          currentColor: 0,
        ),
        isNot(
          equals(
            ToolsState(
              pixelSize: 10,
              tool: SpriteTool.brush,
              gridActive: false,
              currentColor: 0,
            ),
          ),
        ),
      );

      expect(
        ToolsState(
          pixelSize: 10,
          tool: SpriteTool.brush,
          gridActive: true,
          currentColor: 0,
        ),
        isNot(
          equals(
            ToolsState(
              pixelSize: 10,
              tool: SpriteTool.brush,
              gridActive: false,
              currentColor: 1,
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
          currentColor: 0,
        ).copyWith(pixelSize: 11),
        equals(
          ToolsState(
            pixelSize: 11,
            tool: SpriteTool.brush,
            gridActive: false,
            currentColor: 0,
          ),
        ),
      );

      expect(
        ToolsState(
          pixelSize: 10,
          tool: SpriteTool.brush,
          gridActive: false,
          currentColor: 0,
        ).copyWith(tool: SpriteTool.eraser),
        equals(
          ToolsState(
            pixelSize: 10,
            tool: SpriteTool.eraser,
            gridActive: false,
            currentColor: 0,
          ),
        ),
      );

      expect(
        ToolsState(
          pixelSize: 10,
          tool: SpriteTool.brush,
          gridActive: false,
          currentColor: 0,
        ).copyWith(gridActive: true),
        equals(
          ToolsState(
            pixelSize: 10,
            tool: SpriteTool.brush,
            gridActive: true,
            currentColor: 0,
          ),
        ),
      );
    });
  });
}
