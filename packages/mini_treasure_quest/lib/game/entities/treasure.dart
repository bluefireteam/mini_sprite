import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:mini_treasure_quest/assets.dart';
import 'package:mini_treasure_quest/game/entities/entities.dart';
import 'package:mini_treasure_quest/mini_treasure_quest.dart';

class Treasure extends BodyComponent<MiniTreasureQuest>
    with ContactCallbacks, HasGameRef<MiniTreasureQuest> {
  Treasure({required this.initialPosition});

  final Vector2 initialPosition;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await add(
      SpriteComponent(
        sprite: Assets.instance.gameSprites['CHEST'],
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
