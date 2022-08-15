import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_mini_sprite/flame_mini_sprite.dart';
import 'package:mini_sprite/mini_sprite.dart';
import 'package:mini_sprite_editor/map/map.dart';

class TileComponent extends PositionComponent
    with Hoverable, HasPaint, HasGameRef<MapBoardGame>, Tappable {
  TileComponent({
    super.position,
    super.size,
    required this.mapPosition,
  });

  final MapPosition mapPosition;

  Sprite? _sprite;

  @override
  Future<void> onLoad() async {
    paint = Paint()
      ..color = gameRef.configCubit.state.filledColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    await add(
      FlameBlocListener<MapCubit, MapState>(
        listenWhen: (previous, current) {
          return previous.objects[mapPosition] != current.objects[mapPosition];
        },
        onNewState: (state) {
          final spriteId = state.objects[mapPosition]?['sprite'] as String?;
          final miniSprite = gameRef.libraryCubit.state.sprites[spriteId];
          if (miniSprite != null) {
            // TODO cache this somehow.
            miniSprite
                .toSprite(
                  pixelSize: 1,
                  color: gameRef.configCubit.state.filledColor,
                  blankColor: gameRef.configCubit.state.unfilledColor,
                  backgroundColor: gameRef.configCubit.state.backgroundColor,
                )
                .then((value) => _sprite = value);
          }
        },
      ),
    );
  }

  @override
  bool onTapUp(TapUpInfo info) {
    final library = gameRef.libraryCubit.state;
    gameRef.mapCubit.addObject(
      mapPosition.x,
      mapPosition.y,
      <String, dynamic>{
        'sprite': library.selected,
      },
    );
    return true;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), paint);
    _sprite?.render(canvas);
  }
}
