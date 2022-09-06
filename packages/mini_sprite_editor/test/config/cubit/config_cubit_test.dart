// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mini_sprite_editor/config/config.dart';

import '../../helpers/helpers.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = MockHydratedStorage();

  group('ConfigCubit', () {
    test('can be instantiated', () {
      expect(ConfigCubit(), isNotNull);
    });

    blocTest<ConfigCubit, ConfigState>(
      'setThemeMode changes the themeMode',
      build: ConfigCubit.new,
      act: (cubit) {
        cubit.setThemeMode(ThemeMode.light);
      },
      expect: () => [
        const ConfigState.initial().copyWith(themeMode: ThemeMode.light),
      ],
    );

    blocTest<ConfigCubit, ConfigState>(
      'setFilledColor',
      build: ConfigCubit.new,
      act: (cubit) {
        cubit.setFilledColor(Colors.red);
      },
      expect: () => [
        const ConfigState.initial().copyWith(filledColor: Colors.red),
      ],
    );

    blocTest<ConfigCubit, ConfigState>(
      'setUnfilledColor',
      build: ConfigCubit.new,
      act: (cubit) {
        cubit.setUnfilledColor(Colors.red);
      },
      expect: () => [
        const ConfigState.initial().copyWith(unfilledColor: Colors.red),
      ],
    );

    blocTest<ConfigCubit, ConfigState>(
      'setBackgroundColor',
      build: ConfigCubit.new,
      act: (cubit) {
        cubit.setBackgroundColor(Colors.red);
      },
      expect: () => [
        const ConfigState.initial().copyWith(backgroundColor: Colors.red),
      ],
    );

    blocTest<ConfigCubit, ConfigState>(
      'setGridSize',
      build: ConfigCubit.new,
      act: (cubit) {
        cubit.setGridSize(20);
      },
      expect: () => [
        const ConfigState.initial().copyWith(mapGridSize: 20),
      ],
    );

    test('toJson returns the state json', () {
      final state = ConfigState.initial().copyWith(themeMode: ThemeMode.dark);
      final cubit = ConfigCubit();
      final json = cubit.toJson(state);

      expect(
        json,
        equals(
          {
            'theme_mode': 'dark',
            'filled_color': state.filledColor.value,
            'unfilled_color': state.unfilledColor.value,
            'background_color': state.backgroundColor.value,
            'map_grid_size': state.mapGridSize,
          },
        ),
      );
    });

    test('fromJson returns the correct instance', () {
      final state = ConfigCubit().fromJson(
        <String, dynamic>{
          'theme_mode': 'dark',
          'filled_color': Colors.white.value,
          'unfilled_color': Colors.transparent.value,
          'background_color': Colors.black.value,
          'map_grid_size': 16,
        },
      );

      expect(
        state,
        equals(
          ConfigState(
            themeMode: ThemeMode.dark,
            filledColor: Colors.white,
            unfilledColor: Colors.transparent,
            backgroundColor: Colors.black,
            mapGridSize: 16,
          ),
        ),
      );
    });

    test(
      'fromJson returns theme mode system when serialized has invalid value',
      () {
        final state = ConfigCubit().fromJson(
          <String, dynamic>{
            'theme_mode': 'bla',
            'filled_color': Colors.white.value,
            'unfilled_color': Colors.transparent.value,
            'background_color': Colors.black.value,
            'map_grid_size': 16,
          },
        );

        expect(
          state,
          equals(
            ConfigState(
              themeMode: ThemeMode.system,
              filledColor: Colors.white,
              unfilledColor: Colors.transparent,
              backgroundColor: Colors.black,
              mapGridSize: 16,
            ),
          ),
        );
      },
    );
  });
}
