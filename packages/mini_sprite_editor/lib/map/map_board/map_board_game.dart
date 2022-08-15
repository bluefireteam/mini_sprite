import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:mini_sprite/mini_sprite.dart';
import 'package:mini_sprite_editor/config/config.dart';
import 'package:mini_sprite_editor/library/cubit/library_cubit.dart';
import 'package:mini_sprite_editor/map/map.dart';

// TODO should be a config
final tileSize = 16;

final mapSize = Vector2(10, 10);

class MapBoardGame extends FlameGame
    with HasHoverables, PanDetector, HasTappables {
  MapBoardGame({
    required this.configCubit,
    required this.libraryCubit,
    required this.mapCubit,
    required this.mapToolCubit,
  });

  final ConfigCubit configCubit;
  final LibraryCubit libraryCubit;
  final MapCubit mapCubit;
  final MapToolCubit mapToolCubit;
  late final Component board;

  @override
  void onPanUpdate(DragUpdateInfo info) {
    camera.snapTo(camera.position - info.delta.game);
  }

  @override
  Future<void> onLoad() async {
    board = PositionComponent();

    final tiles = <TileComponent>[];
    for (var y = 0; y < mapSize.y; y++) {
      for (var x = 0; x < mapSize.x; x++) {
        final tile = TileComponent(
          position: Vector2(
            x * tileSize.toDouble(),
            y * tileSize.toDouble(),
          ),
          mapPosition: MapPosition(x, y),
          size: Vector2(tileSize.toDouble(), tileSize.toDouble()),
        );

        tiles.add(tile);
      }
    }

    await board.addAll(tiles);

    await add(
      FlameMultiBlocProvider(
        providers: [
          FlameBlocProvider<ConfigCubit, ConfigState>.value(
            value: configCubit,
          ),
          FlameBlocProvider<LibraryCubit, LibraryState>.value(
            value: libraryCubit,
          ),
          FlameBlocProvider<MapCubit, MapState>.value(
            value: mapCubit,
          ),
          FlameBlocProvider<MapToolCubit, MapToolState>.value(
            value: mapToolCubit,
          ),
        ],
        children: [
          board,
          FlameBlocListener<MapToolCubit, MapToolState>(
            listenWhen: (previous, current) => previous.zoom != current.zoom,
            onNewState: (state) {
              camera.zoom = state.zoom;
            },
          ),
        ],
      ),
    );

    final center = ((mapSize * tileSize.toDouble()) - size) / 2;
    camera.snapTo(center);
  }
}
