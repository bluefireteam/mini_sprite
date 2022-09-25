// ignore_for_file: lines_longer_than_80_chars

import 'package:flame/components.dart';
import 'package:flame_mini_sprite/flame_mini_sprite.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_sprite/mini_sprite.dart';

void main() {
  const raw =
      '16,16;20,-1;1,0;7,-1;1,0;8,-1;7,0;8,-1;1,0;7,-1;1,0;7,-1;1,0;7,-1;1,0;7,-1;1,0;1,-1;2,0;1,-1;2,0;1,-1;1,0;6,-1;1,0;9,-1;1,0;5,-1;1,0;2,-1;1,0;3,-1;1,0;2,-1;1,0;5,-1;1,0;2,-1;1,0;3,-1;1,0;2,-1;1,0;5,-1;1,0;2,-1;1,0;3,-1;1,0;2,-1;1,0;5,-1;1,0;2,-1;1,0;3,-1;1,0;2,-1;1,0;5,-1;1,0;9,-1;1,0;6,-1;9,0;51,-1';

  const palette = [Colors.white, Colors.black];

  group('MiniSpriteComponent', () {
    testGolden(
      'when no size is specified, pixel size is one',
      (game) async {
        final miniSprite = MiniSprite.fromDataString(raw);
        game.camera.followVector2(Vector2.zero());
        await game.ensureAdd(
          MiniSpriteComponent(
            miniSprite: miniSprite,
            palette: palette,
          ),
        );
      },
      goldenFile: 'goldens/mini_sprite_component_no_size.png',
    );

    testGolden(
      'correctly calculates the pixel size given the size',
      (game) async {
        final miniSprite = MiniSprite.fromDataString(raw);
        game.camera.followVector2(Vector2.zero());
        await game.ensureAdd(
          MiniSpriteComponent(
            miniSprite: miniSprite,
            size: Vector2.all(150),
            palette: palette,
          ),
        );
      },
      goldenFile: 'goldens/mini_sprite_component_with_size.png',
    );

    testGolden(
      'updates the pixel size when the size changes',
      (game) async {
        final miniSprite = MiniSprite.fromDataString(raw);
        game.camera.followVector2(Vector2.zero());
        late MiniSpriteComponent component;

        await game.ensureAdd(
          component = MiniSpriteComponent(
            miniSprite: miniSprite,
            size: Vector2.all(150),
            palette: palette,
          ),
        );

        component.size = Vector2.all(50);
      },
      goldenFile: 'goldens/mini_sprite_component_update_size.png',
    );
  });
}
