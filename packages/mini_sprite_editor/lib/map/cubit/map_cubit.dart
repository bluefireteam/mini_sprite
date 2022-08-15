import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mini_sprite/mini_sprite.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(const MapState.initial());

  void addObject(int x, int y, Map<String, dynamic> data) {
    emit(
      state.copyWith(
        objects: {
          ...state.objects,
          MapPosition(x, y): data,
        },
      ),
    );
  }
}
