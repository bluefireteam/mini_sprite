import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_sprite/mini_sprite.dart';
import 'package:mini_sprite_editor/config/cubit/config_cubit.dart';
import 'package:mini_sprite_editor/sprite/sprite.dart';
import 'package:mini_sprite_editor/workspace/workspace.dart';

class WorkspaceView extends StatefulWidget {
  const WorkspaceView({
    this.colorList,
    this.sprite,
    super.key,
  });

  final List<Color>? colorList;
  final MiniSprite? sprite;

  @override
  State<WorkspaceView> createState() => _WorkspaceViewState();
}

class _WorkspaceViewState extends State<WorkspaceView> {
  @override
  void initState() {
    super.initState();

    if (widget.colorList != null) {
      context.read<ConfigCubit>().setColors(widget.colorList!);
    }

    if (widget.sprite != null) {
      context.read<SpriteCubit>().setSprite(widget.sprite!.pixels);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: TabWorkspace(),
    );
  }
}
