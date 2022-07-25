import 'package:flutter/material.dart';

class PixelCell extends StatelessWidget {
  const PixelCell({
    super.key,
    required this.selected,
    required this.hovered,
    required this.pixelSize,
  });

  final bool selected;
  final bool hovered;
  final int pixelSize;

  @override
  Widget build(BuildContext context) {
    final selectedColor =
        Theme.of(context).textTheme.bodySmall?.color ?? Colors.black;

    final unselectedColor = Theme.of(context).scaffoldBackgroundColor;

    return Container(
      width: pixelSize.toDouble(),
      height: pixelSize.toDouble(),
      decoration: BoxDecoration(
        color: selected
            ? selectedColor
            : hovered
                ? selectedColor.withOpacity(.2)
                : unselectedColor,
        border: Border.all(
          color: selectedColor,
        ),
      ),
    );
  }
}
