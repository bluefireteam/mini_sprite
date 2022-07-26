import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_sprite_editor/sprite/cubit/tools_cubit.dart';
import 'package:mini_sprite_editor/sprite/sprite.dart';

class ToolIntent extends Intent {
  const ToolIntent(this.tool);

  final SpriteTool tool;
}

class UndoIntent extends Intent {
  const UndoIntent();
}

class RedoIntent extends Intent {
  const RedoIntent();
}

class PageShortcuts extends StatelessWidget {
  const PageShortcuts({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final toolsCubit = context.read<ToolsCubit>();
    final spriteCubit = context.read<SpriteCubit>();

    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.keyB): const ToolIntent(
          SpriteTool.brush,
        ),
        LogicalKeySet(LogicalKeyboardKey.keyE): const ToolIntent(
          SpriteTool.eraser,
        ),
        LogicalKeySet(LogicalKeyboardKey.keyF): const ToolIntent(
          SpriteTool.bucket,
        ),
        LogicalKeySet(LogicalKeyboardKey.keyD): const ToolIntent(
          SpriteTool.bucketEraser,
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
        child: Focus(
          autofocus: true,
          child: child,
        ),
      ),
    );
  }
}
