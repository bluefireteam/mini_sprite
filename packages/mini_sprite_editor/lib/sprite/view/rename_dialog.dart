import 'package:flutter/material.dart';
import 'package:mini_sprite_editor/l10n/l10n.dart';

class RenameDialog extends StatefulWidget {
  const RenameDialog({super.key, required this.name});

  final String name;

  static Future<String?> show(BuildContext context, String name) {
    return showDialog<String?>(
      context: context,
      builder: (_) {
        return RenameDialog(name: name);
      },
    );
  }

  @override
  State<RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<RenameDialog> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();

    _textController = TextEditingController()..text = widget.name;
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
              l10n.renameSprite,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 180,
              child: TextField(
                autofocus: true,
                key: const Key('rename_sprite_field_key'),
                decoration: InputDecoration(
                  label: Text(l10n.renameSpriteMessage),
                ),
                textAlign: TextAlign.center,
                controller: _textController,
              ),
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
                    Navigator.of(context).pop(_textController.text);
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
