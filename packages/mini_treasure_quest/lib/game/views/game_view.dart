import 'package:flame/game.dart' hide Route;
import 'package:flutter/material.dart';
import 'package:mini_treasure_quest/game/game.dart';

class GamePage extends StatelessWidget {
  const GamePage({required this.stage, super.key});

  final int stage;

  static Route<void> route(int stageId) {
    return MaterialPageRoute(
      builder: (context) {
        return GamePage(stage: stageId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GameView(stage: stage);
  }
}

class GameView extends StatelessWidget {
  const GameView({required this.stage, super.key});

  final int stage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: MiniTreasureQuest(stage: stage),
      ),
    );
  }
}
