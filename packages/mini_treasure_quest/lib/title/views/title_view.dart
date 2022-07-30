import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:mini_treasure_quest/assets.dart';
import 'package:mini_treasure_quest/stages/stages.dart';

class TitlePage extends StatelessWidget {
  const TitlePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (_) => const TitlePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const TitleView();
  }
}

class TitleView extends StatelessWidget {
  const TitleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 400,
              height: 300,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 4,
                ),
              ),
              child: SpriteWidget(
                // TODO(erickzanardo): A MiniSpriteWidget is a good idea.
                sprite: Assets.instance.gameSprites['LOGO']!,
              ),
            ),
            const SizedBox(height: 64),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(StagesPage.route());
              },
              child: const Text('Play'),
            )
          ],
        ),
      ),
    );
  }
}
