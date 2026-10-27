import 'package:flutter_test/flutter_test.dart';
import 'package:library_book_app/models/book.dart';
import 'package:library_book_app/providers/library_provider.dart';

void main() {
  late LibraryProvider library;

  const book = Book(
    id: '/works/OL123W',
    title: 'Test Book',
    author: 'Test Author',
    publishYear: 2024,
  );

  setUp(() {
    library = LibraryProvider();
  });

  test('borrows a book', () {
    library.borrowBook(book);
    expect(library.isBorrowed(book), isTrue);
    expect(library.borrowedBooks.length, 1);
  });

  test('prevents duplicate borrowing', () {
    library.borrowBook(book);
    library.borrowBook(book);
    expect(library.borrowedBooks.length, 1);
  });

  test('returns a borrowed book', () {
    library.borrowBook(book);
    library.returnBook(book);
    expect(library.isBorrowed(book), isFalse);
    expect(library.borrowedBooks, isEmpty);
  });

  test('toggles favourites', () {
    library.toggleFavourite(book);
    expect(library.isFavourite(book), isTrue);
    library.toggleFavourite(book);
    expect(library.isFavourite(book), isFalse);
  });

  test('notifies listeners when state changes', () {
    var notifications = 0;
    library.addListener(() => notifications++);

    library.borrowBook(book);
    library.toggleFavourite(book);

    expect(notifications, 2);
  });
}
