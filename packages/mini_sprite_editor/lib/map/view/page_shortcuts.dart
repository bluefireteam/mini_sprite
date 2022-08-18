import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_sprite_editor/map/map.dart';
import 'package:mini_sprite_editor/workspace/panel_focus.dart';

class ToolIntent extends Intent {
  const ToolIntent(this.tool);

  final MapTool tool;
}

class UndoIntent extends Intent {
  const UndoIntent();
}

class RedoIntent extends Intent {
  const RedoIntent();
}

class MapPageShortcuts extends StatelessWidget {
  const MapPageShortcuts({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final toolsCubit = context.read<MapToolCubit>();
    final spriteCubit = context.read<MapCubit>();

    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.keyB): const ToolIntent(
          MapTool.brush,
        ),
        LogicalKeySet(LogicalKeyboardKey.keyE): const ToolIntent(
          MapTool.eraser,
        ),
        LogicalKeySet(LogicalKeyboardKey.keyC): const ToolIntent(
          MapTool.none,
        ),
        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyZ):
            const UndoIntent(),
        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyY):
            const RedoIntent(),
      },
      child: Actions(
        actions: {
          ToolIntent: CallbackAction<ToolIntent>(
            onInvoke: (intent) {
              toolsCubit.selectTool(intent.tool);
              return null;
            },
          ),
          UndoIntent: CallbackAction<UndoIntent>(
            onInvoke: (intent) {
              spriteCubit.undo();
              return null;
            },
          ),
          RedoIntent: CallbackAction<RedoIntent>(
            onInvoke: (intent) {
              spriteCubit.redo();
              return null;
            },
          ),
        },
        child: PanelFocus(
          child: child,
        ),
      ),
    );
  }
}
