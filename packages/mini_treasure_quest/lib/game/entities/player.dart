import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart' as forge;
import 'package:flutter/services.dart';
import 'package:mini_treasure_quest/assets.dart';
import 'package:mini_treasure_quest/mini_treasure_quest.dart';

class Player extends forge.BodyComponent<MiniTreasureQuest> {
  Player({
    required this.initialPosition,
  });

  final Vector2 initialPosition;

  static const double speed = 6;
  static const double jumpForce = 8;

  late SpriteComponent sprite;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await add(
      sprite = SpriteComponent(
        sprite: Assets.instance.gameSprites['PLAYER'],
        size: Vector2.all(tileSize),
        anchor: Anchor.center,
      ),
    );

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

  bool _jump(Set<LogicalKeyboardKey> pressedKeys) {
    if (body.linearVelocity.y == 0) {
      body.applyLinearImpulse(forge.Vector2(0, -jumpForce));
    }
    return true;
  }

  bool _startMovingLeft(Set<LogicalKeyboardKey> pressedKeys) {
    if (body.linearVelocity.x > -speed) {
      body.applyLinearImpulse(forge.Vector2(-speed, 0));
    }
    if (!sprite.isFlippedHorizontally) {
      sprite.flipHorizontally();
    }
    return true;
  }

  bool _startMovingRight(Set<LogicalKeyboardKey> pressedKeys) {
    if (body.linearVelocity.x < speed) {
      body.applyLinearImpulse(forge.Vector2(speed, 0));
    }
    if (sprite.isFlippedHorizontally) {
      sprite.flipHorizontally();
    }
    return true;
  }

  bool _stopMoving(Set<LogicalKeyboardKey> pressedKeys) {
    body.applyLinearImpulse(forge.Vector2(-body.linearVelocity.x, 0));
    return true;
  }

  @override
  forge.Body createBody() {
    renderBody = false;
    final bodyDef = forge.BodyDef(
      userData: this,
      type: forge.BodyType.dynamic,
    )..position = forge.Vector2(initialPosition.x, initialPosition.y);

    return world.createBody(bodyDef)
      ..createFixtureFromShape(
        forge.PolygonShape()..setAsBoxXY(tileSize / 2, tileSize / 2),
      );
  }
}
