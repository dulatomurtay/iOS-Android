class Book {
  String title;
  String author;
  double price;
  bool isBorrowed;

  Book(this.title, this.author, this.price, this.isBorrowed);
}

class Library {
  List<Book> _books = [];

  void addBook(Book book) {
    _books.add(book);
  }

  List<Book> getAvailableBooks() {
    List<Book> available = [];
    available = _books.where((book) => book.isBorrowed == false).toList();
    return available;
  }

  double getTotalValue() {
    double total = 0.0;
    total = _books.fold(0.0, (sum, book) => sum + book.price);
    return total;
  }
}

void main() {
  Library library = Library();

  library.addBook(Book('Dart Basics', 'Abdulla', 5000, false));
  library.addBook(Book('Flutter Guide', 'Aruzhan', 7000, true));
  library.addBook(Book('Clean Code', 'Damir', 6000, false));
  library.addBook(Book('OOP Patterns', 'Sultan', 4500, true));

  print('--- Available books ---');
  List<Book> available = library.getAvailableBooks();
  for (var book in available) {
    print('${book.title} by ${book.author}, price: ${book.price}₸');
  }

  double total = library.getTotalValue();
  print('Total collection value: $total₸');
}