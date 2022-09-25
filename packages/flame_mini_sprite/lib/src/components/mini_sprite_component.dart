import 'dart:ui';

import 'package:flame/components.dart';
import 'package:mini_sprite/mini_sprite.dart';

class _PixelEntry {
  _PixelEntry({
    required this.position,
    required this.currentPosition,
    required this.color,
  });

  final Vector2 position;
  Vector2 currentPosition;

  final int color;
}

/// {@template mini_sprite_component}
///
/// A [PositionComponent] that renders a [MiniSprite].
///
/// {@endtemplate}
class MiniSpriteComponent extends PositionComponent {
  /// {@macro mini_sprite_component}
  MiniSpriteComponent({
    required this.miniSprite,
    required List<Color> palette,
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority,
  }) {
    _entries = [
      for (int y = 0; y < miniSprite.pixels.length; y++)
        for (int x = 0; x < miniSprite.pixels[y].length; x++)
          _PixelEntry(
            position: Vector2(x.toDouble(), y.toDouble()),
            currentPosition: Vector2(x.toDouble(), y.toDouble()),
            color: miniSprite.pixels[y][x],
          ),
    ];

    _palette = [
      for (final color in palette) Paint()..color = color,
    ];
  }

  /// The [MiniSprite] to render.
  final MiniSprite miniSprite;
  late List<Paint> _palette;

  late final List<_PixelEntry> _entries;

  late double _pixelSize;

  @override
  Future<void> onLoad() async {
    // If no size was specified we assume that the pixel size is 1.
    if (size.isZero()) {
      size = Vector2(
        miniSprite.pixels[0].length.toDouble(),
        miniSprite.pixels.length.toDouble(),
      );
      _pixelSize = 1;
    } else {
      _setPixelSize();
    }

    size.addListener(_setPixelSize);
  }

  void _setPixelSize() {
    _pixelSize = (size.x / miniSprite.pixels[0].length).floorToDouble();
  }

  @override
  void render(Canvas canvas) {
    for (final entry in _entries) {
      if (entry.color == -1) {
        continue;
      }

      final paint = _palette[entry.color];
      if (paint.color.alpha == 0) {
        continue;
      }

      canvas.drawRect(
        Rect.fromLTWH(
          entry.currentPosition.x * _pixelSize,
          entry.currentPosition.y * _pixelSize,
          _pixelSize,
          _pixelSize,
        ),
        paint,
      );
    }
  }
}
