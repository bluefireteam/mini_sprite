import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mini_sprite_editor/config/config.dart';
import 'package:mini_sprite_editor/l10n/l10n.dart';
import 'package:mini_sprite_editor/sprite/sprite.dart';

Future<Color?> _showColorPicker(Color color, BuildContext context) {
  Color? color0 = color;
  return showDialog<Color?>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(context.l10n.chooseColor),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: color,
              onColorChanged: (color) => color0 = color,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text(context.l10n.confirm),
              onPressed: () {
                Navigator.of(context).pop(color0);
              },
            ),
          ],
        ),
  );
}

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
    _gridFieldController =
        TextEditingController()
          ..text = context.read<ConfigCubit>().state.mapGridSize.toString();
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
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: RadioGroup<ThemeMode>(
                      groupValue: state.themeMode,
                      onChanged: (ThemeMode? value) {
                        if (value != null) {
                          cubit.setThemeMode(value);
                        }
                      },
                      child: Column(
                        children: [
                          Text(
                            l10n.themeSettings,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          ListTile(
                            title: Text(l10n.system),
                            leading: const Radio<ThemeMode>(
                              key: Key('radio_system'),
                              value: ThemeMode.system,
                            ),
                          ),
                          ListTile(
                            title: Text(l10n.dark),
                            leading: const Radio<ThemeMode>(
                              key: Key('radio_dark'),
                              value: ThemeMode.dark,
                            ),
                          ),
                          ListTile(
                            title: Text(l10n.light),
                            leading: const Radio<ThemeMode>(
                              key: Key('radio_light'),
                              value: ThemeMode.light,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.colorSettings,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        Text(l10n.palette),
                        const SizedBox(height: 8),
                        Wrap(
                          children: [
                            for (var i = 0; i < state.colors.length; i++)
                              _ColorEntry(
                                key: Key('color_entry_$i'),
                                index: i,
                                color: state.colors[i],
                                onChanged: (color) {
                                  cubit.setColor(i, color);
                                },
                                onRemove: () {
                                  cubit.removeColor(i);
                                },
                              ),
                            Tooltip(
                              message: l10n.addColor,
                              child: IconButton(
                                key: const Key('add_color_button'),
                                icon: const Icon(Icons.add),
                                onPressed: () async {
                                  final color = await _showColorPicker(
                                    Colors.white,
                                    context,
                                  );
                                  if (color != null) {
                                    cubit.addColor(color);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        _ColorTile(
                          buttonKey: const Key('background_color_key'),
                          color: state.backgroundColor,
                          label: l10n.backgroundColor,
                          onPressed: () async {
                            final color = await _showColorPicker(
                              state.backgroundColor,
                              context,
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
                          style: Theme.of(context).textTheme.titleLarge,
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
                  cubit.setGridSize(int.parse(_gridFieldController.text));
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

class _ColorEntry extends StatelessWidget {
  const _ColorEntry({
    required this.index,
    required this.color,
    required this.onChanged,
    required this.onRemove,
    super.key,
  });

  final int index;
  final Color color;
  final ValueChanged<Color> onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        final confirmaiton = await ConfirmDialog.show(context);
        if (confirmaiton ?? false) {
          onRemove();
        }
      },
      onTap: () async {
        final newColor = await _showColorPicker(color, context);
        if (newColor != null) {
          onChanged(newColor);
        }
      },
      child: ColoredBox(
        color: color,
        child: const SizedBox.square(dimension: 32),
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
          _ColorButton(key: buttonKey, color: color, onPressed: onPressed),
          const SizedBox(width: 16),
          Expanded(child: Text(label)),
        ],
      ),
    );
  }
}

class _ColorButton extends StatelessWidget {
  const _ColorButton({required this.color, required this.onPressed, super.key});

  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(child: Container(width: 32, height: 32, color: color)),
    );
  }
}
