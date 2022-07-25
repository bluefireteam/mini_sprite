// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_sprite_editor/sprite/sprite.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockSpriteCubit extends Mock implements SpriteCubit {}

extension TestWidgetText on WidgetTester {
  Future<void> pumpTest({SpriteCubit? cubit}) async {
    await pumpApp(
      BlocProvider<SpriteCubit>.value(
        value: cubit ?? _MockSpriteCubit(),
        child: SpriteView(),
      ),
    );
  }
}

void main() {
  group('SpriteView', () {
    late SpriteCubit cubit;

    setUpAll(() {
      registerFallbackValue(SpriteTool.brush);
      registerFallbackValue(Offset.zero);
    });

    setUp(() {
      cubit = _MockSpriteCubit();
    });

    void _mockState(SpriteState state) {
      whenListen(
        cubit,
        Stream.fromIterable([state]),
        initialState: state,
      );
    }

    testWidgets('emits cursor down on pan start', (tester) async {
      when(() => cubit.cursorDown(any())).thenAnswer((_) {});
      _mockState(SpriteState.initial());
      await tester.pumpTest(cubit: cubit);

      await tester.drag(find.byKey(const Key('board_key')), Offset(30, 30));
      await tester.pump();

      verify(() => cubit.cursorDown(any())).called(1);
    });

    testWidgets('emits cursor hover on pan update', (tester) async {
      when(() => cubit.cursorHover(any())).thenAnswer((_) {});
      _mockState(SpriteState.initial());
      await tester.pumpTest(cubit: cubit);

      await tester.drag(find.byKey(const Key('board_key')), Offset(30, 30));
      await tester.pump();

      verify(() => cubit.cursorHover(any())).called(2);
    });

    testWidgets('emits cursor hover on hover', (tester) async {
      when(() => cubit.cursorHover(any())).thenAnswer((_) {});
      _mockState(SpriteState.initial());
      await tester.pumpTest(cubit: cubit);

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(
        tester.getCenter(
          find.byKey(const Key('board_key')),
        ),
      );
      await tester.pump();

      verify(() => cubit.cursorHover(any())).called(1);
    });

    testWidgets('emits cursor up on pan up', (tester) async {
      when(() => cubit.cursorHover(any())).thenAnswer((_) {});
      _mockState(SpriteState.initial());
      await tester.pumpTest(cubit: cubit);

      await tester.drag(find.byKey(const Key('board_key')), Offset(30, 30));
      await tester.pump();

      verify(() => cubit.cursorUp()).called(1);
    });

    group('tools', () {
      group('brush', () {
        testWidgets(
          'selects the tool when tapped',
          (tester) async {
            _mockState(SpriteState.initial().copyWith(tool: SpriteTool.eraser));
            await tester.pumpTest(cubit: cubit);
            await tester.tap(find.byKey(const Key('brush_key')));
            await tester.pump();
            verify(() => cubit.selectTool(SpriteTool.brush)).called(1);
          },
        );

        testWidgets(
          'does nothing when it is already selected',
          (tester) async {
            _mockState(SpriteState.initial());
            await tester.pumpTest(cubit: cubit);
            await tester.tap(find.byKey(const Key('brush_key')));
            await tester.pump();
            verifyNever(() => cubit.selectTool(any()));
          },
        );
      });

      group('eraser', () {
        testWidgets(
          'selects the tool when tapped',
          (tester) async {
            _mockState(SpriteState.initial());
            await tester.pumpTest(cubit: cubit);
            await tester.tap(find.byKey(const Key('eraser_key')));
            await tester.pump();
            verify(() => cubit.selectTool(SpriteTool.eraser)).called(1);
          },
        );

        testWidgets(
          'does nothing when it is already selected',
          (tester) async {
            _mockState(SpriteState.initial().copyWith(tool: SpriteTool.eraser));
            await tester.pumpTest(cubit: cubit);
            await tester.tap(find.byKey(const Key('eraser_key')));
            await tester.pump();
            verifyNever(() => cubit.selectTool(any()));
          },
        );
      });

      group('bucket', () {
        testWidgets(
          'selects the tool when tapped',
          (tester) async {
            _mockState(SpriteState.initial());
            await tester.pumpTest(cubit: cubit);
            await tester.tap(find.byKey(const Key('bucket_key')));
            await tester.pump();
            verify(() => cubit.selectTool(SpriteTool.bucket)).called(1);
          },
        );

        testWidgets(
          'does nothing when it is already selected',
          (tester) async {
            _mockState(SpriteState.initial().copyWith(tool: SpriteTool.bucket));
            await tester.pumpTest(cubit: cubit);
            await tester.tap(find.byKey(const Key('bucket_key')));
            await tester.pump();
            verifyNever(() => cubit.selectTool(any()));
          },
        );
      });

      group('bucket eraser', () {
        testWidgets(
          'selects the tool when tapped',
          (tester) async {
            _mockState(SpriteState.initial());
            await tester.pumpTest(cubit: cubit);
            await tester.tap(find.byKey(const Key('bucket_eraser_key')));
            await tester.pump();
            verify(() => cubit.selectTool(SpriteTool.bucketEraser)).called(1);
          },
        );

        testWidgets(
          'does nothing when it is already selected',
          (tester) async {
            _mockState(
              SpriteState.initial().copyWith(tool: SpriteTool.bucketEraser),
            );
            await tester.pumpTest(cubit: cubit);
            await tester.tap(find.byKey(const Key('bucket_eraser_key')));
            await tester.pump();
            verifyNever(() => cubit.selectTool(any()));
          },
        );
      });

      testWidgets(
        'zooms in',
        (tester) async {
          _mockState(SpriteState.initial());
          await tester.pumpTest(cubit: cubit);
          await tester.tap(find.byKey(const Key('zoom_in_key')));
          await tester.pump();
          verify(cubit.zoomIn).called(1);
        },
      );

      testWidgets(
        'zooms out',
        (tester) async {
          _mockState(SpriteState.initial());
          await tester.pumpTest(cubit: cubit);
          await tester.tap(find.byKey(const Key('zoom_out_key')));
          await tester.pump();
          verify(cubit.zoomOut).called(1);
        },
      );

      group('copy to clipboard', () {
        setUp(() {
          when(cubit.copyToClipboard).thenAnswer((_) async {});
        });

        testWidgets(
          'copies to the clipboard',
          (tester) async {
            _mockState(SpriteState.initial());
            await tester.pumpTest(cubit: cubit);
            await tester.tap(find.byKey(const Key('copy_to_clipboard_key')));
            await tester.pump();
            verify(cubit.copyToClipboard).called(1);
          },
        );

        testWidgets(
          'shows the success message',
          (tester) async {
            _mockState(SpriteState.initial());
            await tester.pumpTest(cubit: cubit);
            await tester.tap(find.byKey(const Key('copy_to_clipboard_key')));
            await tester.pump();
            expect(find.byType(SnackBar), findsOneWidget);
          },
        );
      });

      group('import from clipboard', () {
        setUp(() {
          when(cubit.importFromClipboard).thenAnswer((_) async {});
        });

        testWidgets(
          'copies to the clipboard',
          (tester) async {
            _mockState(SpriteState.initial());
            await tester.pumpTest(cubit: cubit);
            await tester.tap(
              find.byKey(const Key('import_from_clipboard_key')),
            );
            await tester.pump();
            verify(cubit.importFromClipboard).called(1);
          },
        );

        testWidgets(
          'shows the success message',
          (tester) async {
            _mockState(SpriteState.initial());
            await tester.pumpTest(cubit: cubit);
            await tester.tap(
              find.byKey(const Key('import_from_clipboard_key')),
            );
            await tester.pump();
            expect(find.byType(SnackBar), findsOneWidget);
          },
        );
      });
    });
  });
}
