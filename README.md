# Bean & Brew (coffee_house)

A coffee-ordering app where **the whole app is a Smart Catalog** (LW8):
the home screen is the catalog, and every other screen (details, cart) uses
the same gestures and states.

## Features
**Catalog (home screen)**
- **List Feed** (`ListView.separated`, dividers) and **Grid Catalog**
  (`GridView.builder`, 2 columns, `childAspectRatio: 0.72`); one button toggles
- **Photos** for every item (`assets/images/*.jpg`) with an icon fallback
- **Search**, **category chips**, **Favorites** filter, **sorting** (price, rating, name)
- **Pull-to-Refresh** (`RefreshIndicator`, 1.5 s fake request): a new arrival
  appears at index 0 (6 different arrivals: Mocha, Caramel Macchiato, Hot Chocolate, Brownie, Cold Brew, Lemon Tea)
- **Swipe left = delete** (`Dismissible`, `ValueKey(id)`, red background, `Icons.delete`)
  with an **UNDO** SnackBar that restores the item at its original index
- **Swipe right = favorite** (pink background, the item stays)
- Quick **add-to-cart** and **favorite** buttons on every row / card
- **Empty state** ("Catalog is Empty" + *Reset Catalog*) and a separate
  **"Nothing found"** state with *Clear filters*

**Size sheet** (S 250 ml / M 350 ml / L 450 ml, each with its price) opens when a drink is added to the cart.

**Detail screen**: photo with favorite button and badge, size picker (S/M/L),
quantity, sticky "Add to cart" bar, SnackBar with a *CART* shortcut.

**Cart**: swipe a line away (UNDO), quantity buttons, *Clear* (UNDO),
total with item count, **Checkout** bottom sheet (order summary, "Place order").

## Lab 9: global cart with Provider
- `lib/providers/cart_provider.dart`: `CartProvider extends ChangeNotifier`
  (add, toggle, changeQuantity, removeLine / restoreLine, clear / restoreAll,
  totalCount, totalPrice). Every change calls `notifyListeners()`.
- `main.dart`: `ChangeNotifierProvider` wraps `MaterialApp`, so all screens share one cart.
- **Screen 1 (catalog):** 12 products, each with an "Add to Cart" **toggle**
  (add / remove). For drinks a **size sheet (S / M / L)** opens first; desserts
  are added directly. The AppBar cart icon has a **live badge**.
- **Screen 2 (cart):** list of selected products, a remove button per line
  (also swipe + UNDO), quantity buttons, total price, **Clear All** (UNDO) and Checkout.
- Changes on screen 2 appear on screen 1 immediately (see `LAB 9` tests).

## Structure
```
lib/
  main.dart
  models/   drink.dart (Drink, CartItem, formatPrice), sort_mode.dart
  providers/ cart_provider.dart  (ChangeNotifier, Lab 9)
  data/     drinks.dart (seed menu), new_arrivals.dart (pull-to-refresh items)
  screens/  catalog_screen.dart (home), detail_screen.dart, cart_screen.dart
  widgets/  catalog_list_tile, catalog_grid_card, catalog_header, size_picker_sheet,
            drink_banner, mini_icon_button, empty_catalog, no_results,
            swipe_delete_background, swipe_favorite_background
assets/images/  18 drink / dessert pictures (640x640 jpg)
test/           catalog_test.dart, widget_test.dart, cart_provider_test.dart
```

## Run
```
flutter pub get
flutter run -d chrome     # or any emulator
flutter test
```
Catalog state: `StatefulWidget` + `setState`. Cart state: `provider` package.
Note: keep the project path free of special characters such as "№".
