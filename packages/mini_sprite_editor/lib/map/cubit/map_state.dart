part of 'map_cubit.dart';

class MapState extends Equatable {
  const MapState({
    required this.objects,
    required this.selectedObject,
    required this.mapSize,
  });

  const MapState.initial()
      : this(
          objects: const {},
          selectedObject: const MapPosition(-1, -1),
          mapSize: const Size(10, 10),
        );

  final Map<MapPosition, Map<String, dynamic>> objects;
  final MapPosition selectedObject;
  final Size mapSize;

  MapState copyWith({
    Map<MapPosition, Map<String, dynamic>>? objects,
    MapPosition? selectedObject,
    Size? mapSize,
  }) {
    return MapState(
      objects: objects ?? this.objects,
      selectedObject: selectedObject ?? this.selectedObject,
      mapSize: mapSize ?? this.mapSize,
    );
  }

  @override
  List<Object> get props => [objects, selectedObject, mapSize];
}
