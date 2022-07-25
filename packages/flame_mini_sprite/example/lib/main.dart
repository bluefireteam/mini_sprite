import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_mini_sprite/flame_mini_sprite.dart';
import 'package:flutter/material.dart';
import 'package:mini_sprite/mini_sprite.dart';

void main() {
  runApp(GameWidget(game: MyGame()));
}

const raw = '16,16;7,0;2,1;13,0;1,1;2,0;1,1;12,0;1,1;2,0;1,1;12,0;1,1;2,0;1,1;12,0;1,1;2,0;1,1;12,0;1,1;2,0;1,1;11,0;1,1;1,0;2,1;1,0;1,1;10,0;1,1;1,0;2,1;1,0;1,1;10,0;1,1;1,0;2,1;1,0;1,1;9,0;1,1;1,0;1,1;2,0;1,1;1,0;1,1;7,0;1,1;2,0;1,1;2,0;1,1;2,0;1,1;5,0;1,1;2,0;2,1;2,0;2,1;2,0;1,1;3,0;1,1;2,0;1,1;2,0;2,1;2,0;1,1;2,0;1,1;1,0;1,1;2,0;2,1;1,0;1,1;2,0;1,1;1,0;2,1;2,0;2,1;2,0;10,1;2,0;1,1;1,0;2,1;10,0;2,1;1,0';

class MyGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    final miniSprite = MiniSprite.fromDataString(raw);
    final sprite = await miniSprite.toSprite(
        pixelSize: 4,
        color: Colors.white,
    );

    add(SpriteComponent(sprite: sprite, anchor: Anchor.center));

    camera.followVector2(Vector2.zero());
  }
}
