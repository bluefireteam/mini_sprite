import 'dart:convert';

import 'package:equatable/equatable.dart';

/// {@template mini_map}
/// A [MiniMap] is a class that represents a game map based on tiles.
/// {@endtemplate}
class MiniMap extends Equatable {
  /// {@macro mini_map}
  const MiniMap({
    required this.objects,
  });

  /// {@macro mini_map}
  ///
  /// Returns a new [MiniMap] parsed from the raw data.
  factory MiniMap.fromDataString(String data) {
    final dataRaw = jsonDecode(data) as List<Map<String, dynamic>>;

    final entries = dataRaw.map((dataEntry) {
      final x = dataEntry['x'] as int;
      final y = dataEntry['y'] as int;

      final data = dataEntry['data'] as Map<String, dynamic>;

      return MapEntry(MapPosition(x, y), data);
    });

    return MiniMap(objects: Map.fromEntries(entries));
  }

  /// The objects on the map.
  final Map<MapPosition, Map<String, dynamic>> objects;

  @override
  List<Object?> get props => [objects];
}

/// {@macro map_position}
/// A [MapPosition] is a class that represents a position in a game map.
/// {@endtemplate}
class MapPosition extends Equatable {
  /// {@macro map_position}
  const MapPosition(this.x, this.y);

  /// The x position.
  final int x;

  /// The y position.
  final int y;

  @override
  List<Object> get props => [x, y];
}
