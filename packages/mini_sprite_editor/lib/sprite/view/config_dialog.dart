import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_sprite_editor/l10n/l10n.dart';
import 'package:mini_sprite_editor/sprite/sprite.dart';

class ConfigDialog extends StatefulWidget {
  const ConfigDialog({super.key});

  static Future<Offset?> show(BuildContext context) {
    return showDialog<Offset?>(
      context: context,
      builder: (_) {
        return BlocProvider<ConfigCubit>.value(
          value: context.read<ConfigCubit>(),
          child: const ConfigDialog(),
        );
      },
    );
  }

  @override
  State<ConfigDialog> createState() => _ConfigDialogState();
}

class _ConfigDialogState extends State<ConfigDialog> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final cubit = context.watch<ConfigCubit>();
    final state = cubit.state;

    return Dialog(
      child: SizedBox(
        width: 250,
        height: 450,
        child: Column(
          children: [
            const SizedBox(width: 16),
            Text(
              l10n.configurations,
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(l10n.system),
                      leading: Radio<ThemeMode>(
                        key: const Key('radio_system'),
                        value: ThemeMode.system,
                        groupValue: state.themeMode,
                        onChanged: (ThemeMode? value) {
                          if (value != null) {
                            cubit.setThemeMode(value);
                          }
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(l10n.dark),
                      leading: Radio<ThemeMode>(
                        key: const Key('radio_dark'),
                        value: ThemeMode.dark,
                        groupValue: state.themeMode,
                        onChanged: (ThemeMode? value) {
                          if (value != null) {
                            cubit.setThemeMode(value);
                          }
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(l10n.light),
                      leading: Radio<ThemeMode>(
                        key: const Key('radio_light'),
                        value: ThemeMode.light,
                        groupValue: state.themeMode,
                        onChanged: (ThemeMode? value) {
                          if (value != null) {
                            cubit.setThemeMode(value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(l10n.close),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
