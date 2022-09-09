import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:mini_sprite/mini_sprite.dart';

/// Adds Flame methods to [MiniSprite].
extension FlameMiniSpriteX on MiniSprite {
  /// Returns a [Sprite] representation of the [MiniSprite].
  Future<Sprite> toSprite({
    required double pixelSize,
    required List<Color> palette,
    Color? backgroundColor,
  }) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    final _paintPalette =
        palette.map((color) => Paint()..color = color).toList();

    final w = pixels[0].length * pixelSize.toInt();
    final h = pixels.length * pixelSize.toInt();

    if (backgroundColor != null) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble()),
        Paint()..color = backgroundColor,
      );
    }

    for (var y = 0; y < pixels.length; y++) {
      for (var x = 0; x < pixels[y].length; x++) {
        final rect = Rect.fromLTWH(
          x * pixelSize,
          y * pixelSize,
          pixelSize,
          pixelSize,
        );
        if (pixels[y][x] != -1) {
          canvas.drawRect(rect, _paintPalette[pixels[y][x]]);
        }
      }
    }

    final image = await recorder.endRecording().toImage(w, h);

    return Sprite(image);
  }
}

/// Adds Flame methods to [MiniLibrary].
extension FlameMiniLibraryX on MiniLibrary {
  /// Returns a map of [Sprite]s of this [MiniLibrary].
  Future<Map<String, Sprite>> toSprites({
    required double pixelSize,
    required List<Color> palette,
    Color? backgroundColor,
  }) async {
    final futureEntries = sprites.entries.map((entry) async {
      final sprite = await entry.value.toSprite(
        pixelSize: pixelSize,
        palette: palette,
        backgroundColor: backgroundColor,
      );

      return MapEntry(entry.key, sprite);
    });

    final entries = await Future.wait(futureEntries);
    return Map.fromEntries(entries);
  }
}
