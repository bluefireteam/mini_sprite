part of 'tools_cubit.dart';

class ToolsState extends Equatable {
  const ToolsState({
    required this.pixelSize,
    required this.tool,
    required this.gridActive,
  });

  const ToolsState.initial()
      : this(
          pixelSize: 25,
          tool: SpriteTool.brush,
          gridActive: true,
        );

  final int pixelSize;
  final SpriteTool tool;
  final bool gridActive;

  ToolsState copyWith({
    int? pixelSize,
    SpriteTool? tool,
    bool? gridActive,
  }) {
    return ToolsState(
      pixelSize: pixelSize ?? this.pixelSize,
      tool: tool ?? this.tool,
      gridActive: gridActive ?? this.gridActive,
    );
  }

  @override
  List<Object?> get props => [
        pixelSize,
        tool,
        gridActive,
      ];
}
