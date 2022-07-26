import 'package:flutter/material.dart';
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
              width: 300,
              height: 300,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
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
