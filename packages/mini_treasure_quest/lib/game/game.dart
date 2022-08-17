import 'dart:async';
import 'dart:math';

import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:mini_sprite/mini_sprite.dart';
import 'package:mini_treasure_quest/game/entities/entities.dart';
import 'package:mini_treasure_quest/game/stages.dart';
import 'package:mini_treasure_quest/game/views/view.dart';

const double tileSize = 2;

class MiniTreasureQuest extends Forge2DGame with HasKeyboardHandlerComponents {
  MiniTreasureQuest({required this.stage});

  final rng = Random(10);

  @override
  Future<void> onLoad() async {
    await loadStage(stages[stage]);
  }

  final int stage;

  Future<void> loadStage(String stage) async {
    final miniMap = MiniMap.fromDataString(stage);

    for (final entry in miniMap.objects.entries) {
      final sprite = entry.value['sprite'] as String?;
      final position = Vector2(
        entry.key.x.toDouble() * tileSize,
        entry.key.y.toDouble() * tileSize,
      );
      if (sprite == 'PLAYER') {
        unawaited(add(Player(initialPosition: position)));
      } else if (sprite == 'CHEST') {
        unawaited(add(Treasure(initialPosition: position)));
      } else if (sprite != null) {
        unawaited(add(Tile(initialPosition: position, sprite: sprite)));
      }
    }

    camera
      ..zoom = 20
      ..snapTo(-size / 2);
  }

  void win() {
    children.whereType<Treasure>().first.removeFromParent();
    showDialog<void>(
      context: buildContext!,
      builder: (context) {
        return WinDialog(stage: stage);
      },
    );
  }
}
