import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:mini_sprite/mini_sprite.dart';

/// {@template mini_library}
/// A class that holds a library of [MiniSprite]s.
/// {@endtemplate}
class MiniLibrary extends Equatable {
  /// {@macro mini_library}
  const MiniLibrary(this.sprites);

  /// {@macro mini_library}
  MiniLibrary.empty() : sprites = {};

  /// {@macro mini_library}
  ///
  /// Returns a [MiniLibrary] from the serialized data.
  factory MiniLibrary.fromDataString(String value) {
    const lineSplitter = LineSplitter();
    final lines = lineSplitter.convert(value);

    final sprites = lines.fold<Map<String, MiniSprite>>({}, (map, line) {
      final blocks = line.split('|');
      final name = blocks.first;
      final data = blocks.last;

      return {
        ...map,
        name: MiniSprite.fromDataString(data),
      };
    });

    return MiniLibrary(sprites);
  }

  /// Returns this as a data string.
  String toDataString() {
    return sprites.entries.map((entry) {
      return '${entry.key}|${entry.value.toDataString()}';
    }).join('\n');
  }

  /// The library of sprites.
  final Map<String, MiniSprite> sprites;

  @override
  List<Object?> get props => [sprites];
}
