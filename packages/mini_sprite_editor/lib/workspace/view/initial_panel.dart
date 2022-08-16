import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_sprite_editor/l10n/l10n.dart';
import 'package:mini_sprite_editor/workspace/workspace.dart';

class InitialPanel extends StatelessWidget {
  const InitialPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            child: SizedBox(
              width: 100,
              height: 100,
              child: IconButton(
                onPressed: () {
                  context.read<WorkspaceCubit>().openPanel(
                        WorkspacePanel.sprite,
                      );
                },
                tooltip: l10n.openSpriteEditor,
                icon: const Icon(Icons.brush),
              ),
            ),
          ),
          const SizedBox(width: 32),
          Card(
            child: SizedBox(
              width: 100,
              height: 100,
              child: IconButton(
                onPressed: () {
                  context.read<WorkspaceCubit>().openPanel(
                        WorkspacePanel.map,
                      );
                },
                tooltip: l10n.openMapEditor,
                icon: const Icon(Icons.map),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
