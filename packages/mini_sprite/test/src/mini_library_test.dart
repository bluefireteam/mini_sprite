// ignore_for_file: prefer_const_constructors

import 'package:mini_sprite/mini_sprite.dart';
import 'package:test/test.dart';

void main() {
  group('MiniLibrary', () {
    test('empty returns an empty library', () {
      expect(
        MiniLibrary.empty().sprites,
        isEmpty,
      );
    });

    test('toDataString returns the correct data', () {
      expect(
        MiniLibrary(
          const {
            'A': MiniSprite(
              [
                [1, 1],
                [1, 1],
              ],
            ),
            'B': MiniSprite(
              [
                [0, 0],
                [0, 0],
              ],
            ),
          },
        ).toDataString(),
        equals('A|2,2;4,1\nB|2,2;4,0'),
      );
    });

    test('fromDataString returns the correct parsed instance', () {
      expect(
        MiniLibrary.fromDataString('A|2,2;4,1\nB|2,2;4,0'),
        equals(
          MiniLibrary(
            const {
              'A': MiniSprite(
                [
                  [1, 1],
                  [1, 1],
                ],
              ),
              'B': MiniSprite(
                [
                  [0, 0],
                  [0, 0],
                ],
              ),
            },
          ),
        ),
      );
    });
  });
}
