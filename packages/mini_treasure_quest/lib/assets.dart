import 'package:flame/sprite.dart';
import 'package:flame_mini_sprite/flame_mini_sprite.dart';
import 'package:flutter/material.dart';
import 'package:mini_sprite/mini_sprite.dart';
import 'package:mini_treasure_quest/sprites.dart';

class Assets {
  Assets._();

  static final Assets _instance = Assets._();

  static Assets get instance => _instance;

  late Map<String, Sprite> gameSprites;

  Future<void> load() async {
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
  }
}
