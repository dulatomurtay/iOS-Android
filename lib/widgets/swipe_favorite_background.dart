import 'package:flutter/material.dart';

/// Pink background with a heart, revealed while an item is swiped
/// left-to-right (the item is NOT removed, only its favorite flag changes).
class SwipeFavoriteBackground extends StatelessWidget {
  final bool isFavorite;
  final BorderRadius? borderRadius;

  const SwipeFavoriteBackground({
    super.key,
    required this.isFavorite,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFE91E63),
        borderRadius: borderRadius,
      ),
      child: Icon(
        isFavorite ? Icons.heart_broken : Icons.favorite,
        color: Colors.white,
      ),
    );
  }
}
