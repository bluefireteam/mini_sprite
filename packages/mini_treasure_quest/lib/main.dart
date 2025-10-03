import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_treasure_quest/assets.dart';
import 'package:mini_treasure_quest/title/title.dart';

ThemeData _buildTheme(Brightness brightness) {
  final baseTheme = ThemeData(
    brightness: brightness,
    scaffoldBackgroundColor: Colors.black,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.black,
      onPrimary: Colors.white,
      secondary: Colors.black,
      onSecondary: Colors.black,
      error: Colors.red,
      onError: Colors.red,
      surface: Colors.black87,
      onSurface: Colors.black87,
    ),
    cardTheme: CardThemeData(
      color: Colors.black,
      elevation: 2,
      shape: Border.all(
        color: Colors.white,
        width: 4,
      ),
    ),
  );

  return baseTheme.copyWith(
    primaryColor: Colors.white,
    textTheme: GoogleFonts.pressStart2pTextTheme(baseTheme.textTheme).apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  await Assets.instance.load();

  runApp(
    MaterialApp(
      theme: _buildTheme(Brightness.dark),
      home: const TitleView(),
      shortcuts: {
        ...WidgetsApp.defaultShortcuts,
        const SingleActivator(LogicalKeyboardKey.arrowRight):
            const NextFocusIntent(),
        const SingleActivator(LogicalKeyboardKey.arrowLeft):
            const PreviousFocusIntent(),
        const SingleActivator(LogicalKeyboardKey.arrowDown):
            const NextFocusIntent(),
        const SingleActivator(LogicalKeyboardKey.arrowUp):
            const PreviousFocusIntent(),
      },
    ),
  );
}
