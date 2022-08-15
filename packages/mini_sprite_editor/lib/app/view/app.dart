import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mini_sprite_editor/config/config.dart';
import 'package:mini_sprite_editor/l10n/l10n.dart';
import 'package:mini_sprite_editor/library/library.dart';
import 'package:mini_sprite_editor/map/map.dart';
import 'package:mini_sprite_editor/sprite/sprite.dart';
import 'package:mini_sprite_editor/workspace/workspace.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ConfigCubit>(create: (_) => ConfigCubit()),
        BlocProvider<WorkspaceCubit>(create: (_) => WorkspaceCubit()),
        BlocProvider<SpriteCubit>(create: (context) => SpriteCubit()),
        BlocProvider<LibraryCubit>(create: (context) => LibraryCubit()),
        BlocProvider<MapCubit>(create: (context) => MapCubit()),
      ],
      child: BlocBuilder<ConfigCubit, ConfigState>(
        builder: (context, state) => MaterialApp(
          themeMode: state.themeMode,
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const WorkspaceView(),
        ),
      ),
    );
  }
}
