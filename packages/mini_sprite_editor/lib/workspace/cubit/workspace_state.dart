part of 'workspace_cubit.dart';

enum WorkspacePanel {
  sprite,
  map,
}

enum WorkspaceMode {
  verticalSplit,
  horizontalSplit,
  tabs,
}

class WorkspaceState extends Equatable {
  const WorkspaceState({
    required this.panels,
    required this.mode,
    required this.activePanel,
  });

  const WorkspaceState.initial()
      : this(
          panels: const [],
          mode: WorkspaceMode.tabs,
          activePanel: WorkspacePanel.sprite,
        );

  final List<WorkspacePanel> panels;
  final WorkspaceMode mode;
  final WorkspacePanel activePanel;

  WorkspaceState copyWith({
    List<WorkspacePanel>? panels,
    WorkspaceMode? mode,
    WorkspacePanel? activePanel,
  }) {
    return WorkspaceState(
      panels: panels ?? this.panels,
      mode: mode ?? this.mode,
      activePanel: activePanel ?? this.activePanel,
    );
  }

  @override
  List<Object?> get props => [panels, mode, activePanel];
}
