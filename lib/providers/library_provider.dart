import 'package:flutter/foundation.dart';

import '../models/book.dart';

class LibraryProvider extends ChangeNotifier {
  final List<Book> _borrowedBooks = [];
  final Set<String> _favouriteIds = {};

  List<Book> get borrowedBooks => List.unmodifiable(_borrowedBooks);

  bool isFavourite(Book book) => _favouriteIds.contains(book.id);

  bool isBorrowed(Book book) =>
      _borrowedBooks.any((item) => item.id == book.id);

  List<String> get favouriteIds => List.unmodifiable(_favouriteIds);

  void toggleFavourite(Book book) {
    if (!_favouriteIds.add(book.id)) {
      _favouriteIds.remove(book.id);
    }
    notifyListeners();
  }

  void borrowBook(Book book) {
    if (!isBorrowed(book)) {
      _borrowedBooks.add(book);
      notifyListeners();
    }
  }

  void returnBook(Book book) {
    final oldLength = _borrowedBooks.length;
    _borrowedBooks.removeWhere((item) => item.id == book.id);
    if (_borrowedBooks.length != oldLength) notifyListeners();
  }
}
