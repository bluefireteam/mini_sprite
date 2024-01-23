import 'dart:ui';

import 'package:flame/components.dart';
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
  bool _selected = false;
  bool _hasData = false;

  late final Paint _selectedPaint;
  late final Paint _hasDataPaint;

  @override
  Future<void> onLoad() async {
    paint = Paint()
      ..color = gameRef.configCubit.state.filledColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    _selectedPaint = Paint()..color = gameRef.primaryColor.withOpacity(0.4);

    _hasDataPaint = Paint()..color = gameRef.primaryColor.withOpacity(0.8);

    await addAll([
      FlameBlocListener<MapCubit, MapState>(
        listenWhen: (previous, current) {
          return previous.objects[mapPosition] != current.objects[mapPosition];
        },
        onNewState: (state) {
          final object = state.objects[mapPosition];
          if (object == null) {
            _sprite = null;
            _hasData = false;
          } else {
            _updateSprite();
          }
        },
      ),
      FlameBlocListener<MapCubit, MapState>(
        listenWhen: (previous, current) {
          return previous.selectedObject != current.selectedObject &&
              (current.selectedObject == mapPosition ||
                  previous.selectedObject == mapPosition);
        },
        onNewState: (state) {
          _selected = state.selectedObject == mapPosition;
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
      // TODO(erickzanardo): cache this somehow.
      miniSprite
          .toSprite(
            pixelSize: 1,
            palette: gameRef.configCubit.palette(),
            backgroundColor: gameRef.configCubit.state.backgroundColor,
          )
          .then((value) => _sprite = value);
    } else {
      _sprite = null;
      _hasData = object?.isNotEmpty ?? false;
    }
  }

  @override
  bool onTapUp(TapUpInfo info) {
    final library = gameRef.libraryCubit.state;
    final tool = gameRef.mapToolCubit.state.tool;

    switch (tool) {
      case MapTool.none:
        gameRef.mapCubit.setSelected(mapPosition);
        break;
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
    }
    return true;
  }

  @override
  void render(Canvas canvas) {
    if (_hasData) {
      canvas.drawRect(size.toRect(), _hasDataPaint);
    } else {
      _sprite?.render(canvas);
    }
    if (_selected) {
      canvas.drawRect(size.toRect(), _selectedPaint);
    }
    if (gameRef.mapToolCubit.state.gridActive) {
      canvas.drawRect(size.toRect(), paint);
    }
  }
}
