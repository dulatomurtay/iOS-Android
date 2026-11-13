import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/drinks.dart';
import '../data/new_arrivals.dart';
import '../models/drink.dart';
import '../models/sort_mode.dart';
import '../providers/cart_provider.dart';
import '../widgets/catalog_grid_card.dart';
import '../widgets/catalog_header.dart';
import '../widgets/catalog_list_tile.dart';
import '../widgets/empty_catalog.dart';
import '../widgets/no_results.dart';
import '../widgets/size_picker_sheet.dart';
import '../widgets/swipe_delete_background.dart';
import '../widgets/swipe_favorite_background.dart';
import 'cart_screen.dart';
import 'detail_screen.dart';

/// Home screen of Bean & Brew = the Smart Catalog.
///
/// - List Feed (ListView.separated) and Grid Catalog (GridView.builder)
/// - Search, category chips, favorites filter and sorting
/// - Pull-to-Refresh: a new arrival is inserted at index 0
/// - Swipe left: delete (red) + UNDO; swipe right: favorite (pink)
/// - Empty state with "Reset Catalog"; "Nothing found" state for filters
/// - Cart state lives in CartProvider (Lab 9): the AppBar badge and the
///   "Add to Cart" toggles watch it and update live
class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  static const _categories = ['All', 'Coffee', 'Cold', 'Tea', 'Dessert'];

  final _searchController = TextEditingController();

  // A growable copy: the const seed list itself cannot be modified.
  List<Drink> _items = List.of(drinks);
  final Set<String> _favorites = {};

  String _query = '';
  String _category = 'All';
  bool _onlyFavorites = false;
  bool _isGrid = false;
  SortMode _sort = SortMode.featured;
  int _arrivals = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ---------- derived data ----------

  /// What the screen shows: the stored list filtered and sorted.
  List<Drink> get _visible {
    final q = _query.toLowerCase();
    final result = _items.where((d) {
      final matchesCategory = _category == 'All' || d.category == _category;
      final matchesFavorite = !_onlyFavorites || _favorites.contains(d.id);
      final matchesQuery =
          q.isEmpty ||
          d.name.toLowerCase().contains(q) ||
          d.category.toLowerCase().contains(q);
      return matchesCategory && matchesFavorite && matchesQuery;
    }).toList();

    switch (_sort) {
      case SortMode.featured:
        break;
      case SortMode.priceLow:
        result.sort((a, b) => a.price.compareTo(b.price));
      case SortMode.priceHigh:
        result.sort((a, b) => b.price.compareTo(a.price));
      case SortMode.rating:
        result.sort((a, b) => b.rating.compareTo(a.rating));
      case SortMode.name:
        result.sort((a, b) => a.name.compareTo(b.name));
    }
    return result;
  }

  // ---------- helpers ----------

  void _snack(String message, {String? actionLabel, VoidCallback? onAction}) {
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

  void _toggleFavorite(String id) {
    setState(() {
      if (!_favorites.remove(id)) _favorites.add(id);
    });
  }

  /// "Add to Cart" toggle.
  /// - already in the cart: remove it;
  /// - drinks with sizes: ask S / M / L first, then add;
  /// - items without sizes (desserts): add right away.
  Future<void> _toggleCart(Drink drink) async {
    final cart = context.read<CartProvider>();

    if (cart.contains(drink.id)) {
      cart.toggle(drink);
      _snack('${drink.name} removed from cart');
      return;
    }

    var size = DrinkSize.small;
    if (drink.hasSizes) {
      final picked = await showSizePicker(context, drink);
      if (picked == null || !mounted) return; // sheet closed: nothing added
      size = picked;
    }

    cart.add(drink, size, 1);
    _snack(
      drink.hasSizes
          ? '${drink.name} (${size.label}) added to cart'
          : '${drink.name} added to cart',
      actionLabel: 'CART',
      onAction: _openCart,
    );
  }

  // ---------- the LW8 gestures ----------

  /// Pull-to-Refresh: fake 1.5 s network call, then prepend a new item.
  Future<void> _refresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    final template = newArrivals[_arrivals % newArrivals.length];
    _arrivals++;
    // A unique id is required for ValueKey and for UNDO.
    final fresh = template.copyWith(
      id: '${template.id}_$_arrivals',
      badge: 'New',
    );
    setState(() => _items.insert(0, fresh));
    _snack('New arrival: ${fresh.name}');
  }

  /// Called by Dismissible.onDismissed. The item must leave the list
  /// immediately, otherwise Flutter reports a dismissed widget still in tree.
  void _remove(Drink item) {
    final index = _items.indexWhere((d) => d.id == item.id);
    if (index == -1) return;
    setState(() => _items.removeAt(index));
    _snack(
      '${item.name} removed',
      actionLabel: 'UNDO',
      onAction: () => _restore(item, index),
    );
  }

  /// UNDO: put the item back at its original index.
  void _restore(Drink item, int index) {
    if (_items.any((d) => d.id == item.id)) return; // avoid duplicate keys
    setState(() {
      final position = index > _items.length ? _items.length : index;
      _items.insert(position, item);
    });
  }

  void _reset() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    _searchController.clear();
    setState(() {
      _items = List.of(drinks);
      _arrivals = 0;
      _query = '';
      _category = 'All';
      _onlyFavorites = false;
    });
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _query = '';
      _category = 'All';
      _onlyFavorites = false;
    });
  }

  // ---------- navigation ----------

  void _openDetail(Drink drink) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => DetailScreen(
          drink: drink,
          isFavorite: () => _favorites.contains(drink.id),
          onToggleFavorite: () => _toggleFavorite(drink.id),
        ),
      ),
    );
  }

  void _openCart() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const CartScreen()),
    );
  }

  // ---------- list / grid ----------

  Widget _dismissible(Drink item, Widget child, {BorderRadius? radius}) {
    return Dismissible(
      key: ValueKey(item.id), // stable unique key, NOT the list index
      direction: DismissDirection.horizontal,
      // left-to-right: favorite (the item stays)
      background: SwipeFavoriteBackground(
        isFavorite: _favorites.contains(item.id),
        borderRadius: radius,
      ),
      // right-to-left: red background + delete icon
      secondaryBackground: SwipeDeleteBackground(borderRadius: radius),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          _toggleFavorite(item.id);
          return false; // spring back, nothing is removed
        }
        return true;
      },
      onDismissed: (_) => _remove(item),
      child: child,
    );
  }

  Widget _buildList(List<Drink> items, CartProvider cart) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 88),
      itemCount: items.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, thickness: 1),
      itemBuilder: (context, index) {
        final item = items[index];
        return _dismissible(
          item,
          CatalogListTile(
            drink: item,
            isFavorite: _favorites.contains(item.id),
            onTap: () => _openDetail(item),
            onFavorite: () => _toggleFavorite(item.id),
            inCart: cart.contains(item.id),
            onToggleCart: () => _toggleCart(item),
          ),
        );
      },
    );
  }

  Widget _buildGrid(List<Drink> items, CartProvider cart) {
    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.72, // width / height of one cell
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _dismissible(
          item,
          CatalogGridCard(
            drink: item,
            isFavorite: _favorites.contains(item.id),
            onTap: () => _openDetail(item),
            onFavorite: () => _toggleFavorite(item.id),
            inCart: cart.contains(item.id),
            onToggleCart: () => _toggleCart(item),
          ),
          radius: BorderRadius.circular(16),
        );
      },
    );
  }

  Widget _buildBody(List<Drink> visible, CartProvider cart) {
    // Nothing left at all: the dedicated empty state with "Reset Catalog".
    if (_items.isEmpty) return EmptyCatalog(onReset: _reset);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: RefreshIndicator(
        key: ValueKey(_isGrid),
        onRefresh: _refresh,
        child: visible.isEmpty
            ? NoResults(onClear: _clearFilters)
            : (_isGrid ? _buildGrid(visible, cart) : _buildList(visible, cart)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visible;
    // watch = rebuild this screen whenever the cart changes (live badge).
    final cart = context.watch<CartProvider>();
    final count = cart.totalCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bean & Brew',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          PopupMenuButton<SortMode>(
            tooltip: 'Sort',
            icon: const Icon(Icons.sort),
            initialValue: _sort,
            onSelected: (mode) => setState(() => _sort = mode),
            itemBuilder: (context) => [
              for (final mode in SortMode.values)
                PopupMenuItem<SortMode>(
                  value: mode,
                  child: Row(
                    children: [
                      Icon(mode.icon, size: 20),
                      const SizedBox(width: 12),
                      Flexible(child: Text(mode.label)),
                    ],
                  ),
                ),
            ],
          ),
          IconButton(
            tooltip: _isGrid ? 'Show list' : 'Show grid',
            onPressed: () => setState(() => _isGrid = !_isGrid),
            icon: Icon(_isGrid ? Icons.view_list : Icons.grid_view),
          ),
          IconButton(
            tooltip: 'Cart',
            onPressed: _openCart,
            icon: Badge(
              isLabelVisible: count > 0,
              label: Text('$count'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              children: [
                if (_items.isNotEmpty)
                  CatalogHeader(
                    controller: _searchController,
                    query: _query,
                    category: _category,
                    onlyFavorites: _onlyFavorites,
                    categories: _categories,
                    shown: visible.length,
                    total: _items.length,
                    onQueryChanged: (v) => setState(() => _query = v.trim()),
                    onClearQuery: () {
                      _searchController.clear();
                      setState(() => _query = '');
                    },
                    onCategory: (c) => setState(() => _category = c),
                    onFavorites: (v) => setState(() => _onlyFavorites = v),
                  ),
                Expanded(child: _buildBody(visible, cart)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
