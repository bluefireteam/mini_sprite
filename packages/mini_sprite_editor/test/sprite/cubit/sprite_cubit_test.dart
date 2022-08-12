// ignore_for_file: one_member_abstracts

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
        [true, false],
        [false, true]
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
          [true, true],
          [true, true],
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
        ),
        expect: () => <SpriteState>[],
      );
    });

    group('cursorHover', () {
      final state = SpriteState.initial().copyWith(
        pixels: [
          [true, true],
          [true, true],
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
            ..cursorUp(SpriteTool.brush);
        },
        verify: (bloc) {
          expect(bloc.toolActive, isFalse);
        },
      );
    });

    group('tools', () {
      final emptyState = SpriteState.initial().copyWith(
        pixels: [
          [false, false, false],
          [false, false, false],
          [false, false, false],
        ],
      );
      final filledState = SpriteState.initial().copyWith(
        pixels: [
          [true, true, true],
          [true, true, true],
          [true, true, true],
        ],
      );

      group('brush', () {
        blocTest<SpriteCubit, SpriteState>(
          'paints the board',
          build: SpriteCubit.new,
          seed: () => emptyState,
          act: (cubit) => cubit
            ..cursorDown(Offset.zero, 25, SpriteTool.brush)
            ..cursorHover(const Offset(30, 0), 25, SpriteTool.brush)
            ..cursorHover(const Offset(60, 0), 25, SpriteTool.brush)
            ..cursorUp(SpriteTool.brush),
          expect: () => [
            emptyState.copyWith(cursorPosition: Offset.zero),
            emptyState.copyWith(
              cursorPosition: Offset.zero,
              pixels: [
                [true, false, false],
                [false, false, false],
                [false, false, false],
              ],
            ),
            emptyState.copyWith(
              cursorPosition: const Offset(1, 0),
              pixels: [
                [true, false, false],
                [false, false, false],
                [false, false, false],
              ],
            ),
            emptyState.copyWith(
              cursorPosition: const Offset(1, 0),
              pixels: [
                [true, true, false],
                [false, false, false],
                [false, false, false],
              ],
            ),
            emptyState.copyWith(
              cursorPosition: const Offset(2, 0),
              pixels: [
                [true, true, false],
                [false, false, false],
                [false, false, false],
              ],
            ),
            emptyState.copyWith(
              cursorPosition: const Offset(2, 0),
              pixels: [
                [true, true, true],
                [false, false, false],
                [false, false, false],
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
            ..cursorDown(Offset.zero, 25, SpriteTool.eraser)
            ..cursorHover(const Offset(30, 0), 25, SpriteTool.eraser)
            ..cursorHover(const Offset(60, 0), 25, SpriteTool.eraser)
            ..cursorUp(SpriteTool.eraser),
          expect: () => [
            filledState.copyWith(
              cursorPosition: Offset.zero,
            ),
            filledState.copyWith(
              cursorPosition: Offset.zero,
              pixels: [
                [false, true, true],
                [true, true, true],
                [true, true, true],
              ],
            ),
            filledState.copyWith(
              cursorPosition: const Offset(1, 0),
              pixels: [
                [false, true, true],
                [true, true, true],
                [true, true, true],
              ],
            ),
            filledState.copyWith(
              cursorPosition: const Offset(1, 0),
              pixels: [
                [false, false, true],
                [true, true, true],
                [true, true, true],
              ],
            ),
            filledState.copyWith(
              cursorPosition: const Offset(2, 0),
              pixels: [
                [false, false, true],
                [true, true, true],
                [true, true, true],
              ],
            ),
            filledState.copyWith(
              cursorPosition: const Offset(2, 0),
              pixels: [
                [false, false, false],
                [true, true, true],
                [true, true, true],
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
          act: (cubit) => cubit..cursorDown(Offset.zero, 25, SpriteTool.bucket),
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
              [false, false],
              [false, false],
            ],
          ),
        ],
      );

      blocTest<SpriteCubit, SpriteState>(
        'resizes the sprite keep any data possible',
        build: SpriteCubit.new,
        seed: () => SpriteState.initial().copyWith(
          pixels: [
            [true],
            [false],
          ],
        ),
        act: (cubit) => cubit..setSize(2, 2),
        expect: () => [
          SpriteState.initial().copyWith(
            pixels: [
              [true, false],
              [false, false],
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
          [true],
          [true],
        ],
      ),
      act: (cubit) => cubit.clearSprite(),
      expect: () => [
        SpriteState.initial().copyWith(
          pixels: [
            [false],
            [false],
          ],
        ),
      ],
    );

    blocTest<SpriteCubit, SpriteState>(
      'sets the sprite',
      build: SpriteCubit.new,
      act: (cubit) => cubit.setSprite([
        [false],
        [false],
      ]),
      expect: () => [
        SpriteState.initial().copyWith(
          pixels: [
            [false],
            [false],
          ],
        ),
      ],
    );

    test('shouldReplay is true when pixels are different', () {
      final cubit = SpriteCubit();
      final state = SpriteState.initial().copyWith(
        pixels: [
          [true],
          [true],
        ],
      );
      expect(cubit.shouldReplay(state), isTrue);
    });

    test('shouldReplay is false when pixels are different', () {
      final cubit = SpriteCubit();
      final state = SpriteState.initial();
      expect(cubit.shouldReplay(state), isFalse);
    });
  });
}
