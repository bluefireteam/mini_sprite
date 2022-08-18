import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_sprite_editor/config/config.dart';
import 'package:mini_sprite_editor/l10n/l10n.dart';
import 'package:mini_sprite_editor/library/library.dart';
import 'package:mini_sprite_editor/map/map.dart';
import 'package:mini_sprite_editor/sprite/view/view.dart';

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
    final gridActive = mapToolState.gridActive;

    final l10n = context.l10n;

    return MapPageShortcuts(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Card(
              child: Row(
                children: [
                  IconButton(
                    key: const Key('resize_map_key'),
                    onPressed: () async {
                      final cubit = context.read<MapCubit>();
                      final value = await MapSizeDialog.show(context);
                      if (value != null) {
                        cubit.setSize(
                          value.dx.toInt(),
                          value.dy.toInt(),
                        );
                      }
                    },
                    tooltip: l10n.mapSizeTitle,
                    icon: const Icon(Icons.iso_sharp),
                  ),
                  IconButton(
                    key: const Key('clear_map_key'),
                    onPressed: () async {
                      final cubit = context.read<MapCubit>();
                      final value = await ConfirmDialog.show(context);
                      if (value ?? false) {
                        cubit.clearMap();
                      }
                    },
                    tooltip: l10n.clearMap,
                    icon: const Icon(Icons.delete),
                  ),
                  IconButton(
                    key: const Key('toogle_grid_key'),
                    onPressed: () async {
                      context.read<MapToolCubit>().toogleGrid();
                    },
                    tooltip: l10n.toogleGrid,
                    icon: Icon(
                      gridActive ? Icons.grid_on : Icons.grid_off,
                    ),
                  ),
                  IconButton(
                    key: const Key('copy_to_clipboard_key'),
                    onPressed: () {
                      context.read<MapCubit>().copyToClipboard();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.copiedWithSuccess)),
                      );
                    },
                    tooltip: l10n.copyToClipboard,
                    icon: const Icon(Icons.download),
                  ),
                  IconButton(
                    key: const Key('import_from_clipboard_key'),
                    onPressed: () {
                      context.read<MapCubit>().importFromClipboard();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.importSuccess)),
                      );
                    },
                    tooltip: l10n.importFromClipBoard,
                    icon: const Icon(Icons.import_export),
                  ),
                  IconButton(
                    key: const Key('config_key'),
                    onPressed: () {
                      ConfigDialog.show(context);
                    },
                    tooltip: l10n.configurations,
                    icon: const Icon(Icons.settings),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Row(
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
                                  primaryColor: Theme.of(context)
                                          .buttonTheme
                                          .colorScheme
                                          ?.primary ??
                                      Colors.blue,
                                );
                              },
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            SizedBox(
                              width: 122,
                              child: Card(
                                child: Center(
                                  child: Wrap(
                                    children: [
                                      IconButton(
                                        key: const Key('map_cursor_key'),
                                        onPressed: tool == MapTool.none
                                            ? null
                                            : () {
                                                context
                                                    .read<MapToolCubit>()
                                                    .selectTool(MapTool.none);
                                              },
                                        tooltip: l10n.cursor,
                                        icon: const Icon(Icons.mouse),
                                      ),
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
                                          context
                                              .read<MapToolCubit>()
                                              .increaseZoom();
                                        },
                                        tooltip: l10n.zoomIn,
                                        icon: const Icon(Icons.zoom_in),
                                      ),
                                      IconButton(
                                        key: const Key('map_zoom_out_key'),
                                        onPressed: () {
                                          context
                                              .read<MapToolCubit>()
                                              .decreaseZoom();
                                        },
                                        tooltip: l10n.zoomOut,
                                        icon: const Icon(Icons.zoom_out),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Expanded(
                              child: LibraryPanel(readOnly: true),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Positioned(
                    top: 8,
                    left: 8,
                    child: ObjectPanel(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
