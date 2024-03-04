// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_sprite_editor/config/config.dart';

void main() {
  group('ConfigState', () {
    test('can be instantiated', () {
      expect(ConfigState.initial(), isNotNull);
    });

    test('supports equality', () {
      expect(
        ConfigState(
          themeMode: ThemeMode.dark,
          colors: const [Colors.white, Colors.transparent],
          backgroundColor: Colors.black,
          mapGridSize: 16,
        ),
        equals(
          ConfigState(
            themeMode: ThemeMode.dark,
            colors: const [Colors.white,  Colors.transparent],
            backgroundColor: Colors.black,
            mapGridSize: 16,
          ),
        ),
      );

      expect(
        ConfigState(
          themeMode: ThemeMode.dark,
          colors: const [Colors.white,  Colors.transparent],
          backgroundColor: Colors.black,
          mapGridSize: 16,
        ),
        isNot(
          equals(
            ConfigState(
              themeMode: ThemeMode.light,
              colors: const [Colors.white, Colors.transparent],
              backgroundColor: Colors.black,
              mapGridSize: 16,
            ),
          ),
        ),
      );

      expect(
        ConfigState(
          themeMode: ThemeMode.dark,
          colors: const [Colors.red, Colors.transparent],
          backgroundColor: Colors.black,
          mapGridSize: 16,
        ),
        isNot(
          equals(
            ConfigState(
              themeMode: ThemeMode.light,
              colors: const [Colors.white, Colors.transparent],
              backgroundColor: Colors.black,
              mapGridSize: 16,
            ),
          ),
        ),
      );

      expect(
        ConfigState(
          themeMode: ThemeMode.dark,
          colors: const [Colors.white,  Colors.red],
          backgroundColor: Colors.black,
          mapGridSize: 16,
        ),
        isNot(
          equals(
            ConfigState(
              themeMode: ThemeMode.light,
              colors: const [Colors.white, Colors.transparent],
              backgroundColor: Colors.black,
              mapGridSize: 16,
            ),
          ),
        ),
      );

      expect(
        ConfigState(
          themeMode: ThemeMode.dark,
          colors: const [Colors.white, Colors.transparent],
          backgroundColor: Colors.red,
          mapGridSize: 16,
        ),
        isNot(
          equals(
            ConfigState(
              themeMode: ThemeMode.light,
              colors: const [Colors.white, Colors.transparent],
              backgroundColor: Colors.black,
              mapGridSize: 16,
            ),
          ),
        ),
      );
    });

    test('copyWith returns a new instance with the informed value', () {
      expect(
        ConfigState(
          themeMode: ThemeMode.dark,
          colors: const [Colors.white, Colors.transparent],
          backgroundColor: Colors.black,
          mapGridSize: 16,
        ).copyWith(),
        equals(
          ConfigState(
            themeMode: ThemeMode.dark,
            colors: const [Colors.white, Colors.transparent],
            backgroundColor: Colors.black,
            mapGridSize: 16,
          ),
        ),
      );

      expect(
        ConfigState(
          themeMode: ThemeMode.dark,
          colors: const [Colors.white, Colors.transparent],
          backgroundColor: Colors.black,
          mapGridSize: 16,
        ).copyWith(
          themeMode: ThemeMode.light,
        ),
        equals(
          ConfigState(
            themeMode: ThemeMode.light,
            colors: const [Colors.white, Colors.transparent],
            backgroundColor: Colors.black,
            mapGridSize: 16,
          ),
        ),
      );

      expect(
        ConfigState(
          themeMode: ThemeMode.dark,
          colors: const [Colors.white, Colors.transparent],
          backgroundColor: Colors.black,
          mapGridSize: 16,
        ).copyWith(
          colors: const [Colors.red],
        ),
        equals(
          ConfigState(
            themeMode: ThemeMode.dark,
            colors: const [Colors.red],
            backgroundColor: Colors.black,
            mapGridSize: 16,
          ),
        ),
      );

      expect(
        ConfigState(
          themeMode: ThemeMode.dark,
          colors: const [Colors.white, Colors.transparent],
          backgroundColor: Colors.black,
          mapGridSize: 16,
        ).copyWith(
          backgroundColor: Colors.red,
        ),
        equals(
          ConfigState(
            themeMode: ThemeMode.dark,
            colors: const [Colors.white, Colors.transparent],
            backgroundColor: Colors.red,
            mapGridSize: 16,
          ),
        ),
      );
    });
  });
}
