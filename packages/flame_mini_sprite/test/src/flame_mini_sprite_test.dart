// ignore_for_file: prefer_const_constructors, lines_longer_than_80_chars
import 'package:flame/components.dart';
import 'package:flame_mini_sprite/flame_mini_sprite.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_sprite/mini_sprite.dart';

void main() {
  const palette = [Colors.white, Colors.black];
  group('FlameMiniSpriteX', () {
    const raw =
        '16,16;7,0;2,1;13,0;1,1;2,0;1,1;12,0;1,1;2,0;1,1;12,0;1,1;2,0;1,1;12,0;1,1;2,0;1,1;12,0;1,1;2,0;1,1;11,0;1,1;1,0;2,1;1,0;1,1;10,0;1,1;1,0;2,1;1,0;1,1;10,0;1,1;1,0;2,1;1,0;1,1;9,0;1,1;1,0;1,1;2,0;1,1;1,0;1,1;7,0;1,1;2,0;1,1;2,0;1,1;2,0;1,1;5,0;1,1;2,0;2,1;2,0;2,1;2,0;1,1;3,0;1,1;2,0;1,1;2,0;2,1;2,0;1,1;2,0;1,1;1,0;1,1;2,0;2,1;1,0;1,1;2,0;1,1;1,0;2,1;2,0;2,1;2,0;10,1;2,0;1,1;1,0;2,1;10,0;2,1;1,0';

    testGolden(
      'renders correctly',
      (game) async {
        final miniSprite = MiniSprite.fromDataString(raw);
        final sprite =
            await miniSprite.toSprite(palette: palette, pixelSize: 4);

        game.camera.followVector2(Vector2.zero());
        await game
            .ensureAdd(SpriteComponent(sprite: sprite, anchor: Anchor.center));
      },
      goldenFile: 'goldens/flame_mini_sprite.png',
    );

    testGolden(
      'renders correctly when a background color is used',
      (game) async {
        final miniSprite = MiniSprite.fromDataString(raw);
        final sprite = await miniSprite.toSprite(
          palette: palette,
          pixelSize: 4,
          backgroundColor: Colors.blue,
        );

        game.camera.followVector2(Vector2.zero());
        await game
            .ensureAdd(SpriteComponent(sprite: sprite, anchor: Anchor.center));
      },
      goldenFile: 'goldens/flame_mini_sprite_with_background_color.png',
    );
  });

  group('FlameMiniLibraryX', () {
    // ignore: leading_newlines_in_multiline_strings
    const raw = '''ground|6,6;6,1;1,0;1,1;3,0;1,1;8,0;1,1;15,0
flower|6,6;1,1;1,0;1,1;1,0;1,1;2,0;1,1;1,0;1,1;4,0;1,1;5,0;1,1;1,0;1,1;3,0;2,1;4,0;1,1;3,0''';

    testGolden(
      'renders correctly the ground',
      (game) async {
        final library = MiniLibrary.fromDataString(raw);
        final sprites = await library.toSprites(
          palette: palette,
          pixelSize: 4,
        );

        final sprite = sprites['ground'];

        game.camera.followVector2(Vector2.zero());
        await game
            .ensureAdd(SpriteComponent(sprite: sprite, anchor: Anchor.center));
      },
      goldenFile: 'goldens/flame_mini_library_ground.png',
    );

    testGolden(
      'renders correctly the ground',
      (game) async {
        final library = MiniLibrary.fromDataString(raw);
        final sprites = await library.toSprites(
          palette: palette,
          pixelSize: 4,
        );

        final sprite = sprites['flower'];

        game.camera.followVector2(Vector2.zero());
        await game
            .ensureAdd(SpriteComponent(sprite: sprite, anchor: Anchor.center));
      },
      goldenFile: 'goldens/flame_mini_library_flower.png',
    );
  });
}
