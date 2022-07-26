import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/services.dart';
import 'package:mini_treasure_quest/mini_treasure_quest.dart';

class Player extends BodyComponent {
  Player({
    required this.initialPosition,
  });

  final Vector2 initialPosition;

  static const double speed = 6;
  static const double jumpForce = 8;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await add(
      KeyboardListenerComponent(
        keyUp: {
          LogicalKeyboardKey.space: _jump,
          LogicalKeyboardKey.keyA: _stopMoving,
          LogicalKeyboardKey.keyD: _stopMoving,
        },
        keyDown: {
          LogicalKeyboardKey.keyA: _startMovingLeft,
          LogicalKeyboardKey.keyD: _startMovingRight,
        },
      ),
    );
  }

  bool _jump(_) {
    if (body.linearVelocity.y == 0) {
      body.applyLinearImpulse(Vector2(0, -jumpForce));
    }
    return true;
  }

  bool _startMovingLeft(_) {
    if (body.linearVelocity.x > -speed) {
      body.applyLinearImpulse(Vector2(-speed, 0));
    }
    return true;
  }

  bool _startMovingRight(_) {
    if (body.linearVelocity.x < speed) {
      body.applyLinearImpulse(Vector2(speed, 0));
    }
    return true;
  }

  bool _stopMoving(_) {
    body.applyLinearImpulse(Vector2(-body.linearVelocity.x, 0));
    return true;
  }

  @override
  Body createBody() {
    renderBody = true;
    final bodyDef = BodyDef(
      userData: this,
      type: BodyType.dynamic,
    )..position = initialPosition;

    return world.createBody(bodyDef)
      ..createFixtureFromShape(
        PolygonShape()..setAsBoxXY(tileSize / 2, tileSize / 2),
      );
  }
}
