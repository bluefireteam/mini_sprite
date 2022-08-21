import 'package:mini_sprite/mini_sprite.dart';
import 'package:test/test.dart';

void main() {
  group('MiniMap', () {
    test('fromDataString returns the correct instance', () {
      const data = '[{"x": 0, "y": 0, "data": {"sprite": "player"}}]';
      final instance = MiniMap.fromDataString(data);

      expect(
        instance,
        MiniMap(
          objects: {
            const MapPosition(0, 0): const <String, dynamic>{
              'sprite': 'player',
            },
          },
        ),
      );
    });

    test('toDataString returns the correct serialized data', () {
      const data = '[{"x":0,"y":0,"data":{"sprite":"player"}}]';

      expect(
        MiniMap(
          objects: {
            const MapPosition(0, 0): const <String, dynamic>{
              'sprite': 'player',
            },
          },
        ).toDataString(),
        equals(data),
      );
    });
  });
}
