import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mini_sprite_editor/hub/view/hub_page.dart';
import 'package:mini_sprite_editor/map/map.dart';
import 'package:mini_sprite_editor/sprite/sprite.dart';
import 'package:mini_sprite_editor/workspace/workspace.dart';

class Panel extends StatefulWidget {
  const Panel({
    super.key,
    required this.panel,
    required this.isActive,
  });

  final WorkspacePanel panel;
  final bool isActive;

  @override
  State<Panel> createState() => _PanelState();
}

class _PanelState extends State<Panel> {
  late final FocusScopeNode focusScopeNode = FocusScopeNode();

  @override
  void didUpdateWidget(Panel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!oldWidget.isActive && widget.isActive) {
      scheduleMicrotask(() {
        if (mounted) {
          focusScopeNode.requestFocus();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isActive,
      maintainState: true,
      child: FocusScope(
        canRequestFocus: widget.isActive,
        node: focusScopeNode,
        child: Builder(
          builder: (context) {
            switch (widget.panel) {
              case WorkspacePanel.sprite:
                return const SpritePage();
              case WorkspacePanel.map:
                return const MapPage();
              case WorkspacePanel.hub:
                return const HubPage();
            }
          },
        ),
      ),
    );
  }
}
