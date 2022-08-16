import 'dart:async';

import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mini_sprite/mini_sprite.dart';
import 'package:mini_sprite_editor/config/config.dart';
import 'package:mini_sprite_editor/library/cubit/library_cubit.dart';
import 'package:mini_sprite_editor/map/map.dart';

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

  late final BackgroundComponent board;
  late Size _lastMapSize;

  @override
  void onPanUpdate(DragUpdateInfo info) {
    camera.snapTo(camera.position - info.delta.game);
  }

  @override
  Future<void> onLoad() async {
    board = BackgroundComponent();

    createTiles();

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
              center();
            },
          ),
          FlameBlocListener<MapCubit, MapState>(
            listenWhen: (previous, current) =>
                previous.mapSize != current.mapSize,
            onNewState: (state) {
              descendants()
                  .whereType<TileComponent>()
                  .forEach((e) => e.removeFromParent());
              createTiles();
              center();
            },
          ),
        ],
      ),
    );
    center();
  }

  void createTiles() {
    final mapSize = _lastMapSize = mapCubit.state.mapSize;
    final tileSize = configCubit.state.mapGridSize;

    final tiles = <TileComponent>[];
    for (var y = 0; y < mapSize.width; y++) {
      for (var x = 0; x < mapSize.height; x++) {
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

    board.addAll(tiles);
  }

  void center() {
    final mapSize = mapCubit.state.mapSize;
    final tileSize = configCubit.state.mapGridSize;

    final center = ((mapSize.toVector2() * tileSize.toDouble()) - size) / 2;
    camera.snapTo(center);
  }

  @override
  Color backgroundColor() => Colors.transparent;
}
