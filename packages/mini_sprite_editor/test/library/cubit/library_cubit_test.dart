// ignore_for_file: prefer_const_constructors, one_member_abstracts

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_sprite/mini_sprite.dart';
import 'package:mini_sprite_editor/library/library.dart';
import 'package:mocktail/mocktail.dart';

abstract class _SetClipboardStub {
  Future<void> setClipboardData(ClipboardData data);
}

class SetClipboardStub extends Mock implements _SetClipboardStub {}

abstract class _GetClipboardStub {
  Future<ClipboardData?> getClipboardData(String format);
}

class GetClipboardStub extends Mock implements _GetClipboardStub {}

void main() {
  group('LibraryCubit', () {
    setUpAll(() {
      registerFallbackValue(const ClipboardData(text: ''));
    });

    blocTest<LibraryCubit, LibraryState>(
      'startCollection initializes the state',
      build: LibraryCubit.new,
      act: (cubit) => cubit.startCollection([
        [true]
      ]),
      expect: () => [
        LibraryState(
          sprites: const {
            'sprite_1': MiniSprite([
              [true]
            ]),
          },
          selected: 'sprite_1',
        ),
      ],
    );

    blocTest<LibraryCubit, LibraryState>(
      'updates the selected sprite',
      seed: () => LibraryState(
        sprites: const {
          'player': MiniSprite(
            [
              [true, true],
              [true, true],
            ],
          ),
          'tile': MiniSprite(
            [
              [false, true],
              [true, false],
            ],
          ),
        },
        selected: 'player',
      ),
      build: LibraryCubit.new,
      act: (cubit) => cubit.updateSelected([
        [true, false],
        [false, true],
      ]),
      expect: () => [
        LibraryState(
          sprites: const {
            'player': MiniSprite(
              [
                [true, false],
                [false, true],
              ],
            ),
            'tile': MiniSprite(
              [
                [false, true],
                [true, false],
              ],
            ),
          },
          selected: 'player',
        ),
      ],
    );

    blocTest<LibraryCubit, LibraryState>(
      'renames a sprite',
      seed: () => LibraryState(
        sprites: const {
          'player': MiniSprite(
            [
              [true, true],
              [true, true],
            ],
          ),
          'tile': MiniSprite(
            [
              [false, true],
              [true, false],
            ],
          ),
        },
        selected: 'player',
      ),
      build: LibraryCubit.new,
      act: (cubit) => cubit.rename('player', 'char'),
      expect: () => [
        LibraryState(
          sprites: const {
            'char': MiniSprite(
              [
                [true, true],
                [true, true],
              ],
            ),
            'tile': MiniSprite(
              [
                [false, true],
                [true, false],
              ],
            ),
          },
          selected: 'char',
        ),
      ],
    );

    blocTest<LibraryCubit, LibraryState>(
      'renames a sprite that is not selected',
      seed: () => LibraryState(
        sprites: const {
          'player': MiniSprite(
            [
              [true, true],
              [true, true],
            ],
          ),
          'tile': MiniSprite(
            [
              [false, true],
              [true, false],
            ],
          ),
        },
        selected: 'tile',
      ),
      build: LibraryCubit.new,
      act: (cubit) => cubit.rename('player', 'char'),
      expect: () => [
        LibraryState(
          sprites: const {
            'char': MiniSprite(
              [
                [true, true],
                [true, true],
              ],
            ),
            'tile': MiniSprite(
              [
                [false, true],
                [true, false],
              ],
            ),
          },
          selected: 'tile',
        ),
      ],
    );

    blocTest<LibraryCubit, LibraryState>(
      'removes a sprite',
      seed: () => LibraryState(
        sprites: const {
          'player': MiniSprite(
            [
              [true, true],
              [true, true],
            ],
          ),
          'tile': MiniSprite(
            [
              [false, true],
              [true, false],
            ],
          ),
        },
        selected: 'tile',
      ),
      build: LibraryCubit.new,
      act: (cubit) => cubit.removeSprite('player'),
      expect: () => [
        LibraryState(
          sprites: const {
            'tile': MiniSprite(
              [
                [false, true],
                [true, false],
              ],
            ),
          },
          selected: 'tile',
        ),
      ],
    );

    blocTest<LibraryCubit, LibraryState>(
      'removes a sprite that is selected',
      seed: () => LibraryState(
        sprites: const {
          'player': MiniSprite(
            [
              [true, true],
              [true, true],
            ],
          ),
          'tile': MiniSprite(
            [
              [false, true],
              [true, false],
            ],
          ),
        },
        selected: 'player',
      ),
      build: LibraryCubit.new,
      act: (cubit) => cubit.removeSprite('player'),
      expect: () => [
        LibraryState(
          sprites: const {
            'tile': MiniSprite(
              [
                [false, true],
                [true, false],
              ],
            ),
          },
          selected: 'tile',
        ),
      ],
    );

    blocTest<LibraryCubit, LibraryState>(
      'adds a sprite',
      seed: () => const LibraryState(
        sprites: {},
        selected: '',
      ),
      build: LibraryCubit.new,
      act: (cubit) => cubit.addSprite(2, 2),
      expect: () => [
        LibraryState(
          sprites: const {
            'sprite_1': MiniSprite(
              [
                [false, false],
                [false, false],
              ],
            ),
          },
          selected: '',
        ),
      ],
    );

    blocTest<LibraryCubit, LibraryState>(
      'can handle name conflict on addSprite',
      seed: () => const LibraryState(
        sprites: {
          'sprite_2': MiniSprite(
            [
              [false, false],
              [false, false],
            ],
          ),
        },
        selected: '',
      ),
      build: LibraryCubit.new,
      act: (cubit) => cubit.addSprite(2, 2),
      expect: () => [
        LibraryState(
          sprites: const {
            'sprite_2': MiniSprite(
              [
                [false, false],
                [false, false],
              ],
            ),
            'sprite_3': MiniSprite(
              [
                [false, false],
                [false, false],
              ],
            ),
          },
          selected: '',
        ),
      ],
    );

    blocTest<LibraryCubit, LibraryState>(
      'selects a sprite',
      seed: () => LibraryState(
        sprites: {'player': MiniSprite.empty(1, 1)},
        selected: '',
      ),
      build: LibraryCubit.new,
      act: (cubit) => cubit.select('player'),
      expect: () => [
        LibraryState(
          sprites: {'player': MiniSprite.empty(1, 1)},
          selected: 'player',
        ),
      ],
    );
  });

  group('importFromClipboard', () {
    late GetClipboardStub stub;
    final sprite = MiniSprite(const [
      [true, false],
      [false, true]
    ]);
    final library = MiniLibrary({
      'player': sprite,
    });

    setUp(() {
      stub = GetClipboardStub();
    });

    blocTest<LibraryCubit, LibraryState>(
      'emits the updated library when there is data',
      build: () => LibraryCubit(getClipboardData: stub.getClipboardData),
      setUp: () {
        when(() => stub.getClipboardData('text/plain')).thenAnswer(
          (_) async => ClipboardData(text: library.toDataString()),
        );
      },
      act: (cubit) => cubit.importFromClipboard(),
      expect: () => [
        LibraryState(sprites: {'player': sprite}, selected: 'player'),
      ],
    );
  });

  test(
    'copyToClipboard sets the serialized library to the clipboard',
    () async {
      final stub = SetClipboardStub();
      when(() => stub.setClipboardData(any())).thenAnswer((_) async {});

      final cubit = LibraryCubit(setClipboardData: stub.setClipboardData);

      final expected = MiniLibrary(cubit.state.sprites).toDataString();
      cubit.copyToClipboard();

      verify(
        () => stub.setClipboardData(
          any(
            that: isA<ClipboardData>().having(
              (data) => data.text,
              'text',
              equals(expected),
            ),
          ),
        ),
      ).called(1);
    },
  );
}
