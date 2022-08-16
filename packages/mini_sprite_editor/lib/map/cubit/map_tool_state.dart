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
    required this.gridActive,
  });

  const MapToolState.initial()
      : this(
          tool: MapTool.brush,
          zoom: 1,
          gridActive: true,
        );

  final MapTool tool;
  final double zoom;
  final bool gridActive;

  MapToolState copyWith({
    MapTool? tool,
    double? zoom,
    bool? gridActive,
  }) {
    return MapToolState(
      tool: tool ?? this.tool,
      zoom: zoom ?? this.zoom,
      gridActive: gridActive ?? this.gridActive,
    );
  }

  @override
  List<Object> get props => [tool, zoom, gridActive];
}
