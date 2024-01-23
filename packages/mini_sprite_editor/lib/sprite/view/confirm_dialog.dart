import 'package:flutter/material.dart';
import 'package:mini_sprite_editor/l10n/l10n.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool?>(
      context: context,
      builder: (_) => const ConfirmDialog(),
    );
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
              l10n.confirmation,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(width: 8),
            Text(
              l10n.confirmationMessage,
            ),
            const SizedBox(height: 32),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(l10n.cancel),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
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
