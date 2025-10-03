part of 'library_cubit.dart';

class LibraryState extends Equatable {
  const LibraryState({required this.sprites, required this.selected});

  const LibraryState.initial() : this(sprites: const {}, selected: '');

  final Map<String, MiniSprite> sprites;
  final String selected;

  LibraryState copyWith({Map<String, MiniSprite>? sprites, String? selected}) {
    return LibraryState(
      sprites: sprites ?? this.sprites,
      selected: selected ?? this.selected,
    );
  }

  @override
  List<Object?> get props => [sprites, selected];
}
