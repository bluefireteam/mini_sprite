part of 'map_tool_cubit.dart';

enum MapTool {
  none,
  brush,
  eraser,
}

class MapToolState extends Equatable {
  const MapToolState({
    required this.tool,
    required this.zoom,
  });

  const MapToolState.initial()
      : this(
          tool: MapTool.none,
          zoom: 1,
        );

  final MapTool tool;
  final double zoom;

  MapToolState copyWith({
    MapTool? tool,
    double? zoom,
  }) {
    return MapToolState(
      tool: tool ?? this.tool,
      zoom: zoom ?? this.zoom,
    );
  }

  @override
  List<Object> get props => [tool, zoom];
}
