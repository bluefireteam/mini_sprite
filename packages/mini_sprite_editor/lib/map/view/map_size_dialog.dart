import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_sprite_editor/l10n/l10n.dart';
import 'package:mini_sprite_editor/map/map.dart';

class MapSizeDialog extends StatefulWidget {
  const MapSizeDialog({super.key});

  static Future<Offset?> show(BuildContext context) {
    return showDialog<Offset?>(
      context: context,
      builder: (_) {
        return BlocProvider<MapCubit>.value(
          value: context.read<MapCubit>(),
          child: const MapSizeDialog(),
        );
      },
    );
  }

  @override
  State<MapSizeDialog> createState() => _MapSizeDialogState();
}

class _MapSizeDialogState extends State<MapSizeDialog> {
  late TextEditingController _widthController;
  late TextEditingController _heightController;

  @override
  void initState() {
    super.initState();

    final state = context.read<MapCubit>().state;
    _widthController =
        TextEditingController()..text = state.mapSize.width.toInt().toString();
    _heightController =
        TextEditingController()..text = state.mapSize.height.toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Dialog(
      child: SizedBox(
        width: 150,
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.mapSizeTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(width: 8),
            Row(
              children: [
                const SizedBox(width: 50),
                Expanded(
                  child: TextField(
                    autofocus: true,
                    key: const Key('width_text_field_key'),
                    decoration: InputDecoration(label: Text(l10n.width)),
                    textAlign: TextAlign.center,
                    controller: _widthController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                const SizedBox(width: 50),
                Expanded(
                  child: TextField(
                    key: const Key('height_text_field_key'),
                    decoration: InputDecoration(label: Text(l10n.height)),
                    textAlign: TextAlign.center,
                    controller: _heightController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                const SizedBox(width: 50),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(l10n.cancel),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(
                      Offset(
                        double.parse(_widthController.text),
                        double.parse(_heightController.text),
                      ),
                    );
                  },
                  child: Text(l10n.confirm),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
