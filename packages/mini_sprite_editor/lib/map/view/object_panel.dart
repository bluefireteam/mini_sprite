import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_sprite/mini_sprite.dart';
import 'package:mini_sprite_editor/l10n/l10n.dart';
import 'package:mini_sprite_editor/map/map.dart';
import 'package:mini_sprite_editor/sprite/sprite.dart';

class ObjectPanel extends StatelessWidget {
  const ObjectPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapState>(
      buildWhen: (previous, current) =>
          previous.selectedObject != current.selectedObject ||
          previous.objects[previous.selectedObject] !=
              current.objects[current.selectedObject],
      builder: (context, state) {
        if (state.selectedObject == const MapPosition(-1, -1)) {
          return const SizedBox();
        }

        final l10n = context.l10n;
        final entries = state.objects[state.selectedObject]?.entries ?? [];

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'x ${state.selectedObject.x}, ${state.selectedObject.y}',
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        l10n.properties,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      IconButton(
                        onPressed: () async {
                          final cubit = context.read<MapCubit>();
                          final value = await NewPropertyDialog.show(context);

                          if (value != null) {
                            cubit.setObjectData(
                              state.selectedObject.x,
                              state.selectedObject.y,
                              Map<String, dynamic>.fromEntries([value]),
                            );
                          }
                        },
                        tooltip: l10n.newPropery,
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
                for (final entry in entries)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '${entry.key}: ${entry.value}',
                      ),
                      IconButton(
                        onPressed: () async {
                          final cubit = context.read<MapCubit>();
                          final value = await ConfirmDialog.show(context);
                          if (value ?? false) {
                            cubit.removeProperty(
                              state.selectedObject,
                              entry.key,
                            );
                          }
                        },
                        tooltip: l10n.removeProperty,
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
