import 'package:flutter/material.dart';

/// How the catalog is ordered on screen (the stored list is never reordered).
enum SortMode { featured, priceLow, priceHigh, rating, name }

extension SortModeInfo on SortMode {
  String get label => switch (this) {
    SortMode.featured => 'Featured',
    SortMode.priceLow => 'Price: low to high',
    SortMode.priceHigh => 'Price: high to low',
    SortMode.rating => 'Top rated',
    SortMode.name => 'Name A-Z',
  };

  IconData get icon => switch (this) {
    SortMode.featured => Icons.auto_awesome,
    SortMode.priceLow => Icons.trending_down,
    SortMode.priceHigh => Icons.trending_up,
    SortMode.rating => Icons.star_outline_rounded,
    SortMode.name => Icons.sort_by_alpha,
  };
}
