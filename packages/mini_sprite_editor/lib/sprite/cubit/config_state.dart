part of 'config_cubit.dart';

class ConfigState extends Equatable {
  const ConfigState({
    required this.themeMode,
    required this.filledColor,
    required this.unfilledColor,
    required this.backgroundColor,
  });

  const ConfigState.initial()
      : this(
          themeMode: ThemeMode.system,
          filledColor: Colors.white,
          unfilledColor: Colors.transparent,
          backgroundColor: Colors.black,
        );

  final ThemeMode themeMode;
  final Color filledColor;
  final Color backgroundColor;
  final Color unfilledColor;

  ConfigState copyWith({
    ThemeMode? themeMode,
    Color? filledColor,
    Color? unfilledColor,
    Color? backgroundColor,
  }) {
    return ConfigState(
      themeMode: themeMode ?? this.themeMode,
      filledColor: filledColor ?? this.filledColor,
      unfilledColor: unfilledColor ?? this.unfilledColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  List<Object?> get props => [
        themeMode,
        filledColor,
        unfilledColor,
        backgroundColor,
      ];
}
