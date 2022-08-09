import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mini_sprite_editor/app/app.dart';
import 'package:mini_sprite_editor/sprite/sprite.dart';

import '../../helpers/helpers.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = MockHydratedStorage();

  group('App', () {
    testWidgets('renders SpritePage', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(SpritePage), findsOneWidget);
    });
  });
}
