import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'config_state.dart';

class ConfigCubit extends HydratedCubit<ConfigState> {
  ConfigCubit({
    Future<void> Function(ClipboardData)? setClipboardData,
  }) : _setClipboardData = setClipboardData ?? Clipboard.setData,
       super(const ConfigState.initial());

  final Future<void> Function(ClipboardData) _setClipboardData;

  void setThemeMode(ThemeMode mode) {
    emit(state.copyWith(themeMode: mode));
  }

  void setBackgroundColor(Color color) {
    emit(state.copyWith(backgroundColor: color));
  }

  void setColors(List<Color> colors) {
    emit(state.copyWith(colors: colors));
  }

  void setColor(int index, Color color) {
    final colors = List<Color>.from(state.colors);
    colors[index] = color;
    emit(state.copyWith(colors: colors));
  }

  void addColor(Color color) {
    emit(state.copyWith(colors: List<Color>.from(state.colors)..add(color)));
  }

  void removeColor(int index) {
    emit(
      state.copyWith(colors: List<Color>.from(state.colors)..removeAt(index)),
    );
  }

  void setGridSize(int value) {
    emit(state.copyWith(mapGridSize: value));
  }

  void copyPaletteToClipboard() {
    final colorsInHex = state.colors
        .map((e) => e.toARGB32().toRadixString(16).padLeft(8, '0'))
        .join('\n');
    unawaited(_setClipboardData(ClipboardData(text: colorsInHex)));
  }

  @override
  ConfigState? fromJson(Map<String, dynamic> json) {
    final themeModeRaw = json['theme_mode'] as String?;
    final themeMode = ThemeMode.values.firstWhere(
      (ThemeMode mode) => mode.name == themeModeRaw,
      orElse: () => ThemeMode.system,
    );

    final oldFilledValue = json['filled_color'];
    final oldUnfilledValue = json['unfilled_color'];

    late List<Color> colors;

    if (oldFilledValue != null && oldUnfilledValue != null) {
      colors = [Color(oldFilledValue as int), Color(oldUnfilledValue as int)];
    } else {
      colors = (json['colors'] as List).map((e) => Color(e as int)).toList();
    }

    return ConfigState(
      themeMode: themeMode,
      colors: colors,
      backgroundColor: Color(json['background_color'] as int),
      mapGridSize: json['map_grid_size'] as int,
    );
  }

  @override
  Map<String, dynamic>? toJson(ConfigState state) {
    return <String, dynamic>{
      'theme_mode': state.themeMode.name,
      'colors': state.colors.map((e) => e.toARGB32()).toList(),
      'background_color': state.backgroundColor.toARGB32(),
      'map_grid_size': state.mapGridSize,
    };
  }
}
