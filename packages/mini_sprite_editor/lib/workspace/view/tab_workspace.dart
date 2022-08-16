import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_sprite_editor/workspace/workspace.dart';

class TabWorkspace extends StatelessWidget {
  const TabWorkspace({super.key});

  @override
  Widget build(BuildContext context) {
    final workspaceCubit = context.watch<WorkspaceCubit>();
    final workspaceState = workspaceCubit.state;

    return Column(
      children: [
        Row(
          children: [
            for (final panel in WorkspacePanel.values)
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
          child: IndexedStack(
            index: WorkspacePanel.values.indexOf(workspaceState.activePanel),
            children: [
              for (final panel in WorkspacePanel.values) Panel(panel: panel),
            ],
          ),
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
              SizedBox(height: 32, child: Center(child: Text(panel.name))),
              const SizedBox(width: 16),
              //IconButton(
              //  onPressed: onRemoved,
              //  icon: const Icon(Icons.close),
              //),
            ],
          ),
        ),
      ),
    );
  }
}
