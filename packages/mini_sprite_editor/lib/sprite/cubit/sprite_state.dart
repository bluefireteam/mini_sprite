part of 'sprite_cubit.dart';

const _defaultSpriteSize = 16;

class SpriteState extends Equatable {
  const SpriteState({
    required this.pixels,
    required this.cursorPosition,
  });

  SpriteState.initial()
      : this(
          pixels: List.filled(
            _defaultSpriteSize,
            List.filled(_defaultSpriteSize, false),
          ),
          cursorPosition: const Offset(-1, -1),
        );

  final List<List<bool>> pixels;
  final Offset cursorPosition;

  SpriteState copyWith({
    List<List<bool>>? pixels,
    Offset? cursorPosition,
  }) {
    return SpriteState(
      pixels: pixels ?? this.pixels,
      cursorPosition: cursorPosition ?? this.cursorPosition,
    );
  }

  @override
  List<Object?> get props => [
        pixels,
        cursorPosition,
      ];
}
