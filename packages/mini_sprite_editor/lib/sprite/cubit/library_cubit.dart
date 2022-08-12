import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mini_sprite/mini_sprite.dart';

part 'library_state.dart';

class LibraryCubit extends Cubit<LibraryState> {
  LibraryCubit() : super(const LibraryState.initial());

  void select(String key) {
    emit(state.copyWith(selected: key));
  }

  void startCollection(List<List<bool>> firstSprite) {
    emit(
      state.copyWith(
        sprites: {
          'sprite_1': MiniSprite(firstSprite),
        },
        selected: 'sprite_1',
      ),
    );
  }

  void updateSelected(List<List<bool>> sprite) {
    emit(
      state.copyWith(
        sprites: {
          ...state.sprites,
          state.selected: MiniSprite(sprite),
        },
      ),
    );
  }

  void rename(String key, String newKey) {
    final newSprites = {...state.sprites}..remove(key);
    emit(
      state.copyWith(
        sprites: {
          ...newSprites,
          newKey: state.sprites[key]!,
        },
        selected: state.selected == key ? newKey : state.selected,
      ),
    );
  }

  void addSprite(int width, int height) {
    emit(
      state.copyWith(
        sprites: {
          ...state.sprites,
          'sprite_${state.sprites.length + 1}': MiniSprite(
            List.generate(
              height,
              (_) => List.generate(
                width,
                (_) => false,
              ),
            ),
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
}
