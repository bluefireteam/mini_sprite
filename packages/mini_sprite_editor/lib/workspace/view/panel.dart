import 'package:flutter/material.dart';
import 'package:mini_sprite_editor/sprite/sprite.dart';
import 'package:mini_sprite_editor/workspace/workspace.dart';

class Panel extends StatelessWidget {
  const Panel({super.key, required this.panel});

  final WorkspacePanel panel;

  @override
  Widget build(BuildContext context) {
    switch (panel) {
      case WorkspacePanel.sprite:
        return const SpritePage();
      case WorkspacePanel.map:
        return const SizedBox();
      case WorkspacePanel.none:
        return const SizedBox();
    }
  }
}
