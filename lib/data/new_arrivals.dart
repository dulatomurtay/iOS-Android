import 'package:flutter/material.dart';

import '../models/drink.dart';

/// Items that "arrive from the server" one by one on every Pull-to-Refresh.
/// They are inserted at index 0 of the catalog (see CatalogScreen._refresh).
const List<Drink> newArrivals = [
  Drink(
    id: 'mocha',
    image: 'assets/images/mocha.jpg',
    name: 'Mocha',
    category: 'Coffee',
    description:
        'Espresso, dark chocolate and steamed milk topped '
        'with whipped cream. A dessert in a cup.',
    price: 1900,
    rating: 4.7,
    calories: 290,
    icon: Icons.local_cafe,
    color: Color(0xFF5D4037),
    tags: ['Hot', 'Chocolate', 'Sweet'],
  ),
  Drink(
    id: 'caramel_macchiato',
    image: 'assets/images/caramel_macchiato.jpg',
    name: 'Caramel Macchiato',
    category: 'Coffee',
    description:
        'Vanilla milk, espresso and a golden caramel lattice. '
        'Smooth and a little bit indulgent.',
    price: 2000,
    rating: 4.8,
    calories: 250,
    icon: Icons.coffee_maker,
    color: Color(0xFFB8860B),
    tags: ['Hot', 'Caramel', 'Sweet'],
  ),
  Drink(
    id: 'hot_chocolate',
    image: 'assets/images/hot_chocolate.jpg',
    name: 'Hot Chocolate',
    category: 'Tea',
    description:
        'Thick belgian-style chocolate with soft marshmallows. '
        'Pure comfort on a cold day.',
    price: 1600,
    rating: 4.5,
    calories: 320,
    icon: Icons.emoji_food_beverage,
    color: Color(0xFF6D4C41),
    tags: ['Hot', 'Chocolate'],
  ),
  Drink(
    id: 'brownie',
    image: 'assets/images/brownie.jpg',
    name: 'Chocolate Brownie',
    category: 'Dessert',
    description:
        'Dense, fudgy brownie with powdered sugar and a fresh '
        'raspberry. Best with an espresso.',
    price: 1500,
    rating: 4.6,
    calories: 380,
    icon: Icons.cookie,
    color: Color(0xFF5D4037),
    tags: ['Sweet', 'Chocolate'],
    hasSizes: false,
  ),
  Drink(
    id: 'cold_brew',
    image: 'assets/images/cold_brew.jpg',
    name: 'Cold Brew',
    category: 'Cold',
    description:
        'Coffee steeped for 18 hours and served over ice with a '
        'cap of sweet cream. Very smooth.',
    price: 1800,
    rating: 4.7,
    calories: 90,
    icon: Icons.local_drink,
    color: Color(0xFF37474F),
    tags: ['Iced', 'Smooth'],
  ),
  Drink(
    id: 'lemon_tea',
    image: 'assets/images/lemon_tea.jpg',
    name: 'Iced Lemon Tea',
    category: 'Tea',
    description:
        'Black tea with fresh lemon and mint over ice. '
        'Light and refreshing.',
    price: 1200,
    rating: 4.3,
    calories: 70,
    icon: Icons.emoji_food_beverage,
    color: Color(0xFFEF9A1F),
    tags: ['Iced', 'Fresh'],
  ),
];
