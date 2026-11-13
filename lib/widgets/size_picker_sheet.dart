import 'package:flutter/material.dart';

import '../models/drink.dart';

/// Bottom sheet "Choose a size": S / M / L with volume and price.
/// Returns the chosen [DrinkSize], or null if the user closes the sheet.
Future<DrinkSize?> showSizePicker(BuildContext context, Drink drink) {
  return showModalBottomSheet<DrinkSize>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => _SizePickerSheet(drink: drink),
  );
}

class _SizePickerSheet extends StatefulWidget {
  final Drink drink;

  const _SizePickerSheet({required this.drink});

  @override
  State<_SizePickerSheet> createState() => _SizePickerSheetState();
}

class _SizePickerSheetState extends State<_SizePickerSheet> {
  DrinkSize _size = DrinkSize.small;

  @override
  Widget build(BuildContext context) {
    final drink = widget.drink;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                drink.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Choose a size',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 12),
              for (final size in DrinkSize.values)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    key: ValueKey('size_${size.name}'),
                    selected: _size == size,
                    selectedTileColor: Theme.of(context)
                        .colorScheme
                        .primaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: _size == size
                            ? Theme.of(context).colorScheme.primary
                            : Colors.black12,
                      ),
                    ),
                    leading: CircleAvatar(child: Text(size.label)),
                    title: Text(size.volume),
                    trailing: Text(
                      formatPrice(drink.priceFor(size)),
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    onTap: () => setState(() => _size = size),
                  ),
                ),
              const SizedBox(height: 8),
              FilledButton.icon(
                key: const ValueKey('confirmSize'),
                onPressed: () => Navigator.pop(context, _size),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                icon: const Icon(Icons.add_shopping_cart),
                label: Text('Add ${_size.label} to cart'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
