import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'config_state.dart';

class ConfigCubit extends HydratedCubit<ConfigState> {
  ConfigCubit() : super(const ConfigState.initial());

  void setThemeMode(ThemeMode mode) {
    emit(state.copyWith(themeMode: mode));
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
    );
  }

  @override
  Map<String, dynamic>? toJson(ConfigState state) {
    return <String, dynamic>{
      'theme_mode': state.themeMode.name,
    };
  }
}