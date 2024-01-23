// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:mini_sprite/mini_sprite.dart';
import 'package:mini_sprite_editor/library/library.dart';

void main() {
  group('LibraryState', () {
    test('can be instantiated', () {
      expect(
        LibraryState(
          sprites: const {},
          selected: '',
        ),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        LibraryState(sprites: const {}, selected: ''),
        equals(
          LibraryState(sprites: const {}, selected: ''),
        ),
      );

      expect(
        LibraryState(
          sprites: const {
            'player': MiniSprite([
              [1],
              [1],
            ]),
          },
          selected: '',
        ),
        isNot(
          equals(
            LibraryState(
              sprites: const {
                'player': MiniSprite([
                  [1],
                  [0],
                ]),
              },
              selected: '',
            ),
          ),
        ),
      );

      expect(
        LibraryState(
          sprites: const {
            'player': MiniSprite([
              [1],
              [1],
            ]),
          },
          selected: '',
        ),
        isNot(
          equals(
            LibraryState(
              sprites: const {
                'player': MiniSprite([
                  [1],
                  [1],
                ]),
              },
              selected: 'player',
            ),
          ),
        ),
      );
    });

    test('copyWith return new instance with the value', () {
      expect(
        LibraryState.initial().copyWith(
          sprites: {
            'player': MiniSprite(const [
              [1],
              [1],
            ]),
          },
        ),
        equals(
          LibraryState(
            sprites: const {
              'player': MiniSprite([
                [1],
                [1],
              ]),
            },
            selected: '',
          ),
        ),
      );

      expect(
        LibraryState.initial().copyWith(
          selected: 'player',
        ),
        equals(
          LibraryState(
            sprites: const {},
            selected: 'player',
          ),
        ),
      );
    });
  });
}
