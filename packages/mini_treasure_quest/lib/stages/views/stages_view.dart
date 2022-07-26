import 'package:flutter/material.dart';
import 'package:mini_treasure_quest/game/stages.dart';
import 'package:mini_treasure_quest/game/views/view.dart';

class StagesPage extends StatelessWidget {
  const StagesPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (_) => const StagesPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const StagesView();
  }
}

class StagesView extends StatelessWidget {
  const StagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: GridView.count(
          crossAxisCount: 10,
          children: [
            for (var i = 0; i < stages.length; i++)
              InkWell(
                onTap: () {
                  Navigator.of(context).push(GamePage.route(i));
                },
                child: Card(
                  child: Center(
                    child: Text(
                      'Stage ${i + 1}',
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
