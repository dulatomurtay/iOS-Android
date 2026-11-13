import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:coffee_house/data/drinks.dart';
import 'package:coffee_house/main.dart';
import 'package:coffee_house/providers/cart_provider.dart';
import 'package:coffee_house/screens/detail_screen.dart';

void main() {
  testWidgets('favorites and cart work across screens', (tester) async {
    await tester.pumpWidget(const CoffeeApp());

    // Mark the first drink (Latte) as favorite and show only favorites.
    await tester.tap(find.byTooltip('Add to favorites').first);
    await tester.pump();
    await tester.tap(find.text('Favorites'));
    await tester.pump();
    expect(find.text('Latte'), findsOneWidget);
    expect(find.text('Cappuccino'), findsNothing);

    // Open details and add to cart.
    await tester.tap(find.text('Latte'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('addToCart')));
    await tester.pump();

    // Back to the catalog, then open the cart.
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Cart'));
    await tester.pumpAndSettle();

    expect(find.text('Total (1)'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('checkout shows the summary and clears the cart', (tester) async {
    await tester.pumpWidget(const CoffeeApp());

    await tester.tap(find.byTooltip('Add to cart').first);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('confirmSize')));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Cart'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();
    expect(find.text('Confirm your order'), findsOneWidget);

    await tester.tap(find.text('Place order'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Order placed'), findsOneWidget);
    expect(find.byType(DetailScreen), findsNothing);
  });

  for (final size in const [Size(320, 568), Size(390, 844), Size(1024, 768)]) {
    for (final scale in const [1.0, 1.5]) {
      testWidgets('detail has no overflow at $size, text x$scale', (
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
                    .copyWith(textScaler: TextScaler.linear(scale)),
                child: child!,
              ),
              home: DetailScreen(
                drink: drinks.first,
                isFavorite: () => false,
                onToggleFavorite: () {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(
          find.byKey(const ValueKey('addToCart')).hitTestable(),
          findsOneWidget,
        );
      });
    }
  }
}
