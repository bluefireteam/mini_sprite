import 'package:dashbook/dashbook.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mini_sprite/flutter_mini_sprite.dart';
import 'package:mini_sprite/mini_sprite.dart';

void main() {
  final dashbook = Dashbook();

  dashbook.storiesOf('Flutter Mini Sprite').add(
    'default',
    (context) {
      return Center(
        child: MiniSpriteWidget(
          pixelSize: context.numberProperty('pixelSize', 10),
          sprite: MiniSprite.fromDataString(
              '8,8;1,-1;3,1;4,-1;1,1;3,0;1,1;3,-1;1,1;4,0;2,1;1,-1;1,1;6,0;2,1;6,0;2,1;4,0;2,1;1,-1;1,1;3,0;1,1;4,-1;3,1;4,-1'),
          palette: [
            context.colorProperty('color 1', const Color(0xFFFFFFFF)),
            context.colorProperty('color 2', const Color(0xFF000000)),
          ],
        ),
      );
    },
  ).add(
    'animating',
    (context) {
      return Center(
        child: AnimatedScale(
          duration: const Duration(seconds: 1),
          scale: context.numberProperty('scale', 1.0),
          child: MiniSpriteWidget(
            pixelSize: 2,
            sprite: MiniSprite.fromDataString(
                '8,8;1,-1;3,1;4,-1;1,1;3,0;1,1;3,-1;1,1;4,0;2,1;1,-1;1,1;6,0;2,1;6,0;2,1;4,0;2,1;1,-1;1,1;3,0;1,1;4,-1;3,1;4,-1'),
            palette: [
              context.colorProperty('color 1', const Color(0xFFFFFFFF)),
              context.colorProperty('color 2', const Color(0xFF000000)),
            ],
          ),
        ),
      );
    },
  );

  runApp(dashbook);
}
