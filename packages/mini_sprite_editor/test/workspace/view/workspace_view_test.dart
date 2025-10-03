import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_sprite/mini_sprite.dart';
import 'package:mini_sprite_editor/config/config.dart';
import 'package:mini_sprite_editor/library/library.dart';
import 'package:mini_sprite_editor/map/map.dart';
import 'package:mini_sprite_editor/sprite/cubit/tools_cubit.dart';
import 'package:mini_sprite_editor/sprite/sprite.dart';
import 'package:mini_sprite_editor/workspace/workspace.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockWorkspaceCubit extends MockCubit<WorkspaceState>
    implements WorkspaceCubit {}

class _MockMapCubit extends MockCubit<MapState> implements MapCubit {}

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
    required WorkspaceCubit workspaceCubit,
    required MapCubit mapCubit,
    List<Color>? colors,
    MiniSprite? sprite,
  }) async {
    await pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<SpriteCubit>.value(value: spriteCubit),
          BlocProvider<ToolsCubit>.value(value: toolsCubit),
          BlocProvider<ConfigCubit>.value(value: configCubit),
          BlocProvider<LibraryCubit>.value(value: libraryCubit),
          BlocProvider<WorkspaceCubit>.value(value: workspaceCubit),
          BlocProvider<MapCubit>.value(value: mapCubit),
        ],
        child: Scaffold(body: WorkspaceView(colorList: colors, sprite: sprite)),
      ),
    );
  }
}

void main() {
  group('WorkspaceView', () {
    late SpriteCubit spriteCubit;
    late ToolsCubit toolsCubit;
    late ConfigCubit configCubit;
    late LibraryCubit libraryCubit;
    late WorkspaceCubit workspaceCubit;
    late MapCubit mapCubit;

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
      workspaceCubit = _MockWorkspaceCubit();
      mapCubit = _MockMapCubit();
    });

    void mockState({
      required SpriteState spriteState,
      required ToolsState toolsState,
      required ConfigState configState,
      required LibraryState libraryState,
      required WorkspaceState workspaceState,
      required MapState mapState,
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
      whenListen(
        workspaceCubit,
        Stream.fromIterable([workspaceState]),
        initialState: workspaceState,
      );
      whenListen(
        mapCubit,
        Stream.fromIterable([mapState]),
        initialState: mapState,
      );
    }

    testWidgets('renders', (tester) async {
      mockState(
        spriteState: SpriteState.initial(),
        toolsState: const ToolsState.initial(),
        configState: const ConfigState.initial(),
        libraryState: const LibraryState.initial(),
        workspaceState: const WorkspaceState.initial(),
        mapState: const MapState.initial(),
      );

      await tester.pumpTest(
        spriteCubit: spriteCubit,
        toolsCubit: toolsCubit,
        configCubit: configCubit,
        libraryCubit: libraryCubit,
        workspaceCubit: workspaceCubit,
        mapCubit: mapCubit,
      );

      expect(find.byType(WorkspaceView), findsOneWidget);
    });

    testWidgets('set the colors when receiving a list of colors', (
      tester,
    ) async {
      mockState(
        spriteState: SpriteState.initial(),
        toolsState: const ToolsState.initial(),
        configState: const ConfigState.initial(),
        libraryState: const LibraryState.initial(),
        workspaceState: const WorkspaceState.initial(),
        mapState: const MapState.initial(),
      );

      await tester.pumpTest(
        spriteCubit: spriteCubit,
        toolsCubit: toolsCubit,
        configCubit: configCubit,
        libraryCubit: libraryCubit,
        workspaceCubit: workspaceCubit,
        mapCubit: mapCubit,
        colors: [Colors.red, Colors.blue],
      );

      verify(() => configCubit.setColors([Colors.red, Colors.blue])).called(1);
    });

    testWidgets('set the sprite when receiving one', (tester) async {
      mockState(
        spriteState: SpriteState.initial(),
        toolsState: const ToolsState.initial(),
        configState: const ConfigState.initial(),
        libraryState: const LibraryState.initial(),
        workspaceState: const WorkspaceState.initial(),
        mapState: const MapState.initial(),
      );

      const sprite = MiniSprite([
        [1],
        [0],
      ]);
      await tester.pumpTest(
        spriteCubit: spriteCubit,
        toolsCubit: toolsCubit,
        configCubit: configCubit,
        libraryCubit: libraryCubit,
        workspaceCubit: workspaceCubit,
        mapCubit: mapCubit,
        sprite: sprite,
      );

      verify(() => spriteCubit.setSprite(sprite.pixels)).called(1);
    });
  });
}
