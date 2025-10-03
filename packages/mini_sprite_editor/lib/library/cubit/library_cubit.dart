import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:mini_sprite/mini_sprite.dart';

part 'library_state.dart';

class LibraryCubit extends Cubit<LibraryState> {
  LibraryCubit({
    Future<void> Function(ClipboardData)? setClipboardData,
    Future<ClipboardData?> Function(String)? getClipboardData,
  }) : _setClipboardData = setClipboardData ?? Clipboard.setData,
       _getClipboardData = getClipboardData ?? Clipboard.getData,
       super(const LibraryState.initial());

  final Future<void> Function(ClipboardData) _setClipboardData;
  final Future<ClipboardData?> Function(String) _getClipboardData;

  void select(String key) {
    emit(state.copyWith(selected: key));
  }

  void startCollection(List<List<int>> firstSprite) {
    emit(
      state.copyWith(
        sprites: {'sprite_1': MiniSprite(firstSprite)},
        selected: 'sprite_1',
      ),
    );
  }

  void updateSelected(List<List<int>> sprite) {
    emit(
      state.copyWith(
        sprites: {...state.sprites, state.selected: MiniSprite(sprite)},
      ),
    );
  }

  void rename(String key, String newKey) {
    final newSprites = {...state.sprites}..remove(key);
    emit(
      state.copyWith(
        sprites: {...newSprites, newKey: state.sprites[key]!},
        selected: state.selected == key ? newKey : state.selected,
      ),
    );
  }

  String _newSpriteKey() {
    var idx = state.sprites.length + 1;
    var spriteKey = 'sprite_$idx';

    while (state.sprites.containsKey(spriteKey)) {
      idx++;
      spriteKey = 'sprite_$idx';
    }

    return spriteKey;
  }

  void addSprite(int width, int height) {
    emit(
      state.copyWith(
        sprites: {
          ...state.sprites,
          _newSpriteKey(): MiniSprite(
            List.generate(height, (_) => List.generate(width, (_) => -1)),
          ),
        },
      ),
    );
  }

  void removeSprite(String key) {
    final newSprites = {...state.sprites}..remove(key);
    emit(
      state.copyWith(
        sprites: newSprites,
        selected:
            state.selected == key ? state.sprites.keys.last : state.selected,
      ),
    );
  }

  Future<void> importFromClipboard() async {
    final data = await _getClipboardData('text/plain');
    final text = data?.text;
    if (text != null) {
      final library = MiniLibrary.fromDataString(text);
      emit(
        state.copyWith(
          sprites: library.sprites,
          selected: library.sprites.isNotEmpty ? library.sprites.keys.last : '',
        ),
      );
    }
  }

  void copyToClipboard() {
    final library = MiniLibrary(state.sprites);
    final data = library.toDataString();
    unawaited(_setClipboardData(ClipboardData(text: data)));
  }
}
