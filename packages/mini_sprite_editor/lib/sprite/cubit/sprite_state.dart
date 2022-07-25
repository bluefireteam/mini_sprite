part of 'sprite_cubit.dart';

const _defaultSpriteSize = 16;

enum SpriteTool {
  brush,
  eraser,
  bucket,
  bucketEraser,
}

class SpriteState extends Equatable {
  const SpriteState({
    required this.pixelSize,
    required this.pixels,
    required this.cursorPosition,
    required this.tool,
    required this.toolActive,
  });

  SpriteState.initial()
      : this(
          pixels: List.filled(
            _defaultSpriteSize,
            List.filled(_defaultSpriteSize, false),
          ),
          pixelSize: 25,
          cursorPosition: const Offset(-1, -1),
          tool: SpriteTool.brush,
          toolActive: false,
        );

  final int pixelSize;
  final List<List<bool>> pixels;
  final Offset cursorPosition;
  final SpriteTool tool;
  final bool toolActive;

  SpriteState copyWith({
    int? pixelSize,
    List<List<bool>>? pixels,
    Offset? cursorPosition,
    SpriteTool? tool,
    bool? toolActive,
  }) {
    return SpriteState(
      pixelSize: pixelSize ?? this.pixelSize,
      pixels: pixels ?? this.pixels,
      cursorPosition: cursorPosition ?? this.cursorPosition,
      tool: tool ?? this.tool,
      toolActive: toolActive ?? this.toolActive,
    );
  }

  @override
  List<Object?> get props => [
        pixelSize,
        pixels,
        cursorPosition,
        tool,
        toolActive,
      ];
}
