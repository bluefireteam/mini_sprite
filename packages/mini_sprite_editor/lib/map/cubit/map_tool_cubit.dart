import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'map_tool_state.dart';

class MapToolCubit extends Cubit<MapToolState> {
  MapToolCubit() : super(const MapToolState.initial());

  void toogleGrid() {
    emit(state.copyWith(gridActive: !state.gridActive));
  }

  void selectTool(MapTool tool) {
    emit(
      state.copyWith(
        tool: tool,
      ),
    );
  }

  void setZoom(double zoom) {
    emit(
      state.copyWith(
        zoom: zoom,
      ),
    );
  }

  void increaseZoom() {
    emit(
      state.copyWith(
        zoom: state.zoom + 0.1,
      ),
    );
  }

  void decreaseZoom() {
    emit(
      state.copyWith(
        zoom: state.zoom - 0.1,
      ),
    );
  }
}
