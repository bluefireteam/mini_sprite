// Ignoring for tests
// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_sprite_editor/sprite/cubit/tools_cubit.dart';
import 'package:mini_sprite_editor/sprite/sprite.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group('ToolsCubit', () {
    setUpAll(() {
      registerFallbackValue(const ClipboardData(text: ''));
    });

    test('can be instantiated', () {
      expect(ToolsCubit(), isNotNull);
    });

    blocTest<ToolsCubit, ToolsState>(
      'increase pixel size on zoom in',
      build: ToolsCubit.new,
      act: (cubit) => cubit.zoomIn(),
      expect: () => [ToolsState.initial().copyWith(pixelSize: 35)],
    );

    blocTest<ToolsCubit, ToolsState>(
      'decrease pixel size on zoom out',
      build: ToolsCubit.new,
      act: (cubit) => cubit.zoomOut(),
      expect: () => [ToolsState.initial().copyWith(pixelSize: 15)],
    );

    blocTest<ToolsCubit, ToolsState>(
      'changes tool on selectTool',
      build: ToolsCubit.new,
      act: (cubit) => cubit.selectTool(SpriteTool.bucket),
      expect: () => [ToolsState.initial().copyWith(tool: SpriteTool.bucket)],
    );

    blocTest<ToolsCubit, ToolsState>(
      'can toogle the grid',
      build: ToolsCubit.new,
      act: (cubit) => cubit.toogleGrid(),
      expect: () => [ToolsState.initial().copyWith(gridActive: false)],
    );
  });
}
