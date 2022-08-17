import 'package:flutter/material.dart';
import 'package:mini_sprite_editor/map/map.dart';
import 'package:mini_sprite_editor/sprite/sprite.dart';
import 'package:mini_sprite_editor/workspace/workspace.dart';

class Panel extends StatelessWidget {
  const Panel({super.key, required this.panel});

  final WorkspacePanel panel;

  @override
  Widget build(BuildContext context) {
    return const SpritePage();
    switch (panel) {
      case WorkspacePanel.sprite:
        return const SpritePage();
      case WorkspacePanel.map:
        return const MapPage();
    }
  }
}
