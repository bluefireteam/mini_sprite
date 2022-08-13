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
                [true, true],
                [true, true],
              ],
            ),
            'B': MiniSprite(
              [
                [false, false],
                [false, false],
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
                  [true, true],
                  [true, true],
                ],
              ),
              'B': MiniSprite(
                [
                  [false, false],
                  [false, false],
                ],
              ),
            },
          ),
        ),
      );
    });
  });
}
