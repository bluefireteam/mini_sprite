// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_sprite_editor/sprite/cubit/config_cubit.dart';

void main() {
  group('ConfigState', () {
    test('can be instantiated', () {
      expect(ConfigState.initial(), isNotNull);
    });

    test('supports equality', () {
      expect(
        ConfigState(themeMode: ThemeMode.dark),
        equals(
          ConfigState(themeMode: ThemeMode.dark),
        ),
      );

      expect(
        ConfigState(themeMode: ThemeMode.dark),
        isNot(
          equals(
            ConfigState(themeMode: ThemeMode.light),
          ),
        ),
      );
    });

    test('copyWith returns a new instance with the informed value', () {
      expect(
        ConfigState(themeMode: ThemeMode.dark).copyWith(),
        equals(
          ConfigState(
            themeMode: ThemeMode.dark,
          ),
        ),
      );

      expect(
        ConfigState(themeMode: ThemeMode.dark).copyWith(
          themeMode: ThemeMode.light,
        ),
        equals(
          ConfigState(
            themeMode: ThemeMode.light,
          ),
        ),
      );
    });
  });
}
