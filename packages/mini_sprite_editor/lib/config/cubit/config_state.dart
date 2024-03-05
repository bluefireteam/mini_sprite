part of 'config_cubit.dart';

class ConfigState extends Equatable {
  const ConfigState({
    required this.themeMode,
    required this.colors,
    required this.backgroundColor,
    required this.mapGridSize,
  });

  const ConfigState.initial()
      : this(
          themeMode: ThemeMode.system,
          colors: const [Colors.black, Colors.white],
          backgroundColor: Colors.transparent,
          mapGridSize: 16,
        );

  final ThemeMode themeMode;
  final List<Color> colors;
  final Color backgroundColor;
  final int mapGridSize;

  ConfigState copyWith({
    ThemeMode? themeMode,
    List<Color>? colors,
    Color? backgroundColor,
    int? mapGridSize,
  }) {
    return ConfigState(
      themeMode: themeMode ?? this.themeMode,
      colors: colors ?? this.colors,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      mapGridSize: mapGridSize ?? this.mapGridSize,
    );
  }

  @override
  List<Object?> get props => [
        themeMode,
        colors,
        backgroundColor,
        mapGridSize,
      ];
}
