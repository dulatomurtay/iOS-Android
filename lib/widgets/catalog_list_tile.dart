import 'package:flutter/material.dart';

import '../models/drink.dart';
import 'drink_banner.dart';
import 'mini_icon_button.dart';

/// One row of the List Feed: avatar, title, category tag, rating and price.
/// All parts shrink or ellipsize, so it never overflows (even at 320 px
/// width with 150% text).
class CatalogListTile extends StatelessWidget {
  final Drink drink;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final bool inCart;
  final VoidCallback onToggleCart;

  const CatalogListTile({
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
    return Material(
      color: Colors.white, // opaque, so the swipe backgrounds stay hidden
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              ClipOval(
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: DrinkBanner(drink: drink, iconSize: 26),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      drink.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: drink.color),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              drink.category,
                              style: TextStyle(
                                fontSize: 12,
                                color: drink.color,
                              ),
                            ),
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
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
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 88),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        formatPrice(drink.price),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MiniIconButton(
                          tooltip: isFavorite
                              ? 'Remove from favorites'
                              : 'Add to favorites',
                          icon: isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: isFavorite ? Colors.red : null,
                          onPressed: onFavorite,
                        ),
                        const SizedBox(width: 6),
                        MiniIconButton(
                          tooltip: inCart ? 'Remove from cart' : 'Add to cart',
                          icon: inCart
                              ? Icons.remove_shopping_cart
                              : Icons.add_shopping_cart,
                          color: inCart ? Colors.green.shade700 : null,
                          onPressed: onToggleCart,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
