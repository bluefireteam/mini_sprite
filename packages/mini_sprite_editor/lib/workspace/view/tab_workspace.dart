import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_sprite_editor/l10n/l10n.dart';
import 'package:mini_sprite_editor/workspace/workspace.dart';

class TabWorkspace extends StatelessWidget {
  const TabWorkspace({super.key});

  @override
  Widget build(BuildContext context) {
    final workspaceCubit = context.watch<WorkspaceCubit>();
    final workspaceState = workspaceCubit.state;

    final l10n = context.l10n;

    return Column(
      children: [
        Row(
          children: [
            PopupMenuButton<WorkspacePanel>(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: WorkspacePanel.sprite,
                  child: Text(l10n.openSpriteEditor),
                ),
                PopupMenuItem(
                  value: WorkspacePanel.map,
                  child: Text(l10n.openMapEditor),
                ),
              ],
              onSelected: workspaceCubit.openPanel,
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.menu),
              ),
            ),
            for (final panel in workspaceState.panels)
              _Tab(
                panel: panel,
                selected: panel == workspaceState.activePanel,
                onPressed: () {
                  workspaceCubit.selectPanel(panel);
                },
                onRemoved: () {
                  workspaceCubit.closePanel(panel);
                },
              ),
          ],
        ),
        Expanded(
          child: Panel(panel: workspaceState.activePanel),
        ),
      ],
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.panel,
    required this.selected,
    required this.onPressed,
    required this.onRemoved,
  });

  final WorkspacePanel panel;
  final bool selected;
  final VoidCallback onPressed;
  final VoidCallback onRemoved;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected
                    ? Theme.of(context).buttonTheme.colorScheme!.primary
                    : Colors.transparent,
              ),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Text(panel.name),
              IconButton(
                onPressed: onRemoved,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
