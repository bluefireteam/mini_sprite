import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_sprite_editor/config/config.dart';
import 'package:mini_sprite_editor/l10n/l10n.dart';
import 'package:mini_sprite_editor/library/library.dart';
import 'package:mini_sprite_editor/sprite/cubit/tools_cubit.dart';
import 'package:mini_sprite_editor/sprite/sprite.dart';

class SpritePage extends StatelessWidget {
  const SpritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ToolsCubit>(
      create: (context) => ToolsCubit(),
      child: const SpriteView(),
    );
  }
}

class SpriteView extends StatelessWidget {
  const SpriteView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spriteState = context.watch<SpriteCubit>().state;
    final toolsState = context.watch<ToolsCubit>().state;

    final configCubit = context.watch<ConfigCubit>();
    final palette = configCubit.palette();

    final configState = configCubit.state;
    final libraryState = context.watch<LibraryCubit>().state;

    final pixels = spriteState.pixels;
    final cursorPosition = spriteState.cursorPosition;

    final tool = toolsState.tool;
    final gridActive = toolsState.gridActive;
    final pixelSize = toolsState.pixelSize;

    final spriteHeight = pixelSize * pixels.length;
    final spriteWidth = pixelSize * pixels[0].length;

    return PageShortcuts(
      child: Stack(
        children: [
          Positioned.fill(
            child: SizedBox.expand(
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: MouseRegion(
                      onHover: (event) {
                        context.read<SpriteCubit>().cursorHover(
                              event.localPosition,
                              pixelSize.toDouble(),
                              tool,
                              toolsState.currentColor,
                            );
                      },
                      child: GestureDetector(
                        onPanStart: (event) {
                          context.read<SpriteCubit>().cursorDown(
                                event.localPosition,
                                pixelSize.toDouble(),
                                tool,
                                toolsState.currentColor,
                              );
                        },
                        onPanEnd: (event) {
                          context.read<SpriteCubit>().cursorUp(
                                tool,
                                toolsState.currentColor,
                              );
                        },
                        onPanUpdate: (event) {
                          context.read<SpriteCubit>().cursorHover(
                                event.localPosition,
                                pixelSize.toDouble(),
                                tool,
                                toolsState.currentColor,
                              );
                        },
                        child: BlocListener<LibraryCubit, LibraryState>(
                          listenWhen: (previous, current) =>
                              previous.selected != current.selected,
                          listener: (context, state) {
                            context.read<SpriteCubit>().setSprite(
                                  state.sprites[state.selected]!.pixels,
                                );
                          },
                          child: Container(
                            color: configState.backgroundColor,
                            key: const Key('board_key'),
                            width: spriteWidth.toDouble(),
                            height: spriteHeight.toDouble(),
                            child: Column(
                              children: [
                                for (var y = 0; y < pixels.length; y++)
                                  Row(
                                    children: [
                                      for (var x = 0; x < pixels[y].length; x++)
                                        PixelCell(
                                          pixelSize: pixelSize,
                                          color: pixels[y][x] >= 0
                                              ? palette[pixels[y][x]]
                                              : configState.backgroundColor,
                                          hasBorder: gridActive,
                                          hovered: cursorPosition ==
                                              Offset(
                                                x.toDouble(),
                                                y.toDouble(),
                                              ),
                                        ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            left: 8,
            child: Card(
              child: Row(
                children: [
                  IconButton(
                    key: const Key('resize_sprite_key'),
                    onPressed: () async {
                      final cubit = context.read<SpriteCubit>();
                      final value = await SpriteSizeDialog.show(context);
                      if (value != null) {
                        cubit.setSize(
                          value.dx.toInt(),
                          value.dy.toInt(),
                        );
                      }
                    },
                    tooltip: l10n.spriteSizeTitle,
                    icon: const Icon(Icons.iso_sharp),
                  ),
                  IconButton(
                    key: const Key('clear_sprite_key'),
                    onPressed: () async {
                      final cubit = context.read<SpriteCubit>();
                      final value = await ConfirmDialog.show(context);
                      if (value ?? false) {
                        cubit.clearSprite();
                      }
                    },
                    tooltip: l10n.clearSprite,
                    icon: const Icon(Icons.delete),
                  ),
                  IconButton(
                    key: const Key('toogle_grid_key'),
                    onPressed: () async {
                      context.read<ToolsCubit>().toogleGrid();
                    },
                    tooltip: l10n.toogleGrid,
                    icon: Icon(
                      gridActive ? Icons.grid_on : Icons.grid_off,
                    ),
                  ),
                  IconButton(
                    key: const Key('copy_to_clipboard_key'),
                    onPressed: () {
                      context.read<SpriteCubit>().copyToClipboard();
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
                      context.read<SpriteCubit>().importFromClipboard();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.importSuccess)),
                      );
                    },
                    tooltip: l10n.importFromClipBoard,
                    icon: const Icon(Icons.import_export),
                  ),
                  IconButton(
                    key: const Key('export_to_image'),
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      await context.read<SpriteCubit>().exportToImage(
                            pixelSize: pixelSize,
                            palette: palette,
                            backgroundColor: configState.backgroundColor,
                          );
                      messenger.showSnackBar(
                        SnackBar(content: Text(l10n.spriteExported)),
                      );
                    },
                    tooltip: l10n.exportToImage,
                    icon: const Icon(Icons.image),
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
          ),
          Positioned(
            top: 64,
            right: 64,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        context.read<ToolsCubit>().setColor(0);
                      },
                      child: Container(
                        color: configState.filledColor.withOpacity(
                            toolsState.currentColor == 0 ? .2 : 1,
                        ),
                        width: 16,
                        height: 16,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        context.read<ToolsCubit>().setColor(1);
                      },
                      child: Container(
                        color: configState.unfilledColor.withOpacity(
                            toolsState.currentColor == 1 ? .2 : 1,
                        ),
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 64,
            right: 8,
            child: Card(
              child: Column(
                children: [
                  IconButton(
                    key: const Key('brush_key'),
                    onPressed: tool == SpriteTool.brush
                        ? null
                        : () {
                            context
                                .read<ToolsCubit>()
                                .selectTool(SpriteTool.brush);
                          },
                    tooltip: l10n.brush,
                    icon: const Icon(Icons.brush),
                  ),
                  IconButton(
                    key: const Key('eraser_key'),
                    onPressed: tool == SpriteTool.eraser
                        ? null
                        : () {
                            context
                                .read<ToolsCubit>()
                                .selectTool(SpriteTool.eraser);
                          },
                    tooltip: l10n.eraser,
                    icon: const Icon(Icons.rectangle),
                  ),
                  IconButton(
                    key: const Key('bucket_key'),
                    onPressed: tool == SpriteTool.bucket
                        ? null
                        : () {
                            context
                                .read<ToolsCubit>()
                                .selectTool(SpriteTool.bucket);
                          },
                    tooltip: l10n.bucket,
                    icon: const Icon(Icons.egg_sharp),
                  ),
                  IconButton(
                    key: const Key('bucket_eraser_key'),
                    onPressed: tool == SpriteTool.bucketEraser
                        ? null
                        : () {
                            context
                                .read<ToolsCubit>()
                                .selectTool(SpriteTool.bucketEraser);
                          },
                    tooltip: l10n.bucketEraser,
                    icon: const Icon(Icons.egg_outlined),
                  ),
                  IconButton(
                    key: const Key('zoom_in_key'),
                    onPressed: () {
                      context.read<ToolsCubit>().zoomIn();
                    },
                    tooltip: l10n.zoomIn,
                    icon: const Icon(Icons.zoom_in),
                  ),
                  IconButton(
                    key: const Key('zoom_out_key'),
                    onPressed: () {
                      context.read<ToolsCubit>().zoomOut();
                    },
                    tooltip: l10n.zoomOut,
                    icon: const Icon(Icons.zoom_out),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 64,
            left: 8,
            bottom: libraryState.sprites.isEmpty ? null : 16,
            child: const LibraryPanel(),
          ),
        ],
      ),
    );
  }
}
