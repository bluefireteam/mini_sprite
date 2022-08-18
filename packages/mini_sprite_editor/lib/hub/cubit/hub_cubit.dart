import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:mini_hub_client/mini_hub_client.dart';

part 'hub_state.dart';

class HubCubit extends Cubit<HubState> {
  HubCubit({
    MiniHubClient? client,
  }) : super(const HubState.initial()) {
    _client = client ?? const MiniHubClient();
  }

  late final MiniHubClient _client;

  Future<void> load() async {
    emit(state.copyWith(status: HubStateStatus.loading));
    try {
      final entries = await _client.listEntries('');
      emit(state.copyWith(status: HubStateStatus.loaded, entries: entries));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(state.copyWith(status: HubStateStatus.error));
    }
  }
}
