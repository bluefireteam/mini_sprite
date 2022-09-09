# flutter_mini_sprite

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

Provides Widgets to render mini sprites into Flutter

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis

# How to use it

Add flutter mini sprite to the project pubspec:

```
dart pub add flutter_mini_sprite
```

Use the Widget

```dart
MiniSpriteWidget(
  pixelSize: 10,
  sprite: MiniSprite.fromDataString('...'),
  palette: [ const Color(0xFFFFFF00), const Color(0xFFFF0000) ],
),
```
