part of 'hub_cubit.dart';

enum HubStateStatus {
  initial,
  loading,
  loaded,
  error,
}

class HubState extends Equatable {
  const HubState({
    required this.status,
    required this.entries,
  });

  const HubState.initial()
      : this(
          status: HubStateStatus.initial,
          entries: const [],
        );

  final HubStateStatus status;
  final List<HubEntryResult> entries;

  HubState copyWith({
    HubStateStatus? status,
    List<HubEntryResult>? entries,
  }) {
    return HubState(
      status: status ?? this.status,
      entries: entries ?? this.entries,
    );
  }

  @override
  List<Object> get props => [status, entries];
}
