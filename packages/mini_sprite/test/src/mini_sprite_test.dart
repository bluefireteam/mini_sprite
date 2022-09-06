// ignore_for_file: prefer_const_constructors

import 'package:mini_sprite/mini_sprite.dart';
import 'package:test/test.dart';

void main() {
  group('MiniSprite', () {
    test('empty returns an empty sprite', () {
      expect(
        MiniSprite.empty(2, 2).pixels,
        equals([
          [ -1, -1 ],
          [ -1, -1 ],
        ]),
      );
    });

    test('toDataString returns the correct data', () {
      expect(
        MiniSprite(const [
          [0, 0],
          [0, 0],
        ]).toDataString(),
        equals('2,2;4,0'),
      );

      expect(
        MiniSprite(const [
          [0, 0],
          [0, 1],
        ]).toDataString(),
        equals('2,2;3,0;1,1'),
      );

      expect(
        MiniSprite(const [
          [0, 1],
          [0, 1],
        ]).toDataString(),
        equals('2,2;1,0;1,1;1,0;1,1'),
      );
    });

    test('fromDataString returns the correct parsed instance', () {
      expect(
        MiniSprite.fromDataString('2,2;4,1').pixels,
        equals([
          [1, 1],
          [1, 1],
        ]),
      );

      expect(
        MiniSprite.fromDataString('2,2;3,1;1,0').pixels,
        equals([
          [1, 1],
          [1, 0],
        ]),
      );

      expect(
        MiniSprite.fromDataString('2,2;1,1;1,0;1,1;1,0').pixels,
        equals([
          [1, 0],
          [1, 0],
        ]),
      );
    });

    group('when dimensions are not symmetrical', () {
      test('toDataString returns the correct data', () {
        expect(
          MiniSprite(const [
            [1, 1, 1],
            [1, 0, 0],
          ]).toDataString(),
          equals('2,3;4,1;2,0'),
        );
      });

      test('fromDataString returns the correct parsed instance', () {
        expect(
          MiniSprite.fromDataString('2,3;4,1;2,0').pixels,
          equals([
            [1, 1, 1],
            [1, 0, 0],
          ]),
        );
      });
    });

    test('supports equality', () {
      expect(
        MiniSprite(const [
          [1],
          [1]
        ]),
        equals(
          MiniSprite(const [
            [1],
            [1]
          ]),
        ),
      );

      expect(
        MiniSprite(const [
          [1],
          [0]
        ]),
        isNot(
          equals(
            MiniSprite(const [
              [0],
              [0]
            ]),
          ),
        ),
      );
    });
  });
}
