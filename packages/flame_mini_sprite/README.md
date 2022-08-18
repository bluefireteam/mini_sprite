# flame_mini_sprite

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

Library to act as a bridge betwenn Mini Sprite and Flame Engine

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis

# How to use it

Add flame mini sprite to the project pubspec:

```
dart pub add flame_mini_sprite
```

## Helpers

### MiniSprite.toSprite

Convert a `MiniSprite` instance into a Flame `Sprite` instance:

```dart
final miniSprite = MiniSprite.fromDataString('...');
final sprite = await miniSprite.toSprite(
  pixelSize: 1,
  color: Colors.white,
);
```

### MiniLibrary.toSprites

Convert a `MiniLibrary` instance into a map of Flame `Sprite` instances.


```dart
final miniLibrary = MiniLibrary.fromDataString('...');
final sprites = await miniLibrary.toSprites(
  .toSprites(
    pixelSize: 1,
    color: Colors.white,
  );
```
