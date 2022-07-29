import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:mini_treasure_quest/mini_treasure_quest.dart';

class Tile extends BodyComponent<MiniTreasureQuest> {
  Tile({required this.initialPosition});

  final Vector2 initialPosition;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await add(
      SpriteComponent(
        sprite: gameRef.gameSprites['TILE${gameRef.rng.nextInt(3)}'],
        size: Vector2.all(tileSize),
        anchor: Anchor.center,
      ),
    );
  }

  @override
  Body createBody() {
    renderBody = false;
    final bodyDef = BodyDef(
      userData: this,
      type: BodyType.kinematic,
    )..position = initialPosition;

    return world.createBody(bodyDef)
      ..createFixtureFromShape(
        PolygonShape()..setAsBoxXY(tileSize / 2, tileSize / 2),
      );
  }
}
