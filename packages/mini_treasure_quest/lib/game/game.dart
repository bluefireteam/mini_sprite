import 'dart:async';
import 'dart:math';

import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_mini_sprite/flame_mini_sprite.dart';
import 'package:flutter/material.dart';
import 'package:mini_sprite/mini_sprite.dart';
import 'package:mini_treasure_quest/game/entities/entities.dart';
import 'package:mini_treasure_quest/game/stages.dart';
import 'package:mini_treasure_quest/game/views/view.dart';
import 'package:mini_treasure_quest/sprites.dart';

const double tileSize = 2;

class MiniTreasureQuest extends Forge2DGame with HasKeyboardHandlerComponents {
  MiniTreasureQuest({required this.stage});

  late Map<String, Sprite> gameSprites;
  final rng = Random(10);

  @override
  Future<void> onLoad() async {
    final entries = await Future.wait(
      sprites.entries.map((entry) async {
        return MapEntry(
          entry.key,
          await MiniSprite.fromDataString(entry.value).toSprite(
            color: Colors.white,
            pixelSize: 1,
          ),
        );
      }).toList(),
    );

    gameSprites = {
      for (final entry in entries) entry.key: entry.value,
    };

    await loadStage(stages[stage]);
  }

  final int stage;

  Future<void> loadStage(String stage) async {
    final matrix = stage.split('\n').map((line) => line.split(',')).toList();

    for (var y = 0; y < matrix.length; y++) {
      for (var x = 0; x < matrix[y].length; x++) {
        final tile = matrix[y][x];
        final position = Vector2(
          x * tileSize,
          y * tileSize,
        );
        if (tile == 'P') {
          unawaited(add(Player(initialPosition: position)));
        } else if (tile == 'G') {
          unawaited(add(Treasure(initialPosition: position)));
        } else if (tile == 'T') {
          unawaited(add(Tile(initialPosition: position)));
        }
      }
    }

    final totalSize = Vector2(
      matrix[0].length * tileSize,
      matrix.length * tileSize,
    );

    final center = totalSize;

    camera
      ..zoom = 20
      ..snapTo(-(size - center) / 2);
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
