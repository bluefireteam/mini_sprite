import 'package:hydrated_bloc/hydrated_bloc.dart';

class MockHydratedStorage implements HydratedStorage {
  final _values = <String, dynamic>{};

  @override
  Future<void> clear() async {
    _values.clear();
  }

  @override
  Future<void> delete(String key) async {
    _values.remove(key);
  }

  @override
  Future<dynamic> read(String key) async {
    return _values[key];
  }

  @override
  Future<void> write(String key, dynamic value) async {
    _values[key] = value;
  }
}
