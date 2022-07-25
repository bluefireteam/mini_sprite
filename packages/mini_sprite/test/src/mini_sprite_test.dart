import 'package:mini_sprite/mini_sprite.dart';
import 'package:test/test.dart';

void main() {
  group('MiniSprite', () {
    test('empty returns an empty sprite', () {
      expect(
        MiniSprite.empty(2, 2).pixels,
        equals([
          [
            false,
            false,
          ],
          [
            false,
            false,
          ],
        ]),
      );
    });

    test('toDataString returns the correct data', () {
      expect(
        MiniSprite([
          [true, true],
          [true, true],
        ]).toDataString(),
        equals('2,2;4,1'),
      );

      expect(
        MiniSprite([
          [true, true],
          [true, false],
        ]).toDataString(),
        equals('2,2;3,1;1,0'),
      );

      expect(
        MiniSprite([
          [true, false],
          [true, false],
        ]).toDataString(),
        equals('2,2;1,1;1,0;1,1;1,0'),
      );
    });

    test('fromDataString returns the correct parsed instance', () {
      expect(
        MiniSprite.fromDataString('2,2;4,1').pixels,
        equals([
          [true, true],
          [true, true],
        ]),
      );

      expect(
        MiniSprite.fromDataString('2,2;3,1;1,0').pixels,
        equals([
          [true, true],
          [true, false],
        ]),
      );

      expect(
        MiniSprite.fromDataString('2,2;1,1;1,0;1,1;1,0').pixels,
        equals([
          [true, false],
          [true, false],
        ]),
      );
    });

    group('when dimensions are not symmetrical', () {
      test('toDataString returns the correct data', () {
        expect(
          MiniSprite([
            [true, true, true],
            [true, false, false],
          ]).toDataString(),
          equals('2,3;4,1;2,0'),
        );
      });

      test('fromDataString returns the correct parsed instance', () {
        expect(
          MiniSprite.fromDataString('2,3;4,1;2,0').pixels,
          equals([
            [true, true, true],
            [true, false, false],
          ]),
        );
      });
    });
  });
}
