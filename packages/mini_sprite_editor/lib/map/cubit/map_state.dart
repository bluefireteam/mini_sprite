part of 'map_cubit.dart';

class MapState extends Equatable {
  const MapState({
    required this.objects,
    required this.selectedObject,
  });

  const MapState.initial()
      : this(
          objects: const {},
          selectedObject: const MapPosition(-1, -1),
        );

  final Map<MapPosition, Map<String, dynamic>> objects;
  final MapPosition selectedObject;

  MapState copyWith({
    Map<MapPosition, Map<String, dynamic>>? objects,
    MapPosition? selectedObject,
  }) {
    return MapState(
      objects: objects ?? this.objects,
      selectedObject: selectedObject ?? this.selectedObject,
    );
  }

  @override
  List<Object> get props => [objects, selectedObject];
}
