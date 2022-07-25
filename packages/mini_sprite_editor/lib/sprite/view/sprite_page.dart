import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_sprite_editor/l10n/l10n.dart';
import 'package:mini_sprite_editor/sprite/sprite.dart';

class SpritePage extends StatelessWidget {
  const SpritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SpriteCubit(),
      child: const SpriteView(),
    );
  }
}

class SpriteView extends StatelessWidget {
  const SpriteView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<SpriteCubit>().state;
    final pixels = state.pixels;
    final cursorPosition = state.cursorPosition;
    final tool = state.tool;

    final pixelSize = state.pixelSize;

    final spriteHeight = pixelSize * pixels.length;
    final spriteWidth = pixelSize * pixels[0].length;

    return Scaffold(
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
                        context
                            .read<SpriteCubit>()
                            .cursorHover(event.localPosition);
                      },
                      child: GestureDetector(
                        onPanStart: (event) {
                          context
                              .read<SpriteCubit>()
                              .cursorDown(event.localPosition);
                        },
                        onPanEnd: (event) {
                          context.read<SpriteCubit>().cursorUp();
                        },
                        onPanUpdate: (event) {
                          context
                              .read<SpriteCubit>()
                              .cursorHover(event.localPosition);
                        },
                        child: SizedBox(
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
            top: 32,
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
                                .read<SpriteCubit>()
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
                                .read<SpriteCubit>()
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
                                .read<SpriteCubit>()
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
                                .read<SpriteCubit>()
                                .selectTool(SpriteTool.bucketEraser);
                          },
                    tooltip: l10n.bucketEraser,
                    icon: const Icon(Icons.egg_outlined),
                  ),
                  IconButton(
                    key: const Key('zoom_in_key'),
                    onPressed: () {
                      context.read<SpriteCubit>().zoomIn();
                    },
                    tooltip: l10n.zoomIn,
                    icon: const Icon(Icons.zoom_in),
                  ),
                  IconButton(
                    key: const Key('zoom_out_key'),
                    onPressed: () {
                      context.read<SpriteCubit>().zoomOut();
                    },
                    tooltip: l10n.zoomOut,
                    icon: const Icon(Icons.zoom_out),
                  ),
                  const Divider(),
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
        ],
      ),
    );
  }
}
