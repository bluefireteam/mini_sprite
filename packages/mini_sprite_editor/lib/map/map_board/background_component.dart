import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:mini_sprite_editor/config/cubit/config_cubit.dart';
import 'package:mini_sprite_editor/map/map.dart';

class BackgroundComponent extends PositionComponent
    with HasPaint, HasGameRef<MapBoardGame> {
  BackgroundComponent();

  @override
  Future<void> onLoad() async {
    await addAll([
      FlameBlocListener<ConfigCubit, ConfigState>(
        listenWhen: (previous, current) {
          return previous.backgroundColor != current.backgroundColor;
        },
        onNewState: (state) {
          _setColor(state.backgroundColor);
        },
      ),
      FlameBlocListener<ConfigCubit, ConfigState>(
        listenWhen: (previous, current) {
          return previous.mapGridSize != current.mapGridSize;
        },
        onNewState: (_) => _setSize(),
      ),
      FlameBlocListener<MapCubit, MapState>(
        listenWhen: (previous, current) {
          return previous.mapSize != current.mapSize;
        },
        onNewState: (_) => _setSize(),
      ),
    ]);

    _setColor(gameRef.configCubit.state.backgroundColor);
    _setSize();
  }

  void _setColor(Color color) {
    paint = Paint()..color = color;
  }

  void _setSize() {
    final mapUnitSize = gameRef.mapCubit.state.mapSize.toVector2();
    final gridSize = gameRef.configCubit.state.mapGridSize.toDouble();

    size = mapUnitSize * gridSize;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), paint);
  }
}
