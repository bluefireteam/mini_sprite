import 'package:equatable/equatable.dart';

/// {@template mini_sprite}
/// A class used to manipulate a matrix of pixels.
/// first dimension of the [pixels] array is the y coordinate,
/// second is the x coordinate.
/// {@endtemplate}
class MiniSprite extends Equatable {
  /// {@macro mini_sprite}
  const MiniSprite(this.pixels);

  /// {@macro mini_sprite}
  ///
  /// Creates an empty sprite with the given width and height.
  MiniSprite.empty(int width, int height)
      : pixels = List.generate(height, (_) => List.generate(width, (_) => -1));

  /// {@macro mini_sprite}
  ///
  /// Returns a [MiniSprite] from the serialized data.
  factory MiniSprite.fromDataString(String value) {
    final blocks = value.split(';');

    final size = blocks.removeAt(0).split(',');
    final height = int.parse(size[0]);
    final width = int.parse(size[1]);

    final flatten = blocks.map((rawBlock) {
      final blockSplit = rawBlock.split(',');

      final count = int.parse(blockSplit[0]);
      final value = int.parse(blockSplit[1]);

      return List.filled(count, value);
    }).fold<List<int>>(List<int>.empty(), (value, list) {
      return [
        ...value,
        ...list,
      ];
    });

    final pixels = List.generate(
      height,
      (_) => List.generate(
        width,
        (_) {
          return flatten.removeAt(0);
        },
      ),
    );

    return MiniSprite(pixels);
  }

  /// The matrix of pixels.
  final List<List<int>> pixels;

  /// Returns this as a data string.
  String toDataString() {
    final dimensions = '${pixels.length},${pixels[0].length}';

    var counter = 0;
    int? last;

    final blocks = <String>[];

    for (var y = 0; y < pixels.length; y++) {
      for (var x = 0; x < pixels[y].length; x++) {
        if (last == null) {
          last = pixels[y][x];
          counter = 1;
        } else {
          if (last == pixels[y][x]) {
            counter++;
          } else {
            blocks.add('$counter,$last');
            last = pixels[y][x];
            counter = 1;
          }
        }
      }
    }
    if (last != null) {
      blocks.add('$counter,$last');
    }

    return '$dimensions;${blocks.join(';')}';
  }

  @override
  List<Object> get props => [pixels];
}
