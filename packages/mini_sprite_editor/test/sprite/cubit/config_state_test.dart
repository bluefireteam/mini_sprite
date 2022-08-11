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
        ConfigState(
          themeMode: ThemeMode.dark,
          filledColor: Colors.white,
          unfilledColor: Colors.transparent,
          backgroundColor: Colors.black,
        ),
        equals(
          ConfigState(
            themeMode: ThemeMode.dark,
            filledColor: Colors.white,
            unfilledColor: Colors.transparent,
            backgroundColor: Colors.black,
          ),
        ),
      );

      expect(
        ConfigState(
          themeMode: ThemeMode.dark,
          filledColor: Colors.white,
          unfilledColor: Colors.transparent,
          backgroundColor: Colors.black,
        ),
        isNot(
          equals(
            ConfigState(
              themeMode: ThemeMode.light,
              filledColor: Colors.white,
              unfilledColor: Colors.transparent,
              backgroundColor: Colors.black,
            ),
          ),
        ),
      );

      expect(
        ConfigState(
          themeMode: ThemeMode.dark,
          filledColor: Colors.red,
          unfilledColor: Colors.transparent,
          backgroundColor: Colors.black,
        ),
        isNot(
          equals(
            ConfigState(
              themeMode: ThemeMode.light,
              filledColor: Colors.white,
              unfilledColor: Colors.transparent,
              backgroundColor: Colors.black,
            ),
          ),
        ),
      );

      expect(
        ConfigState(
          themeMode: ThemeMode.dark,
          filledColor: Colors.white,
          unfilledColor: Colors.red,
          backgroundColor: Colors.black,
        ),
        isNot(
          equals(
            ConfigState(
              themeMode: ThemeMode.light,
              filledColor: Colors.white,
              unfilledColor: Colors.transparent,
              backgroundColor: Colors.black,
            ),
          ),
        ),
      );

      expect(
        ConfigState(
          themeMode: ThemeMode.dark,
          filledColor: Colors.white,
          unfilledColor: Colors.transparent,
          backgroundColor: Colors.red,
        ),
        isNot(
          equals(
            ConfigState(
              themeMode: ThemeMode.light,
              filledColor: Colors.white,
              unfilledColor: Colors.transparent,
              backgroundColor: Colors.black,
            ),
          ),
        ),
      );
    });

    test('copyWith returns a new instance with the informed value', () {
      expect(
        ConfigState(
          themeMode: ThemeMode.dark,
          filledColor: Colors.white,
          unfilledColor: Colors.transparent,
          backgroundColor: Colors.black,
        ).copyWith(),
        equals(
          ConfigState(
            themeMode: ThemeMode.dark,
            filledColor: Colors.white,
            unfilledColor: Colors.transparent,
            backgroundColor: Colors.black,
          ),
        ),
      );

      expect(
        ConfigState(
          themeMode: ThemeMode.dark,
          filledColor: Colors.white,
          unfilledColor: Colors.transparent,
          backgroundColor: Colors.black,
        ).copyWith(
          themeMode: ThemeMode.light,
        ),
        equals(
          ConfigState(
            themeMode: ThemeMode.light,
            filledColor: Colors.white,
            unfilledColor: Colors.transparent,
            backgroundColor: Colors.black,
          ),
        ),
      );

      expect(
        ConfigState(
          themeMode: ThemeMode.dark,
          filledColor: Colors.white,
          unfilledColor: Colors.transparent,
          backgroundColor: Colors.black,
        ).copyWith(
          filledColor: Colors.red,
        ),
        equals(
          ConfigState(
            themeMode: ThemeMode.dark,
            filledColor: Colors.red,
            unfilledColor: Colors.transparent,
            backgroundColor: Colors.black,
          ),
        ),
      );

      expect(
        ConfigState(
          themeMode: ThemeMode.dark,
          filledColor: Colors.white,
          unfilledColor: Colors.transparent,
          backgroundColor: Colors.black,
        ).copyWith(
          unfilledColor: Colors.red,
        ),
        equals(
          ConfigState(
            themeMode: ThemeMode.dark,
            filledColor: Colors.white,
            unfilledColor: Colors.red,
            backgroundColor: Colors.black,
          ),
        ),
      );

      expect(
        ConfigState(
          themeMode: ThemeMode.dark,
          filledColor: Colors.white,
          unfilledColor: Colors.transparent,
          backgroundColor: Colors.black,
        ).copyWith(
          backgroundColor: Colors.red,
        ),
        equals(
          ConfigState(
            themeMode: ThemeMode.dark,
            filledColor: Colors.white,
            unfilledColor: Colors.transparent,
            backgroundColor: Colors.red,
          ),
        ),
      );
    });
  });
}
