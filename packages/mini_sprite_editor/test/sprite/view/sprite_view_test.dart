// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mini_sprite_editor/config/config.dart';
import 'package:mini_sprite_editor/library/library.dart';
import 'package:mini_sprite_editor/sprite/cubit/tools_cubit.dart';
import 'package:mini_sprite_editor/sprite/sprite.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockSpriteCubit extends Mock implements SpriteCubit {}

class _MockToolsCubit extends Mock implements ToolsCubit {}

class _MockConfigCubit extends Mock implements ConfigCubit {}

class _MockLibraryCubit extends Mock implements LibraryCubit {}

extension TestWidgetText on WidgetTester {
  Future<void> pumpTest({
    required SpriteCubit spriteCubit,
    required ToolsCubit toolsCubit,
    required ConfigCubit configCubit,
    required LibraryCubit libraryCubit,
  }) async {
    await pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<SpriteCubit>.value(
            value: spriteCubit,
          ),
          BlocProvider<ToolsCubit>.value(
            value: toolsCubit,
          ),
          BlocProvider<ConfigCubit>.value(
            value: configCubit,
          ),
          BlocProvider<LibraryCubit>.value(
            value: libraryCubit,
          ),
        ],
        child: const Scaffold(body: SpriteView()),
      ),
    );
  }
}

