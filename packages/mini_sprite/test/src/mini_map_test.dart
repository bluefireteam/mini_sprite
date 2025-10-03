import 'package:mini_sprite/mini_sprite.dart';
import 'package:test/test.dart';

void main() {
  group('MiniMap', () {
    group('when using the legacy map format', () {
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
    });

    group('when using the new map format', () {
      test('fromDataString returns the correct instance', () {
        const data =
            '{"objects":[{"x": 0, "y": 0, "data": {"sprite": "player"}}]}';
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

      test(
        'fromDataString returns the correct instance with width and height',
        () {
          const data =
              // Ignore for tests
              // ignore: lines_longer_than_80_chars
              '{"width":2,"height":2,"objects":[{"x": 0, "y": 0, "data": {"sprite": "player"}}]}';
          final instance = MiniMap.fromDataString(data);

          expect(
            instance,
            MiniMap(
              width: 2,
              height: 2,
              objects: {
                const MapPosition(0, 0): const <String, dynamic>{
                  'sprite': 'player',
                },
              },
            ),
          );
        },
      );
    });

    test('toDataString returns the correct serialized data', () {
      const data = '{"objects":[{"x":0,"y":0,"data":{"sprite":"player"}}]}';

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

    group('map size', () {
      test('returns informed dimension when present', () {
        expect(const MiniMap(objects: {}, width: 10).width, equals(10));
        expect(const MiniMap(objects: {}, height: 10).height, equals(10));
      });

      test('returns the bigger position from objects', () {
        final map = MiniMap(
          objects: {
            const MapPosition(2, 2): const <String, dynamic>{
              'sprite': 'player',
            },
          },
        );
        expect(map.width, equals(3));
        expect(map.height, equals(3));
      });
    });
  });
}
