import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:mini_sprite/mini_sprite.dart';

part 'sprite_state.dart';

class SpriteCubit extends Cubit<SpriteState> {
  SpriteCubit({
    Future<void> Function(ClipboardData)? setClipboardData,
    Future<ClipboardData?> Function(String)? getClipboardData,
  })  : _setClipboardData = setClipboardData ?? Clipboard.setData,
        _getClipboardData = getClipboardData ?? Clipboard.getData,
        super(SpriteState.initial());

  final Future<void> Function(ClipboardData) _setClipboardData;
  final Future<ClipboardData?> Function(String) _getClipboardData;

  void copyToClipboard() {
    final sprite = MiniSprite(state.pixels);
    final data = sprite.toDataString();
    _setClipboardData(ClipboardData(text: data));
  }

  Future<void> importFromClipboard() async {
    final data = await _getClipboardData('text/plain');
    final text = data?.text;
    if (text != null) {
      final sprite = MiniSprite.fromDataString(text);
      emit(state.copyWith(pixels: sprite.pixels));
    }
  }

  void zoomIn() {
    emit(state.copyWith(pixelSize: state.pixelSize + 10));
  }

  void zoomOut() {
    emit(state.copyWith(pixelSize: state.pixelSize - 10));
  }

  void cursorLeft() {
    emit(state.copyWith(cursorPosition: const Offset(-1, -1)));
  }

  void selectTool(SpriteTool tool) {
    emit(state.copyWith(tool: tool));
  }

  Offset _projectOffset(Offset position) {
    final projected = position / state.pixelSize.toDouble();
    final x = projected.dx.floorToDouble();
    final y = projected.dy.floorToDouble();

    return Offset(x, y);
  }

  void _setPixel(bool value) {
    final newPixels = [
      ...state.pixels.map((e) => [...e]),
    ];
    final x = state.cursorPosition.dx.toInt();
    final y = state.cursorPosition.dy.toInt();

    newPixels[y][x] = value;
    emit(state.copyWith(pixels: newPixels));
  }

  void _floodFillSeek(int x, int y, bool value, List<List<bool>> pixels) {
    if (y < 0 || y >= pixels.length || x < 0 || x >= pixels[0].length) {
      return;
    }

    if (pixels[y][x] == value) {
      return;
    }
    pixels[y][x] = value;
    _floodFillSeek(x + 1, y, value, pixels);
    _floodFillSeek(x - 1, y, value, pixels);
    _floodFillSeek(x, y + 1, value, pixels);
    _floodFillSeek(x, y - 1, value, pixels);
  }

  void _floodFill(bool value) {
    final newPixels = [
      ...state.pixels.map((e) => [...e]),
    ];

    _floodFillSeek(
      state.cursorPosition.dx.toInt(),
      state.cursorPosition.dy.toInt(),
      value,
      newPixels,
    );

    emit(state.copyWith(pixels: newPixels, toolActive: false));
  }

  void _processTool() {
    switch (state.tool) {
      case SpriteTool.brush:
      case SpriteTool.eraser:
        if (state.toolActive) {
          _setPixel(state.tool == SpriteTool.brush);
        }
        break;
      case SpriteTool.bucket:
      case SpriteTool.bucketEraser:
        if (state.toolActive) {
          _floodFill(state.tool == SpriteTool.bucket);
        }
        break;
    }
  }

  void cursorHover(Offset position) {
    final projected = _projectOffset(position);
    if (projected != state.cursorPosition) {
      emit(state.copyWith(cursorPosition: projected));
      _processTool();
    }
  }

  void cursorDown(Offset position) {
    final projected = _projectOffset(position);
    emit(state.copyWith(cursorPosition: projected, toolActive: true));
    _processTool();
  }

  void cursorUp() {
    emit(state.copyWith(toolActive: false));
    _processTool();
  }
}
