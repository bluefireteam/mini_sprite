import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_sprite_editor/hub/hub.dart';

class HubPage extends StatelessWidget {
  const HubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HubCubit>(
      create: (_) => HubCubit()..load(),
      child: const HubView(),
    );
  }
}

class HubView extends StatelessWidget {
  const HubView({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = context.watch<HubCubit>().state.entries;

    return SingleChildScrollView(
      child: Column(
        children: [
          for (final entry in entries) HubEntryCard(entry: entry),
        ],
      ),
    );
  }
}
