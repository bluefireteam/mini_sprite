import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_mini_sprite/flame_mini_sprite.dart';
import 'package:mini_sprite/mini_sprite.dart';
import 'package:mini_sprite_editor/config/config.dart';
import 'package:mini_sprite_editor/library/library.dart';
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

    await addAll([
      FlameBlocListener<MapCubit, MapState>(
        listenWhen: (previous, current) {
          return previous.objects[mapPosition] !=
                  current.objects[mapPosition] ||
              previous.objects[mapPosition]?['sprite'] !=
                  current.objects[mapPosition]?['sprite'];
        },
        onNewState: (state) {
          final object = state.objects[mapPosition];
          if (object == null) {
            _sprite = null;
          } else {
            _updateSprite();
          }
        },
      ),
      FlameBlocListener<LibraryCubit, LibraryState>(
        listenWhen: (previous, current) {
          final myKey =
              gameRef.mapCubit.state.objects[mapPosition]?['sprite'] as String?;
          return previous.sprites[myKey] != current.sprites[myKey];
        },
        onNewState: (_) => _updateSprite(),
      ),
      FlameBlocListener<ConfigCubit, ConfigState>(
        listenWhen: (previous, current) {
          return previous.mapGridSize != current.mapGridSize;
        },
        onNewState: (state) {
          size = Vector2.all(state.mapGridSize.toDouble());
          position = Vector2(
                mapPosition.x.toDouble(),
                mapPosition.y.toDouble(),
              ) *
              state.mapGridSize.toDouble();
        },
      ),
    ]);
  }

  void _updateSprite() {
    final object = gameRef.mapCubit.state.objects[mapPosition];
    final spriteId = object?['sprite'] as String?;
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
    } else {
      _sprite = null;
    }
  }

  @override
  bool onTapUp(TapUpInfo info) {
    final library = gameRef.libraryCubit.state;
    final tool = gameRef.mapToolCubit.state.tool;

    switch (tool) {
      case MapTool.brush:
        gameRef.mapCubit.addObject(
          mapPosition.x,
          mapPosition.y,
          <String, dynamic>{
            'sprite': library.selected,
          },
        );
        break;
      case MapTool.eraser:
        gameRef.mapCubit.removeObject(
          mapPosition.x,
          mapPosition.y,
        );
        break;
      case MapTool.none:
        break;
    }
    return true;
  }

  @override
  void render(Canvas canvas) {
    if (gameRef.mapToolCubit.state.gridActive) {
      canvas.drawRect(size.toRect(), paint);
    }
    _sprite?.render(canvas);
  }
}
