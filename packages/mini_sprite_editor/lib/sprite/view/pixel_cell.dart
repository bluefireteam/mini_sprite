import 'package:flutter/material.dart';

class PixelCell extends StatelessWidget {
  const PixelCell({
    super.key,
    required this.selected,
    required this.hovered,
    required this.filledColor,
    required this.unfilledColor,
    required this.pixelSize,
    required this.hasBorder,
  });

  final bool selected;
  final bool hovered;
  final Color filledColor;
  final Color unfilledColor;
  final int pixelSize;
  final bool hasBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: pixelSize.toDouble(),
      height: pixelSize.toDouble(),
      decoration: BoxDecoration(
        color: selected
            ? filledColor
            : hovered
                ? filledColor.withOpacity(.2)
                : unfilledColor,
        border: Border.all(
          color: hasBorder
              ? filledColor
              : selected
                  ? filledColor
                  : unfilledColor,
        ),
      ),
    );
  }
}
