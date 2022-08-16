import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'config_state.dart';

class ConfigCubit extends HydratedCubit<ConfigState> {
  ConfigCubit() : super(const ConfigState.initial());

  void setThemeMode(ThemeMode mode) {
    emit(state.copyWith(themeMode: mode));
  }

  void setFilledColor(Color color) {
    emit(state.copyWith(filledColor: color));
  }

  void setUnfilledColor(Color color) {
    emit(state.copyWith(unfilledColor: color));
  }

  void setBackgroundColor(Color color) {
    emit(state.copyWith(backgroundColor: color));
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

    return ConfigState(
      themeMode: themeMode,
      filledColor: Color(json['filled_color'] as int),
      unfilledColor: Color(json['unfilled_color'] as int),
      backgroundColor: Color(json['background_color'] as int),
      mapGridSize: json['map_grid_size'] as int,
    );
  }

  @override
  Map<String, dynamic>? toJson(ConfigState state) {
    return <String, dynamic>{
      'theme_mode': state.themeMode.name,
      'filled_color': state.filledColor.value,
      'unfilled_color': state.unfilledColor.value,
      'background_color': state.backgroundColor.value,
      'map_grid_size': state.mapGridSize,
    };
  }
}
