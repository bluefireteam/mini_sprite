import 'package:flutter/material.dart';

class PixelCell extends StatelessWidget {
  const PixelCell({
    super.key,
    required this.color,
    required this.hovered,
    required this.pixelSize,
    required this.hasBorder,
  });

  final bool hovered;
  final Color color;
  final int pixelSize;
  final bool hasBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: pixelSize.toDouble(),
      height: pixelSize.toDouble(),
      decoration: BoxDecoration(
        color: hovered ? color.withOpacity(.2) : color,
        border: Border.all(
          color: hasBorder ? Colors.black : Colors.transparent,
        ),
      ),
    );
  }
}
