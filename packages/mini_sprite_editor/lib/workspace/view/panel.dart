import 'package:flutter/material.dart';
import 'package:mini_sprite_editor/map/map.dart';
import 'package:mini_sprite_editor/sprite/sprite.dart';
import 'package:mini_sprite_editor/workspace/workspace.dart';

class Panel extends StatelessWidget {
  const Panel({
    super.key,
    required this.panel,
    required this.isActive,
  });

  final WorkspacePanel panel;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isActive,
      maintainState: true,
      child: FocusScope(
        canRequestFocus: isActive,
        child: Builder(
          builder: (context) {
            switch (panel) {
              case WorkspacePanel.sprite:
                return const SpritePage();
              case WorkspacePanel.map:
                return const MapPage();
            }
          },
        ),
      ),
    );
  }
}
