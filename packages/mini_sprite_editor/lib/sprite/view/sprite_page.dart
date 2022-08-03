import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_sprite_editor/l10n/l10n.dart';
import 'package:mini_sprite_editor/sprite/cubit/tools_cubit.dart';
import 'package:mini_sprite_editor/sprite/sprite.dart';

class SpritePage extends StatelessWidget {
  const SpritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SpriteCubit>(
          create: (context) => SpriteCubit(),
        ),
        BlocProvider<ToolsCubit>(
          create: (context) => ToolsCubit(),
        ),
      ],
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

    final pixels = spriteState.pixels;
    final cursorPosition = spriteState.cursorPosition;

    final tool = toolsState.tool;
    final gridActive = toolsState.gridActive;
    final pixelSize = toolsState.pixelSize;

    final spriteHeight = pixelSize * pixels.length;
    final spriteWidth = pixelSize * pixels[0].length;

    return PageShortcuts(
      child: Scaffold(
        body: Stack(
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
                              );
                        },
                        child: GestureDetector(
                          onPanStart: (event) {
                            context.read<SpriteCubit>().cursorDown(
                                  event.localPosition,
                                  pixelSize.toDouble(),
                                  tool,
                                );
                          },
                          onPanEnd: (event) {
                            context.read<SpriteCubit>().cursorUp(tool);
                          },
                          onPanUpdate: (event) {
                            context.read<SpriteCubit>().cursorHover(
                                  event.localPosition,
                                  pixelSize.toDouble(),
                                  tool,
                                );
                          },
                          child: Container(
                            color: Theme.of(context)
                                .scaffoldBackgroundColor
                                .darken(0.1),
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
                                          selected: pixels[y][x],
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
            Positioned(
              top: 8,
              right: 32,
              left: 32,
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
                  ],
                ),
              ),
            ),
            Positioned(
              top: 64,
              right: 32,
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
          ],
        ),
      ),
    );
  }
}
