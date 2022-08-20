import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mini_sprite_editor/config/config.dart';
import 'package:mini_sprite_editor/l10n/l10n.dart';

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
  late final TextEditingController _gridFieldController;

  @override
  void initState() {
    super.initState();
    _gridFieldController = TextEditingController()
      ..text = context.read<ConfigCubit>().state.mapGridSize.toString();
  }

  Future<Color?> _showColorPicker(Color color) {
    Color? _color = color;
    return showDialog<Color?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.chooseColor),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: color,
            onColorChanged: (color) => _color = color,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text(context.l10n.confirm),
            onPressed: () {
              Navigator.of(context).pop(_color);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final cubit = context.watch<ConfigCubit>();
    final state = cubit.state;

    return Dialog(
      child: SizedBox(
        width: 650,
        height: 450,
        child: Column(
          children: [
            const SizedBox(height: 32),
            Text(
              l10n.configurations,
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          l10n.themeSettings,
                          style: Theme.of(context).textTheme.headline6,
                        ),
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
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          l10n.colorSettings,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        _ColorTile(
                          buttonKey: const Key('filled_color_key'),
                          color: state.filledColor,
                          label: l10n.filledPixelColor,
                          onPressed: () async {
                            final color =
                                await _showColorPicker(state.filledColor);
                            if (color != null) {
                              cubit.setFilledColor(color);
                            }
                          },
                        ),
                        _ColorTile(
                          buttonKey: const Key('unfilled_color_key'),
                          color: state.unfilledColor,
                          label: l10n.unfilledPixelColor,
                          onPressed: () async {
                            final color = await _showColorPicker(
                              state.unfilledColor,
                            );
                            if (color != null) {
                              cubit.setUnfilledColor(color);
                            }
                          },
                        ),
                        _ColorTile(
                          buttonKey: const Key('background_color_key'),
                          color: state.backgroundColor,
                          label: l10n.backgroundColor,
                          onPressed: () async {
                            final color = await _showColorPicker(
                              state.backgroundColor,
                            );
                            if (color != null) {
                              cubit.setBackgroundColor(color);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          l10n.mapSettings,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextField(
                            controller: _gridFieldController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              labelText: l10n.mapGridSize,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  cubit.setGridSize(
                    int.parse(_gridFieldController.text),
                  );
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

class _ColorTile extends StatelessWidget {
  const _ColorTile({
    required this.color,
    required this.label,
    required this.onPressed,
    this.buttonKey,
  });

  final Color color;
  final VoidCallback onPressed;
  final String label;
  final Key? buttonKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16),
      child: Row(
        children: [
          _ColorButton(
            key: buttonKey,
            color: color,
            onPressed: onPressed,
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(label)),
        ],
      ),
    );
  }
}

class _ColorButton extends StatelessWidget {
  const _ColorButton({
    super.key,
    required this.color,
    required this.onPressed,
  });

  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        child: Container(
          width: 32,
          height: 32,
          color: color,
        ),
      ),
    );
  }
}
