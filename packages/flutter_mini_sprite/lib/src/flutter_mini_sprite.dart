import 'package:flutter/material.dart';
import 'package:mini_sprite/mini_sprite.dart';

/// {@template mini_sprite_widget}
///
/// A widget that displays a [MiniSprite] on the screen.
///
/// {@endtemplate}
class MiniSpriteWidget extends StatelessWidget {
  /// {@macro mini_sprite_widget}
  const MiniSpriteWidget({
    super.key,
    required this.sprite,
    this.pixelSize = 1,
    this.palette = const [Color(0xFFFFFFFF), Color(0xFF000000)],
  });

  /// The size of each pixel of the sprite, defaults to 1.
  final double pixelSize;

  /// The palette of the sprite, defaults to white and black.
  final List<Color> palette;

  /// The sprite to render.
  final MiniSprite sprite;

  @override
  Widget build(BuildContext context) {
    final width = sprite.pixels[0].length * pixelSize;
    final height = sprite.pixels.length * pixelSize;

    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _MiniSpritePainter(sprite, pixelSize, palette),
      ),
    );
  }
}

class _MiniSpritePainter extends CustomPainter {
  _MiniSpritePainter(this.sprite, this.pixelSize, this.palette);

  final MiniSprite sprite;
  final double pixelSize;
  final List<Color> palette;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    final bleedingValue = pixelSize * 1.05;

    for (var y = 0; y < sprite.pixels.length; y++) {
      for (var x = 0; x < sprite.pixels[y].length; x++) {
        if (sprite.pixels[y][x] != -1) {
          final color = palette[sprite.pixels[y][x]];
          paint.color = color;
          canvas.drawRect(
            Rect.fromLTWH(
              x * pixelSize,
              y * pixelSize,
              bleedingValue,
              bleedingValue,
            ),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate is _MiniSpritePainter) {
      return oldDelegate.sprite != sprite ||
          oldDelegate.pixelSize != pixelSize ||
          oldDelegate.palette != palette;
    }
    return true;
  }
}
