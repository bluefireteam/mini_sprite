// ignore_for_file: one_member_abstracts, prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_sprite/mini_sprite.dart';
import 'package:mini_sprite_editor/sprite/sprite.dart';
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
  group('SpriteCubit', () {
    setUpAll(() {
      registerFallbackValue(const ClipboardData(text: ''));
    });

    test('can be instantiated', () {
      expect(
        SpriteCubit(),
        isNotNull,
      );
    });

    test(
      'copyToClipboard sets the serialized sprite to the clipboard',
      () async {
        final stub = SetClipboardStub();
        when(() => stub.setClipboardData(any())).thenAnswer((_) async {});

        final cubit = SpriteCubit(setClipboardData: stub.setClipboardData);

        final expected = MiniSprite(cubit.state.pixels).toDataString();
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

    group('importFromClipboard', () {
      late GetClipboardStub stub;
      final sprite = MiniSprite(const [
        [1, 0],
        [0, 1]
      ]);

      setUp(() {
        stub = GetClipboardStub();
      });

      blocTest<SpriteCubit, SpriteState>(
        'emits the updated pixels when there is data',
        build: () => SpriteCubit(getClipboardData: stub.getClipboardData),
        setUp: () {
          when(() => stub.getClipboardData('text/plain')).thenAnswer(
            (_) async => ClipboardData(text: sprite.toDataString()),
          );
        },
        act: (cubit) => cubit.importFromClipboard(),
        expect: () => [
          SpriteState.initial().copyWith(pixels: sprite.pixels),
        ],
      );
    });

    blocTest<SpriteCubit, SpriteState>(
      'resets cursor on cursorLeft',
      build: SpriteCubit.new,
      seed: () => SpriteState.initial().copyWith(cursorPosition: Offset.zero),
      act: (cubit) => cubit.cursorLeft(),
      expect: () => [
        SpriteState.initial().copyWith(cursorPosition: const Offset(-1, -1)),
      ],
    );

    group('cursorHover', () {
      final state = SpriteState.initial().copyWith(
        pixels: [
          [1, 1],
          [1, 1],
        ],
      );

      blocTest<SpriteCubit, SpriteState>(
        'change cursor position on cursorHover',
        build: SpriteCubit.new,
        seed: () => state,
        act: (cubit) => cubit.cursorHover(
          const Offset(30, 30),
          25,
          SpriteTool.brush,
          1,
        ),
        expect: () => [
          state.copyWith(cursorPosition: const Offset(1, 1)),
        ],
      );

      blocTest<SpriteCubit, SpriteState>(
        "doesn't change the position when the position is the same",
        build: SpriteCubit.new,
        seed: () => state.copyWith(cursorPosition: const Offset(1, 1)),
        act: (cubit) => cubit.cursorHover(
          const Offset(30, 30),
          25,
          SpriteTool.brush,
          1,
        ),
        expect: () => <SpriteState>[],
      );
    });

    group('cursorHover', () {
      final state = SpriteState.initial().copyWith(
        pixels: [
          [1, 1],
          [1, 1],
        ],
      );

      blocTest<SpriteCubit, SpriteState>(
        'change cursor position on cursorDown and active the tool',
        build: SpriteCubit.new,
        seed: () => state,
        act: (cubit) => cubit.cursorDown(
          const Offset(30, 30),
          25,
          SpriteTool.brush,
          1,
        ),
        expect: () => [
          state.copyWith(
            cursorPosition: const Offset(1, 1),
          ),
        ],
      );
    });

    group('cursorUp', () {
      blocTest<SpriteCubit, SpriteState>(
        'change cursor position on cursorUp and deactive the tool',
        build: SpriteCubit.new,
        act: (cubit) {
          cubit
            ..toolActive = true
            ..cursorUp(SpriteTool.brush, 0);
        },
        verify: (bloc) {
          expect(bloc.toolActive, isFalse);
        },
      );
    });

    group('tools', () {
      final emptyState = SpriteState.initial().copyWith(
        pixels: [
          [-1, -1, -1],
          [-1, -1, -1],
          [-1, -1, -1],
        ],
      );
      final filledState = SpriteState.initial().copyWith(
        pixels: [
          [1, 1, 1],
          [1, 1, 1],
          [1, 1, 1],
        ],
      );

      group('brush', () {
        blocTest<SpriteCubit, SpriteState>(
          'paints the board',
          build: SpriteCubit.new,
          seed: () => emptyState,
          act: (cubit) => cubit
            ..cursorDown(Offset.zero, 25, SpriteTool.brush, 1)
            ..cursorHover(const Offset(30, 0), 25, SpriteTool.brush, 1)
            ..cursorHover(const Offset(60, 0), 25, SpriteTool.brush, 1)
            ..cursorUp(SpriteTool.brush, 1),
          expect: () => [
            emptyState.copyWith(cursorPosition: Offset.zero),
            emptyState.copyWith(
              cursorPosition: Offset.zero,
              pixels: [
                [1, -1, -1],
                [-1, -1, -1],
                [-1, -1, -1],
              ],
            ),
            emptyState.copyWith(
              cursorPosition: const Offset(1, 0),
              pixels: [
                [1, -1, -1],
                [-1, -1, -1],
                [-1, -1, -1],
              ],
            ),
            emptyState.copyWith(
              cursorPosition: const Offset(1, 0),
              pixels: [
                [1, 1, -1],
                [-1, -1, -1],
                [-1, -1, -1],
              ],
            ),
            emptyState.copyWith(
              cursorPosition: const Offset(2, 0),
              pixels: [
                [1, 1, -1],
                [-1, -1, -1],
                [-1, -1, -1],
              ],
            ),
            emptyState.copyWith(
              cursorPosition: const Offset(2, 0),
              pixels: [
                [1, 1, 1],
                [-1, -1, -1],
                [-1, -1, -1],
              ],
            ),
          ],
        );
      });

      group('eraser', () {
        blocTest<SpriteCubit, SpriteState>(
          'clears the board',
          build: SpriteCubit.new,
          seed: () => filledState,
          act: (cubit) => cubit
            ..cursorDown(Offset.zero, 25, SpriteTool.eraser, 0)
            ..cursorHover(const Offset(30, 0), 25, SpriteTool.eraser, 0)
            ..cursorHover(const Offset(60, 0), 25, SpriteTool.eraser, 0)
            ..cursorUp(SpriteTool.eraser, 0),
          expect: () => [
            filledState.copyWith(
              cursorPosition: Offset.zero,
            ),
            filledState.copyWith(
              cursorPosition: Offset.zero,
              pixels: [
                [-1, 1, 1],
                [1, 1, 1],
                [1, 1, 1],
              ],
            ),
            filledState.copyWith(
              cursorPosition: const Offset(1, 0),
              pixels: [
                [-1, 1, 1],
                [1, 1, 1],
                [1, 1, 1],
              ],
            ),
            filledState.copyWith(
              cursorPosition: const Offset(1, 0),
              pixels: [
                [-1, -1, 1],
                [1, 1, 1],
                [1, 1, 1],
              ],
            ),
            filledState.copyWith(
              cursorPosition: const Offset(2, 0),
              pixels: [
                [-1, -1, 1],
                [1, 1, 1],
                [1, 1, 1],
              ],
            ),
            filledState.copyWith(
              cursorPosition: const Offset(2, 0),
              pixels: [
                [-1, -1, -1],
                [1, 1, 1],
                [1, 1, 1],
              ],
            ),
          ],
        );
      });

      group('bucket', () {
        blocTest<SpriteCubit, SpriteState>(
          'fills the board',
          seed: () => emptyState,
          build: SpriteCubit.new,
          act: (cubit) => cubit
            ..cursorDown(
              Offset.zero,
              25,
              SpriteTool.bucket,
              1,
            ),
          expect: () => [
            emptyState.copyWith(
              cursorPosition: Offset.zero,
            ),
            filledState.copyWith(
              cursorPosition: Offset.zero,
            ),
          ],
        );
      });

      group('bucketEraser', () {
        blocTest<SpriteCubit, SpriteState>(
          'clears the board',
          build: SpriteCubit.new,
          seed: () => filledState,
          act: (cubit) => cubit
            ..cursorDown(
              Offset.zero,
              25,
              SpriteTool.bucketEraser,
              0,
            ),
          expect: () => [
            filledState.copyWith(
              cursorPosition: Offset.zero,
            ),
            emptyState.copyWith(
              cursorPosition: Offset.zero,
            ),
          ],
        );
      });
    });

    group('sprite resize', () {
      blocTest<SpriteCubit, SpriteState>(
        'resizes the sprite',
        build: SpriteCubit.new,
        act: (cubit) => cubit..setSize(2, 2),
        expect: () => [
          SpriteState.initial().copyWith(
            pixels: [
              [-1, -1],
              [-1, -1],
            ],
          ),
        ],
      );

      blocTest<SpriteCubit, SpriteState>(
        'resizes the sprite keep any data possible',
        build: SpriteCubit.new,
        seed: () => SpriteState.initial().copyWith(
          pixels: [
            [1],
            [0],
          ],
        ),
        act: (cubit) => cubit..setSize(2, 2),
        expect: () => [
          SpriteState.initial().copyWith(
            pixels: [
              [1, -1],
              [0, -1],
            ],
          ),
        ],
      );
    });

    blocTest<SpriteCubit, SpriteState>(
      'clears the sprite',
      build: SpriteCubit.new,
      seed: () => SpriteState.initial().copyWith(
        pixels: [
          [1],
          [1],
        ],
      ),
      act: (cubit) => cubit.clearSprite(),
      expect: () => [
        SpriteState.initial().copyWith(
          pixels: [
            [-1],
            [-1],
          ],
        ),
      ],
    );

    blocTest<SpriteCubit, SpriteState>(
      'sets the sprite',
      build: SpriteCubit.new,
      act: (cubit) => cubit.setSprite([
        [0],
        [0],
      ]),
      expect: () => [
        SpriteState.initial().copyWith(
          pixels: [
            [0],
            [0],
          ],
        ),
      ],
    );

    test('shouldReplay is 1 when pixels are different', () {
      final cubit = SpriteCubit();
      final state = SpriteState.initial().copyWith(
        pixels: [
          [1],
          [1],
        ],
      );
      expect(cubit.shouldReplay(state), isTrue);
    });

    test('shouldReplay is 0 when pixels are different', () {
      final cubit = SpriteCubit();
      final state = SpriteState.initial();
      expect(cubit.shouldReplay(state), isFalse);
    });
  });
}
