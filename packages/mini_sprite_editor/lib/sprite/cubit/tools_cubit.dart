import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mini_sprite_editor/sprite/sprite.dart';

part 'tools_state.dart';

class ToolsCubit extends Cubit<ToolsState> {
  ToolsCubit() : super(const ToolsState.initial());

  void zoomIn() {
    emit(state.copyWith(pixelSize: state.pixelSize + 10));
  }

  void zoomOut() {
    emit(state.copyWith(pixelSize: state.pixelSize - 10));
  }

  void selectTool(SpriteTool tool) {
    emit(state.copyWith(tool: tool));
  }

  void toogleGrid() {
    emit(state.copyWith(gridActive: !state.gridActive));
  }
}
