import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/drink.dart';
import '../providers/cart_provider.dart';
import '../widgets/drink_banner.dart';
import '../widgets/swipe_delete_background.dart';

/// Screen 2 of Lab 9: the global cart.
///
/// It has no constructor parameters: all data comes from [CartProvider].
/// Everything done here (remove, clear, quantity) is instantly visible on the
/// catalog screen too, because both watch the same provider.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  void _snack(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          action: actionLabel == null
              ? null
              : SnackBarAction(label: actionLabel, onPressed: onAction!),
        ),
      );
  }

  /// Removes one line and offers UNDO (restores it at the same position).
  void _removeLine(BuildContext context, CartItem item) {
    final cart = context.read<CartProvider>();
    final index = cart.removeLine(item);
    if (index == -1) return;
    _snack(
      context,
      '${item.drink.name} removed',
      actionLabel: 'UNDO',
      onAction: () => cart.restoreLine(item, index),
    );
  }

  void _clearAll(BuildContext context) {
    final cart = context.read<CartProvider>();
    final backup = cart.clear();
    _snack(
      context,
      'Cart cleared',
      actionLabel: 'UNDO',
      onAction: () => cart.restoreAll(backup),
    );
  }

  Future<void> _checkout(BuildContext context) async {
    final cart = context.read<CartProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => _OrderSheet(
        items: List<CartItem>.of(cart.items),
        total: cart.totalPrice,
      ),
    );
    if (confirmed != true) return;
    cart.clear();
    navigator.pop();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Order placed! Ready in about 10 minutes.'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    // watch = this screen rebuilds on every cart change.
    final cart = context.watch<CartProvider>();
    final items = cart.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your cart'),
        actions: [
          if (items.isNotEmpty)
            TextButton.icon(
              onPressed: () => _clearAll(context),
              icon: const Icon(Icons.delete_sweep_outlined),
              label: const Text('Clear All'),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: items.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 56,
                        color: Colors.black38,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Your cart is empty.\nAdd something tasty from the menu.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            : Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Dismissible(
                        key: ValueKey('${item.drink.id}_${item.size.name}'),
                        direction: DismissDirection.endToStart,
                        background: SwipeDeleteBackground(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onDismissed: (_) => _removeLine(context, item),
                        child: _CartLine(
                          item: item,
                          onMinus: () {
                            if (item.quantity <= 1) {
                              _removeLine(context, item);
                            } else {
                              context.read<CartProvider>().changeQuantity(
                                item,
                                -1,
                              );
                            }
                          },
                          onPlus: () => context
                              .read<CartProvider>()
                              .changeQuantity(item, 1),
                          onRemove: () => _removeLine(context, item),
                        ),
                      );
                    },
                  ),
                ),
              ),
      ),
      bottomNavigationBar: items.isEmpty
          ? null
          : Material(
              elevation: 8,
              color: Colors.white,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Total (${cart.totalCount})'),
                          Text(
                            formatPrice(cart.totalPrice),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: FilledButton(
                          onPressed: () => _checkout(context),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                          ),
                          child: const Text('Checkout'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

/// Bottom sheet with the order summary and a "Place order" button.
class _OrderSheet extends StatelessWidget {
  final List<CartItem> items;
  final int total;

  const _OrderSheet({required this.items, required this.total});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Confirm your order',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final item in items)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${item.quantity} x ${item.drink.name}'
                              '${item.drink.hasSizes ? ' (${item.size.label})' : ''}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(formatPrice(item.total)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const Divider(height: 24),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Total',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  formatPrice(total),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text('Place order'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CartLine extends StatelessWidget {
  final CartItem item;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onRemove;

  const _CartLine({
    required this.item,
    required this.onMinus,
    required this.onPlus,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final drink = item.drink;
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: DrinkBanner(drink: drink, iconSize: 28),
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
                      Text(
                        drink.hasSizes
                            ? 'Size ${item.size.label} (${item.size.volume}) - ${formatPrice(item.unitPrice)}'
                            : formatPrice(item.unitPrice),
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Remove',
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton.outlined(
                  tooltip: 'Decrease quantity',
                  onPressed: onMinus,
                  icon: const Icon(Icons.remove),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Text(
                    '${item.quantity}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton.outlined(
                  tooltip: 'Increase quantity',
                  onPressed: onPlus,
                  icon: const Icon(Icons.add),
                ),
                const Spacer(),
                Text(
                  formatPrice(item.total),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
