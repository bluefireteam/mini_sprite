import 'dart:math';

import 'package:flame/sprite.dart';
import 'package:flame_mini_sprite/flame_mini_sprite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_hub_client/mini_hub_client.dart';
import 'package:mini_sprite/mini_sprite.dart';
import 'package:mini_sprite_editor/config/cubit/config_cubit.dart';
import 'package:mini_sprite_editor/l10n/l10n.dart';

class HubEntryCard extends StatefulWidget {
  const HubEntryCard({super.key, required this.entry});

  final HubEntryResult entry;

  @override
  State<HubEntryCard> createState() => _HubEntryCardState();
}

class _HubEntryCardState extends State<HubEntryCard> {
  final client = const MiniHubClient();

  late Map<String, Sprite>? _sprites;
  HubEntry? _entry;

  @override
  void initState() {
    super.initState();
    _loadEntry();
  }

  Future<void> _loadEntry() async {
    final cubit = context.read<ConfigCubit>();
    final configState = cubit.state;

    try {
      final entry = await client.fetchEntry(widget.entry.path);
      if (entry != null) {
        final library = MiniLibrary.fromDataString(entry.data);
        _sprites = await library.toSprites(
          pixelSize: 1,
          palette: cubit.palette(),
          backgroundColor: configState.backgroundColor,
        );
        setState(() {
          _entry = entry;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 220,
        child: _entry == null
            ? const Center(child: CircularProgressIndicator())
            : Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(16),
                    color: context.read<ConfigCubit>().state.backgroundColor,
                    width: 180,
                    height: 180,
                    child: CustomPaint(
                      painter: _Thumbnail(
                        _entry!.thumb,
                        _sprites!,
                        _entry!.gridSize,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        _entry!.name,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      const SizedBox(height: 16),
                      Text(_entry!.description),
                      const SizedBox(height: 8),
                      Text('Grid size: ${_entry!.gridSize}'),
                      const SizedBox(height: 16),
                      Text('by: ${_entry!.author}'),
                      IconButton(
                        onPressed: () async {
                          final messenger = ScaffoldMessenger.of(context);
                          final label = context.l10n.copiedWithSuccess;
                          await Clipboard.setData(
                            ClipboardData(text: _entry!.data),
                          );
                          messenger.showSnackBar(
                            SnackBar(content: Text(label)),
                          );
                        },
                        icon: const Icon(Icons.download),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

class _Thumbnail extends CustomPainter {
  _Thumbnail(this.thumbnail, this.sprites, this.gridSize);

  final int gridSize;
  final String thumbnail;
  final Map<String, Sprite> sprites;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! _Thumbnail || oldDelegate.thumbnail != thumbnail;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final map = MiniMap.fromDataString(thumbnail);

    final bigger = map.objects.keys.fold(const MapPosition(0, 0),
        (MapPosition previousValue, MapPosition element) {
      return MapPosition(
        max(previousValue.x, element.x),
        max(previousValue.y, element.y),
      );
    });

    final rate = size.width / ((bigger.x + 1) * gridSize);

    for (final object in map.objects.entries) {
      final sprite = sprites[object.value['sprite']];
      if (sprite != null) {
        sprite.renderRect(
          canvas,
          Rect.fromLTWH(
            object.key.x * gridSize.toDouble() * rate,
            object.key.y * gridSize.toDouble() * rate,
            sprite.image.width * rate,
            sprite.image.height * rate,
          ),
        );
      }
    }
  }
}
