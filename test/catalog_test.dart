import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:coffee_house/data/drinks.dart';
import 'package:coffee_house/models/drink.dart';
import 'package:coffee_house/main.dart';
import 'package:coffee_house/providers/cart_provider.dart';
import 'package:coffee_house/screens/catalog_screen.dart';

Widget _app() => ChangeNotifierProvider(
  create: (_) => CartProvider(),
  child: const MaterialApp(home: CatalogScreen()),
);

/// Taps "Add to cart" on the first product, then confirms the size sheet.
Future<void> _addFirst(WidgetTester tester) async {
  await tester.tap(find.byTooltip('Add to cart').first);
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const ValueKey('confirmSize')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the catalog IS the home screen (list feed with dividers)', (
    tester,
  ) async {
    await tester.pumpWidget(const CoffeeApp());
    expect(find.byType(CatalogScreen), findsOneWidget);
    expect(find.byType(ListView), findsWidgets);
    expect(find.byType(Divider), findsWidgets);
    expect(find.text('Latte'), findsOneWidget);
  });

  testWidgets('toggle switches between list and grid', (tester) async {
    await tester.pumpWidget(_app());

    await tester.tap(find.byTooltip('Show grid'));
    await tester.pumpAndSettle();
    expect(find.byType(GridView), findsOneWidget);
    expect(find.byType(Divider), findsNothing);

    await tester.tap(find.byTooltip('Show list'));
    await tester.pumpAndSettle();
    expect(find.byType(Divider), findsWidgets);
  });

  testWidgets('pull to refresh prepends a new item at index 0', (tester) async {
    await tester.pumpWidget(_app());

    await tester.fling(find.byType(ListView).first, const Offset(0, 300), 1000);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pumpAndSettle();

    expect(find.text('Mocha'), findsOneWidget);
    final espressoY = tester.getTopLeft(find.text('Mocha')).dy;
    final latteY = tester.getTopLeft(find.text('Latte')).dy;
    expect(espressoY < latteY, isTrue);
  });

  testWidgets('swipe left deletes an item and UNDO restores it in place', (
    tester,
  ) async {
    await tester.pumpWidget(_app());

    await tester.drag(
      find.byKey(const ValueKey('cappuccino')),
      const Offset(-600, 0),
    );
    await tester.pumpAndSettle();
    expect(find.text('Cappuccino'), findsNothing);
    expect(find.text('UNDO'), findsOneWidget);

    await tester.tap(find.text('UNDO'));
    await tester.pumpAndSettle();

    final latteY = tester.getTopLeft(find.text('Latte')).dy;
    final cappuccinoY = tester.getTopLeft(find.text('Cappuccino')).dy;
    final flatWhiteY = tester.getTopLeft(find.text('Flat White')).dy;
    expect(latteY < cappuccinoY && cappuccinoY < flatWhiteY, isTrue);
  });

  testWidgets('swipe right marks a favorite and keeps the item', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    expect(find.byTooltip('Remove from favorites'), findsNothing);

    await tester.drag(
      find.byKey(const ValueKey('cappuccino')),
      const Offset(600, 0),
    );
    await tester.pumpAndSettle();

    expect(find.text('Cappuccino'), findsOneWidget);
    expect(find.byTooltip('Remove from favorites'), findsOneWidget);
  });

  testWidgets('empty state appears and Reset Catalog restores data', (
    tester,
  ) async {
    await tester.pumpWidget(_app());

    for (final d in drinks) {
      await tester.drag(find.byKey(ValueKey(d.id)), const Offset(-600, 0));
      await tester.pumpAndSettle();
    }
    expect(find.text('Catalog is Empty'), findsOneWidget);

    await tester.tap(find.text('Reset Catalog'));
    await tester.pumpAndSettle();
    expect(find.text('Latte'), findsOneWidget);
  });

  testWidgets('search filters the catalog and "Nothing found" can be cleared', (
    tester,
  ) async {
    await tester.pumpWidget(_app());

    await tester.enterText(find.byType(TextField), 'matcha');
    await tester.pump();
    expect(find.text('Latte'), findsNothing);
    expect(find.text('Matcha Latte'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'zzzz');
    await tester.pump();
    expect(find.text('Nothing found'), findsOneWidget);

    await tester.tap(find.text('Clear filters'));
    await tester.pumpAndSettle();
    expect(find.text('Latte'), findsOneWidget);
  });

  testWidgets('sorting by price puts the cheapest item first', (tester) async {
    await tester.pumpWidget(_app());

    await tester.tap(find.byTooltip('Sort'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Price: low to high'));
    await tester.pumpAndSettle();

    final espressoY = tester.getTopLeft(find.text('Espresso')).dy; // 1 000
    final croissantY = tester.getTopLeft(find.text('Croissant')).dy; // 1 100
    expect(espressoY < croissantY, isTrue);
  });

  testWidgets(
    'quick add fills the cart; a cart line can be swiped away + UNDO',
    (tester) async {
      await tester.pumpWidget(_app());

      await _addFirst(tester);
      await tester.tap(find.byTooltip('Cart'));
      await tester.pumpAndSettle();
      expect(find.text('Total (1)'), findsOneWidget);

      await tester.drag(
        find.byKey(const ValueKey('latte_small')),
        const Offset(-600, 0),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Your cart is empty'), findsOneWidget);

      await tester.tap(find.text('UNDO'));
      await tester.pumpAndSettle();
      expect(find.text('Total (1)'), findsOneWidget);
    },
  );

  testWidgets('size sheet: choosing M adds a medium line to the cart', (
    tester,
  ) async {
    await tester.pumpWidget(_app());

    await tester.tap(find.byTooltip('Add to cart').first);
    await tester.pumpAndSettle();
    expect(find.text('Choose a size'), findsOneWidget);
    for (final size in DrinkSize.values) {
      expect(find.byKey(ValueKey('size_${size.name}')), findsOneWidget);
    }

    await tester.tap(find.byKey(const ValueKey('size_medium')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('confirmSize')));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Cart'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('latte_medium')), findsOneWidget);
    expect(find.text('Total (1)'), findsOneWidget);
    expect(
      find.text(formatPrice(drinks.first.priceFor(DrinkSize.medium))),
      findsWidgets,
    );
  });

  testWidgets('size sheet: closing it adds nothing', (tester) async {
    await tester.pumpWidget(_app());

    await tester.tap(find.byTooltip('Add to cart').first);
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(10, 10)); // tap the dark barrier
    await tester.pumpAndSettle();

    expect(find.byTooltip('Remove from cart'), findsNothing);
    expect(
      find.descendant(of: find.byType(Badge), matching: find.text('1')),
      findsNothing,
    );
  });

  testWidgets('desserts have no sizes: they are added immediately', (
    tester,
  ) async {
    await tester.pumpWidget(_app());

    await tester.enterText(find.byType(TextField), 'cheesecake');
    await tester.pump();
    await tester.tap(find.byTooltip('Add to cart'));
    await tester.pumpAndSettle();

    expect(find.text('Choose a size'), findsNothing);
    expect(find.byTooltip('Remove from cart'), findsOneWidget);
  });

  testWidgets('LAB 9: cart changes sync live between the two screens', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    final badge = find.byType(Badge);

    // Screen 1: "Add to Cart" toggle -> live badge.
    await _addFirst(tester);
    expect(
      find.descendant(of: badge, matching: find.text('1')),
      findsOneWidget,
    );
    expect(find.byTooltip('Remove from cart'), findsOneWidget);

    // Screen 2: the item is there; remove it with its own button.
    await tester.tap(find.byTooltip('Cart'));
    await tester.pumpAndSettle();
    expect(find.text('Total (1)'), findsOneWidget);
    await tester.tap(find.byTooltip('Remove'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Your cart is empty'), findsOneWidget);

    // Back on screen 1 everything is already in sync.
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.descendant(of: badge, matching: find.text('1')), findsNothing);
    expect(find.byTooltip('Remove from cart'), findsNothing);
    expect(find.byTooltip('Add to cart'), findsWidgets);
  });

  testWidgets('LAB 9: the toggle adds and removes the same product', (
    tester,
  ) async {
    await tester.pumpWidget(_app());

    await _addFirst(tester);
    await tester.tap(find.byTooltip('Remove from cart'));
    await tester.pump();

    expect(find.byTooltip('Remove from cart'), findsNothing);
    expect(
      find.descendant(of: find.byType(Badge), matching: find.text('1')),
      findsNothing,
    );
  });

  testWidgets('LAB 9: Clear All empties the cart and the badge', (
    tester,
  ) async {
    await tester.pumpWidget(_app());

    await _addFirst(tester);
    await _addFirst(tester);
    await tester.tap(find.byTooltip('Cart'));
    await tester.pumpAndSettle();
    expect(find.text('Total (2)'), findsOneWidget);

    await tester.tap(find.text('Clear All'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Your cart is empty'), findsOneWidget);

    await tester.tap(find.text('UNDO'));
    await tester.pumpAndSettle();
    expect(find.text('Total (2)'), findsOneWidget);
  });

  for (final size in const [Size(320, 568), Size(390, 844), Size(1024, 768)]) {
    for (final grid in const [false, true]) {
      testWidgets('catalog has no overflow at $size, grid=$grid, text x1.5', (
        tester,
      ) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          ChangeNotifierProvider(
            create: (_) => CartProvider(),
            child: MaterialApp(
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.5)),
                child: child!,
              ),
              home: const CatalogScreen(),
            ),
          ),
        );
        if (grid) {
          await tester.tap(find.byTooltip('Show grid'));
        }
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      });
    }
  }
}
