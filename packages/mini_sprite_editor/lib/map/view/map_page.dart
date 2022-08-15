import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_sprite_editor/config/config.dart';
import 'package:mini_sprite_editor/l10n/l10n.dart';
import 'package:mini_sprite_editor/library/library.dart';
import 'package:mini_sprite_editor/map/map.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MapToolCubit>(
      create: (_) => MapToolCubit(),
      child: const MapView(),
    );
  }
}

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    final mapToolCubit = context.watch<MapToolCubit>();

    final mapToolState = mapToolCubit.state;
    final tool = mapToolState.tool;

    final l10n = context.l10n;

    return Row(
      children: [
        Expanded(
          child: ClipRect(
            child: GameWidget.controlled(
              gameFactory: () {
                return MapBoardGame(
                  configCubit: context.read<ConfigCubit>(),
                  libraryCubit: context.read<LibraryCubit>(),
                  mapCubit: context.read<MapCubit>(),
                  mapToolCubit: context.read<MapToolCubit>(),
                );
              },
            ),
          ),
        ),
        Column(
          children: [
            Card(
              child: Column(
                children: [
                  IconButton(
                    key: const Key('map_brush_key'),
                    onPressed: tool == MapTool.brush
                        ? null
                        : () {
                            context
                                .read<MapToolCubit>()
                                .selectTool(MapTool.brush);
                          },
                    tooltip: l10n.brush,
                    icon: const Icon(Icons.brush),
                  ),
                  IconButton(
                    key: const Key('map_eraser_key'),
                    onPressed: tool == MapTool.eraser
                        ? null
                        : () {
                            context
                                .read<MapToolCubit>()
                                .selectTool(MapTool.eraser);
                          },
                    tooltip: l10n.eraser,
                    icon: const Icon(Icons.rectangle),
                  ),
                  IconButton(
                    key: const Key('map_zoom_in_key'),
                    onPressed: () {
                      context.read<MapToolCubit>().increaseZoom();
                    },
                    tooltip: l10n.zoomIn,
                    icon: const Icon(Icons.zoom_in),
                  ),
                  IconButton(
                    key: const Key('map_zoom_out_key'),
                    onPressed: () {
                      context.read<MapToolCubit>().decreaseZoom();
                    },
                    tooltip: l10n.zoomOut,
                    icon: const Icon(Icons.zoom_out),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: LibraryPanel(readOnly: true),
            ),
          ],
        ),
      ],
    );
  }
}
