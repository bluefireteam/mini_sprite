// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
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
          BlocProvider<SpriteCubit>.value(value: spriteCubit),
          BlocProvider<ToolsCubit>.value(value: toolsCubit),
          BlocProvider<ConfigCubit>.value(value: configCubit),
          BlocProvider<LibraryCubit>.value(value: libraryCubit),
        ],
        child: const SpriteView(),
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
      registerFallbackValue(Colors.white);
    });

    setUp(() {
      spriteCubit = _MockSpriteCubit();
      toolsCubit = _MockToolsCubit();
      configCubit = _MockConfigCubit();
      libraryCubit = _MockLibraryCubit();
    });

    void mockState({
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

    group('config', () {
      testWidgets('opens the config dialog', (tester) async {
        mockState(
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

        await tester.tap(find.byKey(const Key('config_key')));
        await tester.pumpAndSettle();

        expect(find.byType(ConfigDialog), findsOneWidget);
      });

      testWidgets('can close the config dialog', (tester) async {
        mockState(
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

        await tester.tap(find.byKey(const Key('config_key')));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Close'));
        await tester.pumpAndSettle();

        expect(find.byType(ConfigDialog), findsNothing);
      });

      testWidgets('can change to system', (tester) async {
        mockState(
          spriteState: SpriteState.initial(),
          toolsState: ToolsState.initial(),
          configState: ConfigState.initial().copyWith(
            themeMode: ThemeMode.dark,
          ),
          libraryState: LibraryState.initial(),
        );

        await tester.pumpTest(
          spriteCubit: spriteCubit,
          toolsCubit: toolsCubit,
          configCubit: configCubit,
          libraryCubit: libraryCubit,
        );

        await tester.tap(find.byKey(const Key('config_key')));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('radio_system')));
        await tester.pump();
        verify(() => configCubit.setThemeMode(ThemeMode.system)).called(1);
      });

      testWidgets('can change to light', (tester) async {
        mockState(
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

        await tester.tap(find.byKey(const Key('config_key')));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('radio_light')));
        await tester.pump();
        verify(() => configCubit.setThemeMode(ThemeMode.light)).called(1);
      });

      testWidgets('can change to dark', (tester) async {
        mockState(
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

        await tester.tap(find.byKey(const Key('config_key')));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('radio_dark')));
        await tester.pump();
        verify(() => configCubit.setThemeMode(ThemeMode.dark)).called(1);
      });

      testWidgets('can change add a color', (tester) async {
        const state = ConfigState.initial();
        mockState(
          spriteState: SpriteState.initial(),
          toolsState: ToolsState.initial(),
          configState: state,
          libraryState: LibraryState.initial(),
        );

        await tester.pumpTest(
          spriteCubit: spriteCubit,
          toolsCubit: toolsCubit,
          configCubit: configCubit,
          libraryCubit: libraryCubit,
        );

        await tester.tap(find.byKey(const Key('config_key')));
        await tester.pumpAndSettle();

        const addColorKey = Key('add_color_button');
        await tester.ensureVisible(find.byKey(addColorKey));
        await tester.tap(find.byKey(addColorKey));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Confirm'));
        await tester.pumpAndSettle();
        await tester.idle();

        verify(() => configCubit.addColor(Colors.white)).called(1);
      });

      testWidgets('can change a color', (tester) async {
        const state = ConfigState.initial();
        mockState(
          spriteState: SpriteState.initial(),
          toolsState: ToolsState.initial(),
          configState: state.copyWith(colors: const [Colors.red, Colors.green]),
          libraryState: LibraryState.initial(),
        );

        await tester.pumpTest(
          spriteCubit: spriteCubit,
          toolsCubit: toolsCubit,
          configCubit: configCubit,
          libraryCubit: libraryCubit,
        );

        await tester.tap(find.byKey(const Key('config_key')));
        await tester.pumpAndSettle();

        const colorKey = Key('color_entry_0');
        await tester.ensureVisible(find.byKey(colorKey));
        await tester.tap(find.byKey(colorKey));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Confirm'));
        await tester.pumpAndSettle();
        await tester.idle();

        verify(() => configCubit.setColor(0, captureAny())).called(1);
      });

      testWidgets('can change the background color', (tester) async {
        const state = ConfigState.initial();
        mockState(
          spriteState: SpriteState.initial(),
          toolsState: ToolsState.initial(),
          configState: state,
          libraryState: LibraryState.initial(),
        );

        await tester.pumpTest(
          spriteCubit: spriteCubit,
          toolsCubit: toolsCubit,
          configCubit: configCubit,
          libraryCubit: libraryCubit,
        );

        await tester.tap(find.byKey(const Key('config_key')));
        await tester.pumpAndSettle();

        const backgroundColorKey = Key('background_color_key');
        await tester.ensureVisible(find.byKey(backgroundColorKey));
        await tester.tap(find.byKey(backgroundColorKey));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Confirm'));
        await tester.pumpAndSettle();
        await tester.idle();

        verify(
          () => configCubit.setBackgroundColor(state.backgroundColor),
        ).called(1);
      });
    });
  });
}
