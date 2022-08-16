import 'package:flutter/material.dart';
import 'package:mini_sprite_editor/workspace/workspace.dart';

class WorkspaceView extends StatelessWidget {
  const WorkspaceView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: TabWorkspace(),
    );
  }
}
