import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart' as forge;
import 'package:mini_treasure_quest/assets.dart';
import 'package:mini_treasure_quest/game/entities/entities.dart';
import 'package:mini_treasure_quest/mini_treasure_quest.dart';

class Treasure extends forge.BodyComponent<MiniTreasureQuest>
    with forge.ContactCallbacks {
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
  forge.Body createBody() {
    renderBody = false;

    final bodyDef = forge.BodyDef(
      userData: this,
      type: forge.BodyType.kinematic,
    )..position = forge.Vector2(initialPosition.x, initialPosition.y);

    final body = world.createBody(bodyDef);

    body
        .createFixtureFromShape(
          forge.PolygonShape()
            ..setAsBoxXY(
              tileSize / 2,
              tileSize / 2,
            ),
        )
        .setSensor(true);

    return body;
  }

  @override
  void beginContact(Object other, forge.Contact contact) {
    if (other is Player) {
      game.win();
    }
  }
}
