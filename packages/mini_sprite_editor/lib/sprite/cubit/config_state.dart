part of 'config_cubit.dart';

class ConfigState extends Equatable {
  const ConfigState({
    required this.themeMode,
  });

  const ConfigState.initial() : this(themeMode: ThemeMode.system);

  final ThemeMode themeMode;

  ConfigState copyWith({
    ThemeMode? themeMode,
  }) {
    return ConfigState(
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object?> get props => [themeMode];
}
