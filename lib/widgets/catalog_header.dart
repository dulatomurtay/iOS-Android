import 'package:flutter/material.dart';

/// Search field, category chips and the "N of M items" line.
class CatalogHeader extends StatelessWidget {
  final TextEditingController controller;
  final String query;
  final String category;
  final bool onlyFavorites;
  final List<String> categories;
  final int shown;
  final int total;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onClearQuery;
  final ValueChanged<String> onCategory;
  final ValueChanged<bool> onFavorites;

  const CatalogHeader({
    super.key,
    required this.controller,
    required this.query,
    required this.category,
    required this.onlyFavorites,
    required this.categories,
    required this.shown,
    required this.total,
    required this.onQueryChanged,
    required this.onClearQuery,
    required this.onCategory,
    required this.onFavorites,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            onChanged: onQueryChanged,
            decoration: InputDecoration(
              hintText: 'Search drinks and desserts',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear search',
                      icon: const Icon(Icons.close),
                      onPressed: onClearQuery,
                    ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  avatar: const Icon(Icons.favorite, size: 18),
                  label: const Text('Favorites'),
                  selected: onlyFavorites,
                  onSelected: onFavorites,
                ),
                for (final c in categories)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ChoiceChip(
                      label: Text(c),
                      selected: category == c,
                      onSelected: (_) => onCategory(c),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  '$shown of $total items',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
