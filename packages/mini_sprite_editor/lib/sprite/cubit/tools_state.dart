part of 'tools_cubit.dart';

class ToolsState extends Equatable {
  const ToolsState({
    required this.pixelSize,
    required this.tool,
    required this.gridActive,
    required this.currentColor,
  });

  const ToolsState.initial()
      : this(
          pixelSize: 25,
          tool: SpriteTool.brush,
          gridActive: true,
          currentColor: 0,
        );

  final int pixelSize;
  final SpriteTool tool;
  final bool gridActive;
  final int currentColor;

  ToolsState copyWith({
    int? pixelSize,
    SpriteTool? tool,
    bool? gridActive,
    int? currentColor,
  }) {
    return ToolsState(
      pixelSize: pixelSize ?? this.pixelSize,
      tool: tool ?? this.tool,
      gridActive: gridActive ?? this.gridActive,
      currentColor: currentColor ?? this.currentColor,
    );
  }

  @override
  List<Object?> get props => [
        pixelSize,
        tool,
        gridActive,
        currentColor,
      ];
}
