import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:mini_sprite/mini_sprite.dart';

/// Adds Flame methods to [MiniSprite].
extension FlameMiniSpriteX on MiniSprite {
  /// Returns a [Sprite] representation of the [MiniSprite].
  Future<Sprite> toSprite({
    required double pixelSize,
    required Color color,
    Color? blankColor,
  }) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    final paint = Paint()..color = color;
    final blankPaint =
        blankColor != null ? (Paint()..color = blankColor) : null;

    for (var y = 0; y < pixels.length; y++) {
      for (var x = 0; x < pixels[y].length; x++) {
        final rect = Rect.fromLTWH(
          x * pixelSize,
          y * pixelSize,
          pixelSize,
          pixelSize,
        );
        if (pixels[y][x]) {
          canvas.drawRect(rect, paint);
        } else if (blankPaint != null) {
          canvas.drawRect(rect, blankPaint);
        }
      }
    }

    final image = await recorder.endRecording().toImage(
      pixels.length * pixelSize.toInt(),
      pixels[0].length * pixelSize.toInt(),
    );

    return Sprite(image);
  }
}
