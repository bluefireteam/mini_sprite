import 'package:flutter_test/flutter_test.dart';
import 'package:mini_sprite_editor/app/app.dart';
import 'package:mini_sprite_editor/sprite/sprite.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(SpritePage), findsOneWidget);
    });
  });
}
