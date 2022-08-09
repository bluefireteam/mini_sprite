// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mini_sprite_editor/sprite/sprite.dart';

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
        const ConfigState(themeMode: ThemeMode.light),
      ],
    );

    test('toJson returns the state json', () {
      const state = ConfigState(themeMode: ThemeMode.dark);
      final cubit = ConfigCubit();
      final json = cubit.toJson(state);

      expect(json, equals({'theme_mode': 'dark'}));
    });

    test('fromJson returns the correct instance', () {
      final state = ConfigCubit().fromJson(
        <String, dynamic>{'theme_mode': 'dark'},
      );

      expect(
        state,
        equals(
          ConfigState(themeMode: ThemeMode.dark),
        ),
      );
    });

    test(
      'fromJson returns theme mode system when serialized has invalid value',
      () {
        final state = ConfigCubit().fromJson(
          <String, dynamic>{'theme_mode': 'bla'},
        );

        expect(
          state,
          equals(
            ConfigState(themeMode: ThemeMode.system),
          ),
        );
      },
    );
  });
}
