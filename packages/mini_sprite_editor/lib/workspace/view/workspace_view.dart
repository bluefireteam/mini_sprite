import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_sprite_editor/workspace/workspace.dart';

class WorkspaceView extends StatelessWidget {
  const WorkspaceView({super.key});

  @override
  Widget build(BuildContext context) {
    final workspaceCubit = context.watch<WorkspaceCubit>();
    final workspaceState = workspaceCubit.state;

    return Scaffold(
      body: workspaceState.panels.isEmpty
          ? const InitialPanel()
          : const TabWorkspace(),
    );
  }
}
