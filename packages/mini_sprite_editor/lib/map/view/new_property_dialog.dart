import 'package:flutter/material.dart';
import 'package:mini_sprite_editor/l10n/l10n.dart';

class NewPropertyDialog extends StatefulWidget {
  const NewPropertyDialog({
    super.key,
    this.name,
    this.value,
  });

  final String? name;
  final String? value;

  static Future<MapEntry<String, String>?> show(
    BuildContext context, {
    String? name,
    String? value,
  }) {
    return showDialog<MapEntry<String, String>?>(
      context: context,
      builder: (_) {
        return NewPropertyDialog(name: name, value: value);
      },
    );
  }

  @override
  State<NewPropertyDialog> createState() => _NewPropertyDialogState();
}

class _NewPropertyDialogState extends State<NewPropertyDialog> {
  late TextEditingController _nameController;
  late TextEditingController _valueController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController()..text = widget.name ?? '';
    _valueController = TextEditingController()..text = widget.value ?? '';
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
              l10n.newPropery,
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 180,
              child: TextField(
                autofocus: true,
                key: const Key('new_property_name_field'),
                decoration: InputDecoration(
                  label: Text(l10n.name),
                ),
                textAlign: TextAlign.center,
                controller: _nameController,
                enabled: _nameController.text.isEmpty,
              ),
            ),
            SizedBox(
              width: 180,
              child: TextField(
                autofocus: true,
                key: const Key('new_property_value_field'),
                decoration: InputDecoration(
                  label: Text(l10n.value),
                ),
                textAlign: TextAlign.center,
                controller: _valueController,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(null);
                  },
                  child: Text(l10n.cancel),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(
                      _valueController.text.isEmpty
                          ? null
                          : MapEntry(
                              _nameController.text,
                              _valueController.text,
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
