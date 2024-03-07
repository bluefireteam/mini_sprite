import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_sprite_editor/hub/hub.dart';

class HubPage extends StatefulWidget {
  const HubPage({super.key});

  @override
  State<HubPage> createState() => _HubPageState();
}

class _HubPageState extends State<HubPage> {
  @override
  void initState() {
    super.initState();

    context.read<HubCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return const HubView();
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
