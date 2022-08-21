import 'dart:convert';
import 'dart:math';

import 'package:equatable/equatable.dart';

/// {@template mini_map}
/// A [MiniMap] is a class that represents a game map based on tiles.
/// {@endtemplate}
class MiniMap extends Equatable {
  /// {@macro mini_map}
  const MiniMap({
    required this.objects,
    int? width,
    int? height,
  })  : _width = width,
        _height = height;

  /// {@macro mini_map}
  ///
  /// Returns a new [MiniMap] parsed from the raw data.
  factory MiniMap.fromDataString(String data) {
    final dynamic dataRaw = jsonDecode(data);

    late Map<String, dynamic> objectsRaw;
    late List<dynamic> entriesRaw;

    // Legacy support for old maps.
    if (dataRaw is List<dynamic>) {
      objectsRaw = const <String, dynamic>{};
      entriesRaw = dataRaw;
    } else {
      objectsRaw = dataRaw as Map<String, dynamic>;
      entriesRaw = objectsRaw['objects'] as List<dynamic>;
    }

    final entries = entriesRaw.map((dynamic dataEntry) {
      final dataMap = dataEntry as Map<String, dynamic>;
      final x = dataMap['x'] as int;
      final y = dataMap['y'] as int;

      final data = dataMap['data'] as Map<String, dynamic>;

      return MapEntry(MapPosition(x, y), data);
    });

    return MiniMap(
      width: objectsRaw['width'] as int?,
      height: objectsRaw['height'] as int?,
      objects: Map.fromEntries(entries),
    );
  }

  final int? _width;
  final int? _height;

  /// The objects on the map.
  final Map<MapPosition, Map<String, dynamic>> objects;

  /// The width of the map. if no value is specified, the width is calculated
  /// from the objects bigger position.
  int get width =>
      _width ??
      objects.keys.fold<int>(
            0,
            (previousValue, element) => max(
              previousValue,
              element.x,
            ),
          ) +
          1;

  /// The height of the map. if no value is specified, the height is calculated
  /// from the objects bigger position.
  int get height =>
      _height ??
      objects.keys.fold<int>(
            0,
            (previousValue, element) => max(
              previousValue,
              element.y,
            ),
          ) +
          1;

  /// Returns this map serialized into a raw string.
  String toDataString() {
    final data = objects.entries.map((entry) {
      final x = entry.key.x;
      final y = entry.key.y;
      final data = entry.value;
      return {
        'x': x,
        'y': y,
        'data': data,
      };
    }).toList();

    return jsonEncode({
      if (_width != null) 'width': _width,
      if (_height != null) 'height': _height,
      'objects': data,
    });
  }

  @override
  List<Object?> get props => [objects, _width, _height];
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
