import 'package:flutter_test/flutter_test.dart';

import 'package:coffee_house/data/drinks.dart';
import 'package:coffee_house/models/drink.dart';
import 'package:coffee_house/providers/cart_provider.dart';

void main() {
  late CartProvider cart;
  late int notifications;

  setUp(() {
    cart = CartProvider();
    notifications = 0;
    cart.addListener(() => notifications++);
  });

  test('starts empty', () {
    expect(cart.isEmpty, isTrue);
    expect(cart.totalCount, 0);
    expect(cart.totalPrice, 0);
  });

  test('add merges the same drink + size and notifies listeners', () {
    cart.add(drinks.first, DrinkSize.small, 1);
    cart.add(drinks.first, DrinkSize.small, 2);

    expect(cart.items.length, 1);
    expect(cart.totalCount, 3);
    expect(notifications, 2);
  });

  test('different sizes are separate lines', () {
    cart.add(drinks.first, DrinkSize.small, 1);
    cart.add(drinks.first, DrinkSize.large, 1);
    expect(cart.items.length, 2);
  });

  test('toggle adds, then removes the same product', () {
    expect(cart.toggle(drinks.first), isTrue);
    expect(cart.contains(drinks.first.id), isTrue);

    expect(cart.toggle(drinks.first), isFalse);
    expect(cart.contains(drinks.first.id), isFalse);
    expect(cart.isEmpty, isTrue);
  });

  test('total price is the sum of all lines', () {
    cart.add(drinks[0], DrinkSize.small, 2);
    cart.add(drinks[1], DrinkSize.small, 1);

    final expected =
        drinks[0].priceFor(DrinkSize.small) * 2 +
        drinks[1].priceFor(DrinkSize.small);
    expect(cart.totalPrice, expected);
  });

  test('changeQuantity never goes below 1', () {
    cart.add(drinks.first, DrinkSize.small, 1);
    final line = cart.items.first;

    cart.changeQuantity(line, -1);
    expect(line.quantity, 1);
    cart.changeQuantity(line, 1);
    expect(line.quantity, 2);
  });

  test('removeLine + restoreLine put the item back at the same index', () {
    cart.add(drinks[0], DrinkSize.small, 1);
    cart.add(drinks[1], DrinkSize.small, 1);
    cart.add(drinks[2], DrinkSize.small, 1);
    final middle = cart.items[1];

    final index = cart.removeLine(middle);
    expect(index, 1);
    expect(cart.items.length, 2);

    cart.restoreLine(middle, index);
    expect(cart.items[1], same(middle));
  });

  test('clear empties the cart and restoreAll brings it back', () {
    cart.add(drinks[0], DrinkSize.small, 1);
    cart.add(drinks[1], DrinkSize.small, 2);

    final backup = cart.clear();
    expect(cart.isEmpty, isTrue);

    cart.restoreAll(backup);
    expect(cart.totalCount, 3);
  });
}