void main() async {
  HydratedBloc.storage = MockHydratedStorage();

  group('SpriteView', () {
    late SpriteCubit spriteCubit;
    late ToolsCubit toolsCubit;
    late ConfigCubit configCubit;
    late LibraryCubit libraryCubit;

    setUpAll(() {
      registerFallbackValue(SpriteTool.brush);
      registerFallbackValue(Offset.zero);
      registerFallbackValue(Colors.black);
    });

    setUp(() {
      spriteCubit = _MockSpriteCubit();
      toolsCubit = _MockToolsCubit();
      configCubit = _MockConfigCubit();
      libraryCubit = _MockLibraryCubit();
    });

    void _mockState({
      required SpriteState spriteState,
      required ToolsState toolsState,
      required ConfigState configState,
      required LibraryState libraryState,
    }) {
      whenListen(
        spriteCubit,
        Stream.fromIterable([spriteState]),
        initialState: spriteState,
      );
      whenListen(
        toolsCubit,
        Stream.fromIterable([toolsState]),
        initialState: toolsState,
      );
      whenListen(
        configCubit,
        Stream.fromIterable([configState]),
        initialState: configState,
      );
      whenListen(
        libraryCubit,
        Stream.fromIterable([libraryState]),
        initialState: libraryState,
      );
    }

    testWidgets('emits cursor down on pan start', (tester) async {
      when(() => spriteCubit.cursorDown(any(), any(), any(), any()))
          .thenAnswer((_) {});
      _mockState(
        spriteState: SpriteState.initial(),
        toolsState: ToolsState.initial(),
        configState: ConfigState.initial(),
        libraryState: LibraryState.initial(),
      );
      await tester.pumpTest(
        spriteCubit: spriteCubit,
        toolsCubit: toolsCubit,
        configCubit: configCubit,
        libraryCubit: libraryCubit,
      );

      await tester.drag(find.byKey(const Key('board_key')), Offset(30, 30));
      await tester.pump();

      verify(
        () => spriteCubit.cursorDown(
          any(),
          any(),
          any(),
          any(),
        ),
      ).called(1);
    });

    testWidgets('emits cursor hover on pan update', (tester) async {
      when(() => spriteCubit.cursorHover(any(), any(), any(), any()))
          .thenAnswer((_) {});
      _mockState(
        spriteState: SpriteState.initial(),
        toolsState: ToolsState.initial(),
        configState: ConfigState.initial(),
        libraryState: LibraryState.initial(),
      );
      await tester.pumpTest(
        spriteCubit: spriteCubit,
        toolsCubit: toolsCubit,
        configCubit: configCubit,
        libraryCubit: libraryCubit,
      );

      await tester.drag(find.byKey(const Key('board_key')), Offset(30, 30));
      await tester.pump();

      verify(
        () => spriteCubit.cursorHover(
          any(),
          any(),
          any(),
          any(),
        ),
      ).called(2);
    });

    testWidgets('emits cursor hover on hover', (tester) async {
      when(() => spriteCubit.cursorHover(any(), any(), any(), any()))
          .thenAnswer((_) {});
      _mockState(
        spriteState: SpriteState.initial(),
        toolsState: ToolsState.initial(),
        configState: ConfigState.initial(),
        libraryState: LibraryState.initial(),
      );
      await tester.pumpTest(
        spriteCubit: spriteCubit,
        toolsCubit: toolsCubit,
        configCubit: configCubit,
        libraryCubit: libraryCubit,
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(
        tester.getCenter(
          find.byKey(const Key('board_key')),
        ),
      );
      await tester.pump();

      verify(() => spriteCubit.cursorHover(any(), any(), any(), any()))
          .called(1);
    });

    testWidgets('emits cursor up on pan up', (tester) async {
      when(() => spriteCubit.cursorHover(any(), any(), any(), any()))
          .thenAnswer((_) {});
      _mockState(
        spriteState: SpriteState.initial(),
        toolsState: ToolsState.initial(),
        configState: ConfigState.initial(),
        libraryState: LibraryState.initial(),
      );
      await tester.pumpTest(
        spriteCubit: spriteCubit,
        toolsCubit: toolsCubit,
        configCubit: configCubit,
        libraryCubit: libraryCubit,
      );

      await tester.drag(find.byKey(const Key('board_key')), Offset(30, 30));
      await tester.pump();

      verify(() => spriteCubit.cursorUp(any(), any())).called(1);
    });

    group('flip', () {
      testWidgets('flips horizontally', (tester) async {
        _mockState(
          spriteState: SpriteState.initial(),
          toolsState: ToolsState.initial(),
          configState: ConfigState.initial(),
          libraryState: LibraryState.initial(),
        );
        await tester.pumpTest(
          spriteCubit: spriteCubit,
          toolsCubit: toolsCubit,
          configCubit: configCubit,
          libraryCubit: libraryCubit,
        );

        await tester.tap(find.byKey(const Key('flip_horizontally_key')));
        await tester.pump();

        verify(() => spriteCubit.flipSpriteHorizontally()).called(1);
      });

      testWidgets('flips vertically', (tester) async {
        _mockState(
          spriteState: SpriteState.initial(),
          toolsState: ToolsState.initial(),
          configState: ConfigState.initial(),
          libraryState: LibraryState.initial(),
        );
        await tester.pumpTest(
          spriteCubit: spriteCubit,
          toolsCubit: toolsCubit,
          configCubit: configCubit,
          libraryCubit: libraryCubit,
        );

        await tester.tap(find.byKey(const Key('flip_vertically_key')));
        await tester.pump();

        verify(() => spriteCubit.flipSpriteVertically()).called(1);
      });
    });

    group('rotate', () {
      testWidgets('rotates clockwise', (tester) async {
        _mockState(
          spriteState: SpriteState.initial(),
          toolsState: ToolsState.initial(),
          configState: ConfigState.initial(),
          libraryState: LibraryState.initial(),
        );
        await tester.pumpTest(
          spriteCubit: spriteCubit,
          toolsCubit: toolsCubit,
          configCubit: configCubit,
          libraryCubit: libraryCubit,
        );

        await tester.tap(find.byKey(const Key('rotate_clockwise_key')));
        await tester.pump();

        verify(() => spriteCubit.rotateSpriteClockwise()).called(1);
      });

      testWidgets('rotates counter clockwise', (tester) async {
        _mockState(
          spriteState: SpriteState.initial(),
          toolsState: ToolsState.initial(),
          configState: ConfigState.initial(),
          libraryState: LibraryState.initial(),
        );
        await tester.pumpTest(
          spriteCubit: spriteCubit,
          toolsCubit: toolsCubit,
          configCubit: configCubit,
          libraryCubit: libraryCubit,
        );

        await tester.tap(find.byKey(const Key('rotate_counter_clockwise_key')));
        await tester.pump();

        verify(() => spriteCubit.rotateSpriteCounterClockwise()).called(1);
      });
    });

    group('tools', () {
      group('brush', () {
        testWidgets(
          'selects the tool when tapped',
          (tester) async {
            _mockState(
              spriteState: SpriteState.initial(),
              toolsState: ToolsState.initial().copyWith(
                tool: SpriteTool.eraser,
              ),
              configState: ConfigState.initial(),
              libraryState: LibraryState.initial(),
            );
            await tester.pumpTest(
              spriteCubit: spriteCubit,
              toolsCubit: toolsCubit,
              configCubit: configCubit,
              libraryCubit: libraryCubit,
            );
            await tester.tap(find.byKey(const Key('brush_key')));
            await tester.pump();
            verify(() => toolsCubit.selectTool(SpriteTool.brush)).called(1);
          },
        );

        testWidgets(
          'does nothing when it is already selected',
          (tester) async {
            _mockState(
              spriteState: SpriteState.initial(),
              toolsState: ToolsState.initial(),
              configState: ConfigState.initial(),
              libraryState: LibraryState.initial(),
            );
            await tester.pumpTest(
              spriteCubit: spriteCubit,
              toolsCubit: toolsCubit,
              configCubit: configCubit,
              libraryCubit: libraryCubit,
            );
            await tester.tap(find.byKey(const Key('brush_key')));
            await tester.pump();
            verifyNever(() => toolsCubit.selectTool(any()));
          },
        );
      });

      group('eraser', () {
        testWidgets(
          'selects the tool when tapped',
          (tester) async {
            _mockState(
              spriteState: SpriteState.initial(),
              toolsState: ToolsState.initial(),
              configState: ConfigState.initial(),
              libraryState: LibraryState.initial(),
            );
            await tester.pumpTest(
              spriteCubit: spriteCubit,
              toolsCubit: toolsCubit,
              configCubit: configCubit,
              libraryCubit: libraryCubit,
            );
            await tester.tap(find.byKey(const Key('eraser_key')));
            await tester.pump();
            verify(() => toolsCubit.selectTool(SpriteTool.eraser)).called(1);
          },
        );

        testWidgets(
          'does nothing when it is already selected',
          (tester) async {
            _mockState(
              spriteState: SpriteState.initial(),
              toolsState: ToolsState.initial().copyWith(
                tool: SpriteTool.eraser,
              ),
              configState: ConfigState.initial(),
              libraryState: LibraryState.initial(),
            );
            await tester.pumpTest(
              spriteCubit: spriteCubit,
              toolsCubit: toolsCubit,
              configCubit: configCubit,
              libraryCubit: libraryCubit,
            );
            await tester.tap(find.byKey(const Key('eraser_key')));
            await tester.pump();
            verifyNever(() => toolsCubit.selectTool(any()));
          },
        );
      });

      group('bucket', () {
        testWidgets(
          'selects the tool when tapped',
          (tester) async {
            _mockState(
              spriteState: SpriteState.initial(),
              toolsState: ToolsState.initial(),
              configState: ConfigState.initial(),
              libraryState: LibraryState.initial(),
            );
            await tester.pumpTest(
              spriteCubit: spriteCubit,
              toolsCubit: toolsCubit,
              configCubit: configCubit,
              libraryCubit: libraryCubit,
            );
            await tester.tap(find.byKey(const Key('bucket_key')));
            await tester.pump();
            verify(() => toolsCubit.selectTool(SpriteTool.bucket)).called(1);
          },
        );

        testWidgets(
          'does nothing when it is already selected',
          (tester) async {
            _mockState(
              spriteState: SpriteState.initial(),
              toolsState: ToolsState.initial().copyWith(
                tool: SpriteTool.bucket,
              ),
              configState: ConfigState.initial(),
              libraryState: LibraryState.initial(),
            );
            await tester.pumpTest(
              spriteCubit: spriteCubit,
              toolsCubit: toolsCubit,
              configCubit: configCubit,
              libraryCubit: libraryCubit,
            );
            await tester.tap(find.byKey(const Key('bucket_key')));
            await tester.pump();
            verifyNever(() => toolsCubit.selectTool(any()));
          },
        );
      });

      group('bucket eraser', () {
        testWidgets(
          'selects the tool when tapped',
          (tester) async {
            _mockState(
              spriteState: SpriteState.initial(),
              toolsState: ToolsState.initial(),
              configState: ConfigState.initial(),
              libraryState: LibraryState.initial(),
            );
            await tester.pumpTest(
              spriteCubit: spriteCubit,
              toolsCubit: toolsCubit,
              configCubit: configCubit,
              libraryCubit: libraryCubit,
            );
            await tester.tap(find.byKey(const Key('bucket_eraser_key')));
            await tester.pump();
            verify(() => toolsCubit.selectTool(SpriteTool.bucketEraser))
                .called(1);
          },
        );

        testWidgets(
          'does nothing when it is already selected',
          (tester) async {
            _mockState(
              spriteState: SpriteState.initial(),
              toolsState: ToolsState.initial().copyWith(
                tool: SpriteTool.bucketEraser,
              ),
              configState: ConfigState.initial(),
              libraryState: LibraryState.initial(),
            );
            await tester.pumpTest(
              spriteCubit: spriteCubit,
              toolsCubit: toolsCubit,
              configCubit: configCubit,
              libraryCubit: libraryCubit,
            );
            await tester.tap(find.byKey(const Key('bucket_eraser_key')));
            await tester.pump();
            verifyNever(() => toolsCubit.selectTool(any()));
          },
        );
      });

      testWidgets(
        'zooms in',
        (tester) async {
          _mockState(
            spriteState: SpriteState.initial(),
            toolsState: ToolsState.initial(),
            configState: ConfigState.initial(),
            libraryState: LibraryState.initial(),
          );
          await tester.pumpTest(
            spriteCubit: spriteCubit,
            toolsCubit: toolsCubit,
            configCubit: configCubit,
            libraryCubit: libraryCubit,
          );
          await tester.tap(find.byKey(const Key('zoom_in_key')));
          await tester.pump();
          verify(toolsCubit.zoomIn).called(1);
        },
      );

      testWidgets(
        'zooms out',
        (tester) async {
          _mockState(
            spriteState: SpriteState.initial(),
            toolsState: ToolsState.initial(),
            configState: ConfigState.initial(),
            libraryState: LibraryState.initial(),
          );
          await tester.pumpTest(
            spriteCubit: spriteCubit,
            toolsCubit: toolsCubit,
            configCubit: configCubit,
            libraryCubit: libraryCubit,
          );
          await tester.tap(find.byKey(const Key('zoom_out_key')));
          await tester.pump();
          verify(toolsCubit.zoomOut).called(1);
        },
      );

      group('copy to clipboard', () {
        setUp(() {
          when(spriteCubit.copyToClipboard).thenAnswer((_) async {});
        });

        testWidgets(
          'copies to the clipboard',
          (tester) async {
            _mockState(
              spriteState: SpriteState.initial(),
              toolsState: ToolsState.initial(),
              configState: ConfigState.initial(),
              libraryState: LibraryState.initial(),
            );
            await tester.pumpTest(
              spriteCubit: spriteCubit,
              toolsCubit: toolsCubit,
              configCubit: configCubit,
              libraryCubit: libraryCubit,
            );
            await tester.tap(find.byKey(const Key('copy_to_clipboard_key')));
            await tester.pump();
            verify(spriteCubit.copyToClipboard).called(1);
          },
        );

        testWidgets(
          'shows the success message',
          (tester) async {
            _mockState(
              spriteState: SpriteState.initial(),
              toolsState: ToolsState.initial(),
              configState: ConfigState.initial(),
              libraryState: LibraryState.initial(),
            );
            await tester.pumpTest(
              spriteCubit: spriteCubit,
              toolsCubit: toolsCubit,
              configCubit: configCubit,
              libraryCubit: libraryCubit,
            );
            await tester.tap(find.byKey(const Key('copy_to_clipboard_key')));
            await tester.pump();
            expect(find.byType(SnackBar), findsOneWidget);
          },
        );
      });

      group('import from clipboard', () {
        setUp(() {
          when(spriteCubit.importFromClipboard).thenAnswer((_) async {});
        });

        testWidgets(
          'copies to the clipboard',
          (tester) async {
            _mockState(
              spriteState: SpriteState.initial(),
              toolsState: ToolsState.initial(),
              configState: ConfigState.initial(),
              libraryState: LibraryState.initial(),
            );
            await tester.pumpTest(
              spriteCubit: spriteCubit,
              toolsCubit: toolsCubit,
              configCubit: configCubit,
              libraryCubit: libraryCubit,
            );
            await tester.tap(
              find.byKey(const Key('import_from_clipboard_key')),
            );
            await tester.pump();
            verify(spriteCubit.importFromClipboard).called(1);
          },
        );

        testWidgets(
          'shows the success message',
          (tester) async {
            _mockState(
              spriteState: SpriteState.initial(),
              toolsState: ToolsState.initial(),
              configState: ConfigState.initial(),
              libraryState: LibraryState.initial(),
            );
            await tester.pumpTest(
              spriteCubit: spriteCubit,
              toolsCubit: toolsCubit,
              configCubit: configCubit,
              libraryCubit: libraryCubit,
            );
            await tester.tap(
              find.byKey(const Key('import_from_clipboard_key')),
            );
            await tester.pump();
            expect(find.byType(SnackBar), findsOneWidget);
          },
        );
      });

      group('export to image', () {
        setUp(() {
          when(
            () => spriteCubit.exportToImage(
              pixelSize: any(named: 'pixelSize'),
              palette: any(named: 'palette'),
              backgroundColor: any(named: 'backgroundColor'),
            ),
          ).thenAnswer((_) async {});
        });

        testWidgets(
          'exports',
          (tester) async {
            _mockState(
              spriteState: SpriteState.initial(),
              toolsState: ToolsState.initial(),
              configState: ConfigState.initial(),
              libraryState: LibraryState.initial(),
            );
            await tester.pumpTest(
              spriteCubit: spriteCubit,
              toolsCubit: toolsCubit,
              configCubit: configCubit,
              libraryCubit: libraryCubit,
            );
            await tester.tap(
              find.byKey(const Key('export_to_image')),
            );
            await tester.pump();
            verify(
              () => spriteCubit.exportToImage(
                pixelSize: any(named: 'pixelSize'),
                palette: any(named: 'palette'),
                backgroundColor: any(named: 'backgroundColor'),
              ),
            ).called(1);
          },
        );

        testWidgets(
          'shows the success message',
          (tester) async {
            _mockState(
              spriteState: SpriteState.initial(),
              toolsState: ToolsState.initial(),
              configState: ConfigState.initial(),
              libraryState: LibraryState.initial(),
            );
            await tester.pumpTest(
              spriteCubit: spriteCubit,
              toolsCubit: toolsCubit,
              configCubit: configCubit,
              libraryCubit: libraryCubit,
            );
            await tester.tap(
              find.byKey(const Key('export_to_image')),
            );
            await tester.pump();
            expect(find.byType(SnackBar), findsOneWidget);
          },
        );
      });

      testWidgets('opens the resize dialog', (tester) async {
        _mockState(
          spriteState: SpriteState.initial(),
          toolsState: ToolsState.initial(),
          configState: ConfigState.initial(),
          libraryState: LibraryState.initial(),
        );
        await tester.pumpTest(
          spriteCubit: spriteCubit,
          toolsCubit: toolsCubit,
          configCubit: configCubit,
          libraryCubit: libraryCubit,
        );

        await tester.tap(find.byKey(const Key('resize_sprite_key')));
        await tester.pumpAndSettle();

        expect(find.byType(SpriteSizeDialog), findsOneWidget);
      });

      testWidgets('can resize the sprite', (tester) async {
        _mockState(
          spriteState: SpriteState.initial(),
          toolsState: ToolsState.initial(),
          configState: ConfigState.initial(),
          libraryState: LibraryState.initial(),
        );
        await tester.pumpTest(
          spriteCubit: spriteCubit,
          toolsCubit: toolsCubit,
          configCubit: configCubit,
          libraryCubit: libraryCubit,
        );

        await tester.tap(find.byKey(const Key('resize_sprite_key')));
        await tester.pumpAndSettle();

        await tester.enterText(find.byKey(Key('width_text_field_key')), '2');
        await tester.enterText(find.byKey(Key('height_text_field_key')), '2');

        await tester.tap(find.text('Confirm'));
        await tester.pump();

        verify(() => spriteCubit.setSize(2, 2)).called(1);
      });

      testWidgets('does nothing when cancel the resizing', (tester) async {
        _mockState(
          spriteState: SpriteState.initial(),
          toolsState: ToolsState.initial(),
          configState: ConfigState.initial(),
          libraryState: LibraryState.initial(),
        );
        await tester.pumpTest(
          spriteCubit: spriteCubit,
          toolsCubit: toolsCubit,
          configCubit: configCubit,
          libraryCubit: libraryCubit,
        );

        await tester.tap(find.byKey(const Key('resize_sprite_key')));
        await tester.pumpAndSettle();

        await tester.enterText(find.byKey(Key('width_text_field_key')), '2');
        await tester.enterText(find.byKey(Key('height_text_field_key')), '2');

        await tester.tap(find.text('Cancel'));
        await tester.pump();

        verifyNever(() => spriteCubit.setSize(any(), any()));
      });

      testWidgets(
        'opens the confirm dialog when clearing the sprite',
        (tester) async {
          _mockState(
            spriteState: SpriteState.initial(),
            toolsState: ToolsState.initial(),
            configState: ConfigState.initial(),
            libraryState: LibraryState.initial(),
          );
          await tester.pumpTest(
            spriteCubit: spriteCubit,
            toolsCubit: toolsCubit,
            configCubit: configCubit,
            libraryCubit: libraryCubit,
          );

          await tester.tap(find.byKey(const Key('clear_sprite_key')));
          await tester.pumpAndSettle();

          expect(find.byType(ConfirmDialog), findsOneWidget);
        },
      );

      testWidgets(
        'clears the sprite upon confirmation',
        (tester) async {
          _mockState(
            spriteState: SpriteState.initial(),
            toolsState: ToolsState.initial(),
            configState: ConfigState.initial(),
            libraryState: LibraryState.initial(),
          );
          await tester.pumpTest(
            spriteCubit: spriteCubit,
            toolsCubit: toolsCubit,
            configCubit: configCubit,
            libraryCubit: libraryCubit,
          );

          await tester.tap(find.byKey(const Key('clear_sprite_key')));
          await tester.pumpAndSettle();

          await tester.tap(find.text('Confirm'));
          await tester.pumpAndSettle();

          verify(spriteCubit.clearSprite).called(1);
        },
      );

      testWidgets(
        'does nothing when cancel the clearing',
        (tester) async {
          _mockState(
            spriteState: SpriteState.initial(),
            toolsState: ToolsState.initial(),
            configState: ConfigState.initial(),
            libraryState: LibraryState.initial(),
          );
          await tester.pumpTest(
            spriteCubit: spriteCubit,
            toolsCubit: toolsCubit,
            configCubit: configCubit,
            libraryCubit: libraryCubit,
          );

          await tester.tap(find.byKey(const Key('clear_sprite_key')));
          await tester.pumpAndSettle();

          await tester.tap(find.text('Cancel'));
          await tester.pumpAndSettle();

          verifyNever(spriteCubit.clearSprite);
        },
      );

      testWidgets(
        'toogles the grid',
        (tester) async {
          _mockState(
            spriteState: SpriteState.initial(),
            toolsState: ToolsState.initial(),
            configState: ConfigState.initial(),
            libraryState: LibraryState.initial(),
          );
          await tester.pumpTest(
            spriteCubit: spriteCubit,
            toolsCubit: toolsCubit,
            configCubit: configCubit,
            libraryCubit: libraryCubit,
          );

          await tester.tap(find.byKey(const Key('toogle_grid_key')));
          await tester.pumpAndSettle();

          verify(toolsCubit.toogleGrid).called(1);
        },
      );

      group('tools shortcuts', () {
        testWidgets(
          'b selects brush',
          (tester) async {
            _mockState(
              spriteState: SpriteState.initial(),
              toolsState: ToolsState.initial(),
              configState: ConfigState.initial(),
              libraryState: LibraryState.initial(),
            );
            await tester.pumpTest(
              spriteCubit: spriteCubit,
              toolsCubit: toolsCubit,
              configCubit: configCubit,
              libraryCubit: libraryCubit,
            );

            await tester.sendKeyDownEvent(LogicalKeyboardKey.keyB);
            await tester.sendKeyUpEvent(LogicalKeyboardKey.keyB);
            await tester.pump();

            verify(() => toolsCubit.selectTool(SpriteTool.brush)).called(1);
          },
        );

        testWidgets(
          'e selects eraser',
          (tester) async {
            _mockState(
              spriteState: SpriteState.initial(),
              toolsState: ToolsState.initial(),
              configState: ConfigState.initial(),
              libraryState: LibraryState.initial(),
            );
            await tester.pumpTest(
              spriteCubit: spriteCubit,
              toolsCubit: toolsCubit,
              configCubit: configCubit,
              libraryCubit: libraryCubit,
            );

            await tester.sendKeyDownEvent(LogicalKeyboardKey.keyE);
            await tester.sendKeyUpEvent(LogicalKeyboardKey.keyE);
            await tester.pump();

            verify(() => toolsCubit.selectTool(SpriteTool.eraser)).called(1);
          },
        );

        testWidgets(
          'f selects bucket',
          (tester) async {
            _mockState(
              spriteState: SpriteState.initial(),
              toolsState: ToolsState.initial(),
              configState: ConfigState.initial(),
              libraryState: LibraryState.initial(),
            );
            await tester.pumpTest(
              spriteCubit: spriteCubit,
              toolsCubit: toolsCubit,
              configCubit: configCubit,
              libraryCubit: libraryCubit,
            );

            await tester.sendKeyDownEvent(LogicalKeyboardKey.keyF);
            await tester.sendKeyUpEvent(LogicalKeyboardKey.keyF);
            await tester.pump();

            verify(() => toolsCubit.selectTool(SpriteTool.bucket)).called(1);
          },
        );

        testWidgets(
          'd selects bucket eraser',
          (tester) async {
            _mockState(
              spriteState: SpriteState.initial(),
              toolsState: ToolsState.initial(),
              configState: ConfigState.initial(),
              libraryState: LibraryState.initial(),
            );
            await tester.pumpTest(
              spriteCubit: spriteCubit,
              toolsCubit: toolsCubit,
              configCubit: configCubit,
              libraryCubit: libraryCubit,
            );

            await tester.sendKeyDownEvent(LogicalKeyboardKey.keyD);
            await tester.sendKeyUpEvent(LogicalKeyboardKey.keyD);
            await tester.pump();

            verify(() => toolsCubit.selectTool(SpriteTool.bucketEraser))
                .called(1);
          },
        );

        testWidgets(
          'meta + z undo',
          (tester) async {
            _mockState(
              spriteState: SpriteState.initial(),
              toolsState: ToolsState.initial(),
              configState: ConfigState.initial(),
              libraryState: LibraryState.initial(),
            );
            await tester.pumpTest(
              spriteCubit: spriteCubit,
              toolsCubit: toolsCubit,
              configCubit: configCubit,
              libraryCubit: libraryCubit,
            );

            await tester.sendKeyDownEvent(LogicalKeyboardKey.meta);
            await tester.sendKeyDownEvent(LogicalKeyboardKey.keyZ);
            await tester.sendKeyUpEvent(LogicalKeyboardKey.meta);
            await tester.sendKeyUpEvent(LogicalKeyboardKey.keyZ);
            await tester.pump();

            verify(spriteCubit.undo).called(1);
          },
        );

        testWidgets(
          'meta + y undo',
          (tester) async {
            _mockState(
              spriteState: SpriteState.initial(),
              toolsState: ToolsState.initial(),
              configState: ConfigState.initial(),
              libraryState: LibraryState.initial(),
            );
            await tester.pumpTest(
              spriteCubit: spriteCubit,
              toolsCubit: toolsCubit,
              configCubit: configCubit,
              libraryCubit: libraryCubit,
            );

            await tester.sendKeyDownEvent(LogicalKeyboardKey.meta);
            await tester.sendKeyDownEvent(LogicalKeyboardKey.keyY);
            await tester.sendKeyUpEvent(LogicalKeyboardKey.meta);
            await tester.sendKeyUpEvent(LogicalKeyboardKey.keyY);
            await tester.pump();

            verify(spriteCubit.redo).called(1);
          },
        );
      });
    });
  });
}
