import 'dart:async';

import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:mini_treasure_quest/game/entities/entities.dart';
import 'package:mini_treasure_quest/game/stages.dart';
import 'package:mini_treasure_quest/game/views/view.dart';

const double tileSize = 2;

class MiniTreasureQuest extends Forge2DGame with HasKeyboardHandlerComponents {
  MiniTreasureQuest({required this.stage});

  @override
  Future<void> onLoad() async {
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

    // TODO(erickzanardo): calculate zoom eventually.

    camera.snapTo(-(size - center) / 2);
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
