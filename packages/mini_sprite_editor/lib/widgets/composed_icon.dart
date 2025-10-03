import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class ComposedIcon extends StatelessWidget {
  const ComposedIcon({
    required this.primary,
    required this.secondary,
    super.key,
  });

  final IconData primary;
  final IconData secondary;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(primary),
        Positioned(
          left: 10,
          top: 6,
          child: Icon(
            size: 18,
            shadows: [
              Shadow(
                color:
                    Theme.of(context).iconTheme.color?.darken(
                      .7,
                    ) ??
                    Colors.black,
                blurRadius: 4,
              ),
            ],
            secondary,
          ),
        ),
      ],
    );
  }
}
