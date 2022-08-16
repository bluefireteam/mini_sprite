import 'package:flame/widgets.dart';
import 'package:flame_mini_sprite/flame_mini_sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_sprite/mini_sprite.dart';
import 'package:mini_sprite_editor/config/config.dart';
import 'package:mini_sprite_editor/l10n/l10n.dart';
import 'package:mini_sprite_editor/library/library.dart';
import 'package:mini_sprite_editor/sprite/sprite.dart';

class LibraryPanel extends StatefulWidget {
  const LibraryPanel({super.key, this.readOnly = false});

  final bool readOnly;

  @override
  State<LibraryPanel> createState() => _LibraryPanelState();
}

class _LibraryPanelState extends State<LibraryPanel> {
  List<List<bool>>? _valueToSet;

  Future<void> _onSpriteChange(List<List<bool>> sprite) async {
    final libraryCubit = context.read<LibraryCubit>();
    if (_valueToSet == null) {
      _valueToSet = sprite;
      await Future<void>.delayed(const Duration(milliseconds: 500));
      libraryCubit.updateSelected(_valueToSet!);
      _valueToSet = null;
    } else {
      _valueToSet = sprite;
    }
  }

  @override
  Widget build(BuildContext context) {
    final libraryCubit = context.watch<LibraryCubit>();
    final library = libraryCubit.state;
    final l10n = context.l10n;

    if (library.sprites.isEmpty) {
      return Card(
        child: IconButton(
          key: const Key('start_collection_key'),
          tooltip: l10n.startCollection,
          onPressed: () {
            libraryCubit.startCollection(
              context.read<SpriteCubit>().state.pixels,
            );
          },
          icon: const Icon(Icons.library_add),
        ),
      );
    }

    return BlocListener<SpriteCubit, SpriteState>(
      listenWhen: (previous, current) => previous.pixels != current.pixels,
      listener: (context, state) {
        _onSpriteChange(state.pixels);
      },
      child: Card(
        child: Column(
          children: [
            if (!widget.readOnly)
              Row(
                children: [
                  IconButton(
                    key: const Key('add_sprite_key'),
                    tooltip: l10n.addSprite,
                    onPressed: () {
                      final spriteState = context.read<SpriteCubit>().state;
                      libraryCubit.addSprite(
                        spriteState.pixels[0].length,
                        spriteState.pixels.length,
                      );
                    },
                    icon: const Icon(Icons.add),
                  ),
                  IconButton(
                    key: const Key('remove_sprite_key'),
                    tooltip: l10n.renameSprite,
                    onPressed: () async {
                      final cubit = context.read<LibraryCubit>();
                      final value = await ConfirmDialog.show(context);
                      if (value ?? false) {
                        cubit.removeSprite(cubit.state.selected);
                      }
                    },
                    icon: const Icon(Icons.remove),
                  ),
                  IconButton(
                    key: const Key('copy_library_to_clipboard_key'),
                    onPressed: () {
                      context.read<LibraryCubit>().copyToClipboard();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.copiedWithSuccess)),
                      );
                    },
                    tooltip: l10n.copyToClipboard,
                    icon: const Icon(Icons.download),
                  ),
                  IconButton(
                    key: const Key('import_library_from_clipboard_key'),
                    onPressed: () {
                      context.read<LibraryCubit>().importFromClipboard();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.importSuccess)),
                      );
                    },
                    tooltip: l10n.importFromClipBoard,
                    icon: const Icon(Icons.import_export),
                  ),
                ],
              ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (final entry in library.sprites.entries)
                      _LibraryEntry(
                        spriteKey: entry.key,
                        sprite: entry.value,
                        selected: entry.key == library.selected,
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

class _LibraryEntry extends StatefulWidget {
  const _LibraryEntry({
    required this.spriteKey,
    required this.sprite,
    required this.selected,
  });

  final String spriteKey;
  final MiniSprite sprite;
  final bool selected;

  @override
  _LibraryEntryState createState() => _LibraryEntryState();
}

class _LibraryEntryState extends State<_LibraryEntry> {
  late Future<Sprite> _future;

  @override
  void initState() {
    super.initState();

    _updateSprite();
  }

  @override
  void didUpdateWidget(_LibraryEntry oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.sprite != widget.sprite) {
      _updateSprite();
    }
  }

  void _updateSprite() {
    final configState = context.read<ConfigCubit>().state;
    _future = widget.sprite.toSprite(
      pixelSize: 2,
      color: configState.filledColor,
      blankColor: configState.unfilledColor,
      backgroundColor: configState.backgroundColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<LibraryCubit>().select(widget.spriteKey);
      },
      onDoubleTap: () async {
        final cubit = context.read<LibraryCubit>();
        final newName = await RenameDialog.show(context, widget.spriteKey);
        if (newName != null) {
          cubit.rename(
            widget.spriteKey,
            newName,
          );
        }
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 2,
                  color: widget.selected
                      ? Theme.of(context).buttonTheme.colorScheme!.primary
                      : Colors.transparent,
                ),
              ),
            ),
            child: FutureBuilder<Sprite>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SpriteWidget(sprite: snapshot.data!);
                }

                return const SizedBox();
              },
            ),
          ),
          Text(widget.spriteKey),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
