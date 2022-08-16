part of 'config_cubit.dart';

class ConfigState extends Equatable {
  const ConfigState({
    required this.themeMode,
    required this.filledColor,
    required this.unfilledColor,
    required this.backgroundColor,
    required this.mapGridSize,
  });

  const ConfigState.initial()
      : this(
          themeMode: ThemeMode.system,
          filledColor: Colors.white,
          unfilledColor: Colors.transparent,
          backgroundColor: Colors.black,
          mapGridSize: 16,
        );

  final ThemeMode themeMode;
  final Color filledColor;
  final Color backgroundColor;
  final Color unfilledColor;
  final int mapGridSize;

  ConfigState copyWith({
    ThemeMode? themeMode,
    Color? filledColor,
    Color? unfilledColor,
    Color? backgroundColor,
    int? mapGridSize,
  }) {
    return ConfigState(
      themeMode: themeMode ?? this.themeMode,
      filledColor: filledColor ?? this.filledColor,
      unfilledColor: unfilledColor ?? this.unfilledColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      mapGridSize: mapGridSize ?? this.mapGridSize,
    );
  }

  @override
  List<Object?> get props => [
        themeMode,
        filledColor,
        unfilledColor,
        backgroundColor,
        mapGridSize,
      ];
}
