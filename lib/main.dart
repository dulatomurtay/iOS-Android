import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'screens/catalog_screen.dart';

void main() => runApp(const CoffeeApp());

/// Bean & Brew: a Smart Catalog (LW8) with a global cart (LW9).
class CoffeeApp extends StatelessWidget {
  const CoffeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    // The provider sits ABOVE MaterialApp, so every screen / route
    // (catalog, details, cart) can reach the same CartProvider.
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: MaterialApp(
        title: 'Bean & Brew',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6F4E37)),
          scaffoldBackgroundColor: const Color(0xFFFBF6F0),
          snackBarTheme: const SnackBarThemeData(
            behavior: SnackBarBehavior.floating,
          ),
        ),
        home: const CatalogScreen(),
      ),
    );
  }
}
