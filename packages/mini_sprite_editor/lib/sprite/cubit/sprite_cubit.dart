import 'dart:async';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flame_mini_sprite/flame_mini_sprite.dart';
import 'package:flutter/services.dart';
import 'package:mini_sprite/mini_sprite.dart';
import 'package:mini_sprite_editor/sprite/sprite.dart';
import 'package:replay_bloc/replay_bloc.dart';

part 'sprite_state.dart';

class SpriteCubit extends ReplayCubit<SpriteState> {
  SpriteCubit({
    Future<void> Function(ClipboardData)? setClipboardData,
    Future<ClipboardData?> Function(String)? getClipboardData,
  }) : _setClipboardData = setClipboardData ?? Clipboard.setData,
       _getClipboardData = getClipboardData ?? Clipboard.getData,
       super(SpriteState.initial());

  final Future<void> Function(ClipboardData) _setClipboardData;
  final Future<ClipboardData?> Function(String) _getClipboardData;

  bool toolActive = false;

  void copyToClipboard() {
    final sprite = MiniSprite(state.pixels);
    final data = sprite.toDataString();
    unawaited(_setClipboardData(ClipboardData(text: data)));
  }

  void setSprite(List<List<int>> pixels) {
    emit(state.copyWith(pixels: pixels));
    clearHistory();
  }

  Future<void> exportToImage({
    required int pixelSize,
    required List<Color> palette,
    required Color backgroundColor,
  }) async {
    final miniSprite = MiniSprite(state.pixels);
    final sprite = await miniSprite.toSprite(
      pixelSize: pixelSize.toDouble(),
      palette: palette,
      backgroundColor: backgroundColor,
    );

    final data = await sprite.image.toByteData(format: ImageByteFormat.png);

    const fileName = 'sprite.png';
    final location = await getSaveLocation(suggestedName: fileName);
    if (location == null) {
      // Operation was canceled by the user.
      return;
    }

    final fileData = data!.buffer.asUint8List();
    const mimeType = 'image/png';
    final imageFile = XFile.fromData(
      fileData,
      mimeType: mimeType,
      name: fileName,
    );
    await imageFile.saveTo(location.path);
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

  void flipSpriteVertically() {
    final newPixels = [
      ...state.pixels.reversed.map((e) => [...e]),
    ];
    emit(state.copyWith(pixels: newPixels));
  }

  void flipSpriteHorizontally() {
    final newPixels = [
      ...state.pixels.map((e) => [...e.reversed]),
    ];
    emit(state.copyWith(pixels: newPixels));
  }

  void rotateSpriteClockwise() {
    final newPixels = List.generate(
      state.pixels[0].length,
      (i) => List.generate(state.pixels.length, (j) => -1),
    );

    for (var y = 0; y < state.pixels.length; y++) {
      for (var x = 0; x < state.pixels[y].length; x++) {
        newPixels[x][state.pixels.length - y - 1] = state.pixels[y][x];
      }
    }

    emit(state.copyWith(pixels: newPixels));
  }

  void rotateSpriteCounterClockwise() {
    final newPixels = List.generate(
      state.pixels[0].length,
      (i) => List.generate(state.pixels.length, (j) => -1),
    );

    for (var y = 0; y < state.pixels.length; y++) {
      for (var x = 0; x < state.pixels[y].length; x++) {
        newPixels[state.pixels[0].length - x - 1][y] = state.pixels[y][x];
      }
    }

    emit(state.copyWith(pixels: newPixels));
  }

  Offset _projectOffset(Offset position, double pixelSize) {
    final projected = position / pixelSize;
    final x = projected.dx.floorToDouble();
    final y = projected.dy.floorToDouble();

    return Offset(x, y);
  }

  void _setPixel(int value) {
    final newPixels = [
      ...state.pixels.map((e) => [...e]),
    ];
    final x = state.cursorPosition.dx.toInt();
    final y = state.cursorPosition.dy.toInt();

    newPixels[y][x] = value;
    emit(state.copyWith(pixels: newPixels));
  }

  void _floodFillSeek(int x, int y, int value, List<List<int>> pixels) {
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

  void _floodFill(int value) {
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

  void _processTool(SpriteTool tool, int selectedColor) {
    switch (tool) {
      case SpriteTool.brush:
        if (toolActive) {
          _setPixel(selectedColor);
        }
      case SpriteTool.eraser:
        if (toolActive) {
          _setPixel(-1);
        }
      case SpriteTool.bucket:
        if (toolActive) {
          _floodFill(selectedColor);
        }
      case SpriteTool.bucketEraser:
        if (toolActive) {
          _floodFill(-1);
        }
    }
  }

  void cursorHover(
    Offset position,
    double pixelSize,
    SpriteTool tool,
    int selectedColor,
  ) {
    final projected = _projectOffset(position, pixelSize);
    if (projected != state.cursorPosition) {
      emit(state.copyWith(cursorPosition: projected));
      _processTool(tool, selectedColor);
    }
  }

  void cursorDown(
    Offset position,
    double pixelSize,
    SpriteTool tool,
    int selectedColor,
  ) {
    final projected = _projectOffset(position, pixelSize);
    emit(state.copyWith(cursorPosition: projected));
    toolActive = true;
    _processTool(tool, selectedColor);
  }

  void cursorUp(SpriteTool tool, int selectedColor) {
    toolActive = false;
    _processTool(tool, selectedColor);
  }

  void setSize(int x, int y) {
    final newPixels = [...List.generate(y, (i) => List.generate(x, (j) => -1))];

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
        (i) => List.generate(state.pixels[0].length, (j) => -1),
      ),
    ];

    emit(state.copyWith(pixels: newPixels));
  }

  @override
  bool shouldReplay(SpriteState state) {
    final eq = const ListEquality<List<int>>(ListEquality()).equals;
    return !eq(state.pixels, this.state.pixels);
  }
}
