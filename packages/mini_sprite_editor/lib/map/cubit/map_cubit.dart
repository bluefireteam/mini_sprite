import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:mini_sprite/mini_sprite.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit({
    Future<void> Function(ClipboardData)? setClipboardData,
    Future<ClipboardData?> Function(String)? getClipboardData,
  })  : _setClipboardData = setClipboardData ?? Clipboard.setData,
        _getClipboardData = getClipboardData ?? Clipboard.getData,
        super(const MapState.initial());

  final Future<void> Function(ClipboardData) _setClipboardData;
  final Future<ClipboardData?> Function(String) _getClipboardData;

  void copyToClipboard() {
    final data = MiniMap(objects: state.objects).toDataString();
    _setClipboardData(ClipboardData(text: data));
  }

  Future<void> importFromClipboard() async {
    final data = await _getClipboardData('text/plain');
    final text = data?.text;
    if (text != null) {
      final map = MiniMap.fromDataString(text);
      emit(state.copyWith(objects: map.objects));
    }
  }

  void setObjectData(int x, int y, Map<String, dynamic> data) {
    final position = MapPosition(x, y);
    if (state.objects[position] == null) {
      addObject(x, y, data);
    } else {
      final objData = state.objects[MapPosition(x, y)]!;
      final newData = <String, dynamic>{
        ...objData,
        ...data,
      };

      emit(
        state.copyWith(
          objects: {
            ...state.objects,
            position: newData,
          },
        ),
      );
    }
  }

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

  void removeObject(int x, int y) {
    final newObjects = Map.fromEntries(
      state.objects.entries.where(
        (entry) =>
            entry.key !=
            MapPosition(
              x,
              y,
            ),
      ),
    );
    emit(state.copyWith(objects: newObjects));
  }

  void setSize(int x, int y) {
    emit(
      state.copyWith(
        mapSize: Size(
          x.toDouble(),
          y.toDouble(),
        ),
      ),
    );
  }

  void clearMap() {
    emit(state.copyWith(objects: {}));
  }

  void setSelected(MapPosition position) {
    if (state.selectedObject == position) {
      emit(state.copyWith(selectedObject: const MapPosition(-1, -1)));
    } else {
      emit(state.copyWith(selectedObject: position));
    }
  }

  void removeProperty(MapPosition selected, String key) {
    final selectedObject = state.objects[selected];
    if (selectedObject != null) {
      final data = <String, dynamic>{
        ...Map<String, dynamic>.fromEntries(
          selectedObject.entries.where((entry) => entry.key != key).toList(),
        ),
      };

      emit(
        state.copyWith(
          objects: {
            ...state.objects,
            selected: data,
          },
        ),
      );
    }
  }
}
