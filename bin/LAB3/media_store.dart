abstract class MediaItem {
  String id;
  String title;
  double price;

  MediaItem(this.id, this.title, this.price);

  String getDetails();
}

mixin Downloadable {
  void download(String title) {
    print('Downloading "$title"...');
  }
}

class Audiobook extends MediaItem with Downloadable {
  double durationHours;
  String narrator;

  Audiobook(String id, String title, double price, this.durationHours, this.narrator)
      : super(id, title, price);

  @override
  String getDetails() {
    return 'Audiobook: $title, narrator: $narrator, duration: $durationHours h, price: $price₸';
  }
}

class EBook extends MediaItem with Downloadable {
  double fileSizeMB;
  String author;

  EBook(String id, String title, double price, this.fileSizeMB, this.author)
      : super(id, title, price);

  @override
  String getDetails() {
    return 'EBook: $title, author: $author, size: $fileSizeMB MB, price: $price₸';
  }
}

class ShoppingCart {
  List<MediaItem> _items = [];

  void addItem(MediaItem item) {
    _items.add(item);
  }

  double calculateTotalWithTax({double taxRate = 0.12}) {
    double subtotal = 0.0;
    subtotal = _items.fold(0.0, (sum, item) => sum + item.price);
    double totalWithTax = subtotal + subtotal * taxRate;
    return totalWithTax;
  }

  List<MediaItem> filterByMaxPrice(double maxPrice) {
    List<MediaItem> result = [];
    result = _items.where((item) => item.price <= maxPrice).toList();
    return result;
  }

  void printReceipt() {
    print('--- Receipt ---');
    for (var item in _items) {
      print(item.getDetails());
      item.download(item.title);
    }
    double total = calculateTotalWithTax();
    print('Total with tax: $total₸');
  }
}

void main() {
  Audiobook book1 = Audiobook('A1', 'Atomic Habits', 3000, 5.5, 'James Clear');
  EBook book2 = EBook('E1', 'Clean Architecture', 2500, 12.4, 'Robert Martin');

  ShoppingCart cart = ShoppingCart();
  cart.addItem(book1);
  cart.addItem(book2);

  print('--- Items under 2800₸ ---');
  List<MediaItem> cheapItems = cart.filterByMaxPrice(2800);
  for (var item in cheapItems) {
    print(item.getDetails());
  }

  cart.printReceipt();
}