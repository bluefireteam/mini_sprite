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
flame_mini_sprite: <last_version>
```

## Helpers

### MiniSprite.toSprite

Transform the stored data in a `MiniSprite` instance to a usable Flame `Sprite` instance:

```dart
final miniSprite = MiniSprite.fromDataString('...');
final sprite = await miniSprite.toSprite(
  pixelSize: 1,
  color: Colors.white,
);
```

### MiniLibrary.toSprites

Transform the data stored in the `MiniLibrary` instance into a map of Flame `Sprite`s.


```dart
final miniLibrary = MiniLibrary.fromDataString('...');
final sprites = await miniLibrary.toSprites(
  .toSprites(
    pixelSize: 1,
    color: Colors.white,
  );
```
