# mini_sprite

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

A simplified sprite format meant for 1bit styled games.

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis

# How to use

Add mini sprite to your project pubspec:

```
mini_sprite: <last_version>
```

## MiniSprite

`MiniSprite` holds the information for a single sprite, it can be generated in runtime or be loaded
from its raw format:

### Generating at runtime

```dart
List<List<bool>> _generatePixels() {
  // ...
}

final miniSprite = MiniSprite(_generatePixels());
print(miniSprite.pixels);
```

### Reading from its raw format

```dart
const spriteData = '...';
final miniSprite = MiniSprite.fromDataString(spriteData);
print(miniSprite.pixels);
```

### MiniLibrary

`MiniLibrary` is a class that represents a collection of `MiniSprite`s. It is a helper class that
makes it easy to store and load a collection of sprites.

Just like MiniSprite it can be generated at runtime or loaded from its raw format.

### Generating at runtime

```dart
List<List<bool>> _generatePixels() {
  // ...
}

final miniLibrary = MiniLibrary({
  'player': MiniSprite(_generatePixels()),
  'tile': MiniSprite(_generatePixels()),
});
print(miniLibrary.sprites);
```

### Reading from its raw format

```dart
const libraryData = '...';
final miniLibrary = MiniLibrary.fromDataString(libraryData);
print(miniLibrary.sprite);
```

### MiniMap

`MiniMap` is a class that holds information for a map (or stage) of a game. Its coordinate system
is grid based and it contains a collections of objects.

Objects are stored in a `Map` where the key is `MapPosition` (a simple object that holds the
`x` and `y` with the index of the object on the map grid) and the value is a map of the
properties of the object.

With the exception of the `sprite` key on the properties, which holds the sprite name from a
`MiniLibrary`, all other properties are custom value set in the editor. 

Just like the other classes it can be generated at runtime or loaded from its raw format.

### Generating at runtime

```dart
final miniMap = MiniMap({
  MapPosition(2, 2): {
    'sprite': 'player',
  },
  MapPosition(2, 3): {
    'sprite': 'ground',
  },
  MapPosition(4, 3): {
    'sprite': 'spikes',
    'damage': 'fatal',
  },
});
```

### Reading from its raw format

```dart
const mapData = '...';
final miniMap = MiniMap.fromDataString(mapData);
```
