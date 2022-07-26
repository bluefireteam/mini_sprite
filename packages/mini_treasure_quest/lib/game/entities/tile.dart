import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:mini_treasure_quest/mini_treasure_quest.dart';

class Tile extends BodyComponent {
  Tile({required this.initialPosition});

  final Vector2 initialPosition;

  @override
  Body createBody() {
    renderBody = true;
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
