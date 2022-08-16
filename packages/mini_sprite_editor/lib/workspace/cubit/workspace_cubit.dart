import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'workspace_state.dart';

class WorkspaceCubit extends Cubit<WorkspaceState> {
  WorkspaceCubit() : super(const WorkspaceState.initial());

  void openPanel(WorkspacePanel panel) {
    if (!state.panels.contains(panel)) {
      emit(
        state.copyWith(
          panels: [
            ...state.panels,
            panel,
          ],
          activePanel: panel,
        ),
      );
    } else {
      emit(state.copyWith(activePanel: panel));
    }
  }

  void selectPanel(WorkspacePanel panel) {
    emit(state.copyWith(activePanel: panel));
  }

  void closePanel(WorkspacePanel panel) {
    final panels = [...state.panels.where((e) => e != panel)];
    emit(state.copyWith(panels: panels));
  }

  void setMode(WorkspaceMode mode) {
    emit(
      state.copyWith(
        mode: mode,
      ),
    );
  }
}
