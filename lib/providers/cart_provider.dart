import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../models/drink.dart';

/// The single, global shopping cart of the app (Lab 9).
///
/// It extends [ChangeNotifier]: every method that changes the cart calls
/// [notifyListeners], and every widget that "watches" the provider
/// (AppBar badge, product buttons, cart screen) rebuilds automatically.
/// That is why both screens are always in sync.
class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  /// Read-only view: widgets cannot change the cart without notifying.
  UnmodifiableListView<CartItem> get items => UnmodifiableListView(_items);

  bool get isEmpty => _items.isEmpty;

  /// Sum of quantities: the number shown in the AppBar badge.
  int get totalCount => _items.fold(0, (sum, item) => sum + item.quantity);

  /// Total price of the whole cart.
  int get totalPrice => _items.fold(0, (sum, item) => sum + item.total);

  /// Is at least one line of this drink in the cart?
  bool contains(String drinkId) => _items.any((i) => i.drink.id == drinkId);

  /// Adds a drink; if the same drink + size is already there, the quantity grows.
  void add(Drink drink, DrinkSize size, int quantity) {
    final index = _items.indexWhere(
      (i) => i.drink.id == drink.id && i.size == size,
    );
    if (index == -1) {
      _items.add(CartItem(drink: drink, size: size, quantity: quantity));
    } else {
      _items[index].quantity += quantity;
    }
    notifyListeners();
  }

  /// "Add to Cart" toggle. Returns true if the drink is now in the cart.
  bool toggle(Drink drink) {
    if (contains(drink.id)) {
      _items.removeWhere((i) => i.drink.id == drink.id);
      notifyListeners();
      return false;
    }
    add(drink, DrinkSize.small, 1);
    return true;
  }

  /// +1 / -1 for one line. Never goes below 1 (use [removeLine] for that).
  void changeQuantity(CartItem item, int delta) {
    if (!_items.contains(item) || item.quantity + delta < 1) return;
    item.quantity += delta;
    notifyListeners();
  }

  /// Removes one line. Returns its old index (for UNDO), or -1.
  int removeLine(CartItem item) {
    final index = _items.indexOf(item);
    if (index == -1) return -1;
    _items.removeAt(index);
    notifyListeners();
    return index;
  }

  /// UNDO for [removeLine]: puts the line back at its old position.
  void restoreLine(CartItem item, int index) {
    if (_items.contains(item)) return;
    _items.insert(index > _items.length ? _items.length : index, item);
    notifyListeners();
  }

  /// "Clear All". Returns the removed lines so the UI can offer UNDO.
  List<CartItem> clear() {
    final backup = List<CartItem>.of(_items);
    _items.clear();
    notifyListeners();
    return backup;
  }

  /// UNDO for [clear].
  void restoreAll(List<CartItem> backup) {
    _items
      ..clear()
      ..addAll(backup);
    notifyListeners();
  }
}
