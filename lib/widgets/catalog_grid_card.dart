import 'package:flutter/material.dart';

import '../models/drink.dart';
import 'drink_banner.dart';
import 'mini_icon_button.dart';

/// One card of the Grid Catalog (2 columns, childAspectRatio 0.72).
/// The photo is wrapped in Expanded, so the text can never overflow.
class CatalogGridCard extends StatelessWidget {
  final Drink drink;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final bool inCart;
  final VoidCallback onToggleCart;

  const CatalogGridCard({
    super.key,
    required this.drink,
    required this.isFavorite,
    required this.onTap,
    required this.onFavorite,
    required this.inCart,
    required this.onToggleCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: DrinkBanner(
                drink: drink,
                iconSize: 48,
                overlays: [
                  if (drink.badge != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      right: 48,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              drink.badge!,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: drink.color,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: MiniIconButton(
                      tooltip: isFavorite
                          ? 'Remove from favorites'
                          : 'Add to favorites',
                      icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : null,
                      onPressed: onFavorite,
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: MiniIconButton(
                      tooltip: inCart ? 'Remove from cart' : 'Add to cart',
                      icon: inCart
                          ? Icons.remove_shopping_cart
                          : Icons.add_shopping_cart,
                      color: inCart ? Colors.green.shade700 : null,
                      onPressed: onToggleCart,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    drink.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    drink.category.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      letterSpacing: 1,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          formatPrice(drink.price),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: Color(0xFFE0A100),
                      ),
                      Text(
                        ' ${drink.rating}',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
