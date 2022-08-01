import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_sprite_editor/sprite/sprite.dart';

class ToolIntent extends Intent {
  const ToolIntent(this.tool);

  final SpriteTool tool;
}

class PageShortcuts extends StatelessWidget {
  const PageShortcuts({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SpriteCubit>();

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
      },
      child: Actions(
        actions: {
          ToolIntent: CallbackAction<ToolIntent>(
            onInvoke: (intent) {
              cubit.selectTool(intent.tool);
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
