import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:mini_treasure_quest/game/entities/entities.dart';
import 'package:mini_treasure_quest/mini_treasure_quest.dart';

class Treasure extends BodyComponent<MiniTreasureQuest> with ContactCallbacks {
  Treasure({required this.initialPosition});

  final Vector2 initialPosition;

  @override
  Body createBody() {
    renderBody = true;
    paint = Paint()..color = Colors.yellow;

    final bodyDef = BodyDef(
      userData: this,
      type: BodyType.kinematic,
    )..position = initialPosition;

    final body = world.createBody(bodyDef);

    body
        .createFixtureFromShape(
          PolygonShape()
            ..setAsBoxXY(
              tileSize / 2,
              tileSize / 2,
            ),
        )
        .setSensor(true);

    return body;
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is Player) {
      gameRef.win();
    }
  }
}
