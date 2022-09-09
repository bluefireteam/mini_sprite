import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_mini_sprite/flame_mini_sprite.dart';
import 'package:flutter/material.dart';
import 'package:mini_sprite/mini_sprite.dart';

void main() {
  runApp(GameWidget(game: MyGame()));
}

const raw =
    '16,16;20,-1;1,0;7,-1;1,0;8,-1;7,0;8,-1;1,0;7,-1;1,0;7,-1;1,0;7,-1;1,0;7,-1;1,0;1,-1;2,0;1,-1;2,0;1,-1;1,0;6,-1;1,0;9,-1;1,0;5,-1;1,0;2,-1;1,0;3,-1;1,0;2,-1;1,0;5,-1;1,0;2,-1;1,0;3,-1;1,0;2,-1;1,0;5,-1;1,0;2,-1;1,0;3,-1;1,0;2,-1;1,0;5,-1;1,0;2,-1;1,0;3,-1;1,0;2,-1;1,0;5,-1;1,0;9,-1;1,0;6,-1;9,0;51,-1';

class MyGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    final miniSprite = MiniSprite.fromDataString(raw);
    final sprite = await miniSprite.toSprite(
      pixelSize: 4,
      palette: [const Color(0xFFFFFFFF)],
    );

    add(SpriteComponent(sprite: sprite, anchor: Anchor.center));

    camera.followVector2(Vector2.zero());
  }
}
