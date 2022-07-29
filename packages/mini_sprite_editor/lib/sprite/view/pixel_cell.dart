import 'package:flutter/material.dart';

class PixelCell extends StatelessWidget {
  const PixelCell({
    super.key,
    required this.selected,
    required this.hovered,
    required this.pixelSize,
    required this.hasBorder,
  });

  final bool selected;
  final bool hovered;
  final int pixelSize;
  final bool hasBorder;

  @override
  Widget build(BuildContext context) {
    final selectedColor =
        Theme.of(context).textTheme.bodySmall?.color ?? Colors.black;

    return Container(
      width: pixelSize.toDouble(),
      height: pixelSize.toDouble(),
      decoration: BoxDecoration(
        color: selected
            ? selectedColor
            : hovered
                ? selectedColor.withOpacity(.2)
                : Colors.transparent,
        border: Border.all(
          color: hasBorder
              ? selectedColor
              : selected
                  ? selectedColor
                  : Colors.transparent,
        ),
      ),
    );
  }
}
