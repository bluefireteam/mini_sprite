import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:mini_sprite/mini_sprite.dart';
import 'package:mini_sprite_editor/sprite/sprite.dart';
import 'package:replay_bloc/replay_bloc.dart';

part 'sprite_state.dart';

class SpriteCubit extends ReplayCubit<SpriteState> {
  SpriteCubit({
    Future<void> Function(ClipboardData)? setClipboardData,
    Future<ClipboardData?> Function(String)? getClipboardData,
  })  : _setClipboardData = setClipboardData ?? Clipboard.setData,
        _getClipboardData = getClipboardData ?? Clipboard.getData,
        super(SpriteState.initial());

  final Future<void> Function(ClipboardData) _setClipboardData;
  final Future<ClipboardData?> Function(String) _getClipboardData;

  bool toolActive = false;

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

  void cursorLeft() {
    emit(state.copyWith(cursorPosition: const Offset(-1, -1)));
  }

  Offset _projectOffset(Offset position, double pixelSize) {
    final projected = position / pixelSize;
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

    emit(state.copyWith(pixels: newPixels));
    toolActive = false;
  }

  void _processTool(SpriteTool tool) {
    switch (tool) {
      case SpriteTool.brush:
      case SpriteTool.eraser:
        if (toolActive) {
          _setPixel(tool == SpriteTool.brush);
        }
        break;
      case SpriteTool.bucket:
      case SpriteTool.bucketEraser:
        if (toolActive) {
          _floodFill(tool == SpriteTool.bucket);
        }
        break;
    }
  }

  void cursorHover(Offset position, double pixelSize, SpriteTool tool) {
    final projected = _projectOffset(position, pixelSize);
    if (projected != state.cursorPosition) {
      emit(state.copyWith(cursorPosition: projected));
      _processTool(tool);
    }
  }

  void cursorDown(Offset position, double pixelSize, SpriteTool tool) {
    final projected = _projectOffset(position, pixelSize);
    emit(state.copyWith(cursorPosition: projected));
    toolActive = true;
    _processTool(tool);
  }

  void cursorUp(SpriteTool tool) {
    toolActive = false;
    _processTool(tool);
  }

  void setSize(int x, int y) {
    final newPixels = [
      ...List.generate(y, (i) => List.generate(x, (j) => false)),
    ];

    for (var y = 0; y < state.pixels.length; y++) {
      for (var x = 0; x < state.pixels[y].length; x++) {
        if (y < newPixels.length && x < newPixels[y].length) {
          newPixels[y][x] = state.pixels[y][x];
        }
      }
    }

    emit(state.copyWith(pixels: newPixels));
  }

  void clearSprite() {
    final newPixels = [
      ...List.generate(
        state.pixels.length,
        (i) => List.generate(state.pixels[0].length, (j) => false),
      ),
    ];

    emit(state.copyWith(pixels: newPixels));
  }

  @override
  bool shouldReplay(SpriteState state) {
    return state.pixels != this.state.pixels;
  }
}
