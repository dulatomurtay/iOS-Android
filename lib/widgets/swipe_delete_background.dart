import 'package:flutter/material.dart';

/// Red background with a trash icon, revealed while an item is swiped
/// right-to-left.
class SwipeDeleteBackground extends StatelessWidget {
  final BorderRadius? borderRadius;

  const SwipeDeleteBackground({super.key, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(color: Colors.red, borderRadius: borderRadius),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }
}
