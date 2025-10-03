import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mini_treasure_quest/game/stages.dart';
import 'package:mini_treasure_quest/game/views/game_view.dart';
import 'package:mini_treasure_quest/stages/stages.dart';

class WinDialog extends StatelessWidget {
  const WinDialog({required this.stage, super.key});

  final int stage;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 450,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Stage clear!',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  autofocus: stage + 1 == stages.length,
                  onPressed: () {
                    unawaited(
                      Navigator.of(context).pushReplacement(
                        StagesPage.route(),
                      ),
                    );
                  },
                  child: const Text('Stages'),
                ),
                if (stage + 1 < stages.length)
                  ElevatedButton(
                    autofocus: true,
                    onPressed: () {
                      unawaited(
                        Navigator.of(context).pushReplacement(
                          GamePage.route(stage + 1),
                        ),
                      );
                    },
                    child: const Text('Next'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
