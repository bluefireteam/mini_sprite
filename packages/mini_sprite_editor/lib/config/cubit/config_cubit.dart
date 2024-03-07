import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'config_state.dart';

class ConfigCubit extends HydratedCubit<ConfigState> {
  ConfigCubit() : super(const ConfigState.initial());

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
      state.copyWith(
        colors: List<Color>.from(state.colors)..removeAt(index),
      ),
    );
  }

  void setGridSize(int value) {
    emit(state.copyWith(mapGridSize: value));
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
      'colors': state.colors.map((e) => e.value).toList(),
      'background_color': state.backgroundColor.value,
      'map_grid_size': state.mapGridSize,
    };
  }
}
