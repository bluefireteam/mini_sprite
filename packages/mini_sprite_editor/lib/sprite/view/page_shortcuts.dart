import 'package:flutter/foundation.dart';
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


    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.keyB): ToolIntent(
          SpriteTool.brush,
        ),
        SingleActivator(LogicalKeyboardKey.keyE): ToolIntent(
          SpriteTool.eraser,
        ),
        SingleActivator(LogicalKeyboardKey.keyF): ToolIntent(
          SpriteTool.bucket,
        ),
        SingleActivator(LogicalKeyboardKey.keyD): ToolIntent(
          SpriteTool.bucketEraser,
        ),
        SingleActivator(LogicalKeyboardKey.keyZ, meta: true):
            UndoIntent(),
        SingleActivator(LogicalKeyboardKey.keyY, meta: true):
            RedoIntent(),
      },
      child: child,
    );
  }
}


class PageActions extends StatefulWidget {
  const PageActions({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<PageActions> createState() => _PageActionsState();
}

class _PageActionsState extends State<PageActions> {

  late final  fn = FocusScopeNode(
    debugLabel: 'inside actions',
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Future.delayed(Duration(seconds: 1), (){
      fn.requestFocus();
    });
  }


  @override
  Widget build(BuildContext context) {
    final toolsCubit = context.read<ToolsCubit>();
    final spriteCubit = context.read<SpriteCubit>();
    return Actions(
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
      child: FocusScope(
        autofocus: true,
        node: fn,
        child: Focus(child: widget.child),
      ),
    );
  }
}
