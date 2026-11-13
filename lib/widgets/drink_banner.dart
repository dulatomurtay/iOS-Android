import 'package:flutter/material.dart';

import '../models/drink.dart';

/// Gradient banner with a big icon and the drink photo on top of it.
/// Uses a Stack, so extra widgets (favorite button, badge) can be placed
/// over the picture via [overlays]. It fills whatever size its parent gives it.
class DrinkBanner extends StatelessWidget {
  final Drink drink;
  final double iconSize;
  final List<Widget> overlays;

  const DrinkBanner({
    super.key,
    required this.drink,
    this.iconSize = 48,
    this.overlays = const [],
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [drink.color, Color.lerp(drink.color, Colors.black, 0.4)!],
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(drink.icon, size: iconSize, color: Colors.white),
          ),
          // Photo. If the file is missing, the icon above stays visible.
          if (drink.image != null)
            Positioned.fill(
              child: Image.asset(
                drink.image!,
                fit: BoxFit.cover,
                cacheWidth: 480,
                gaplessPlayback: true,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
            ),
          ...overlays,
        ],
      ),
    );
  }
}
