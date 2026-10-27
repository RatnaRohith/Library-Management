import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../providers/library_provider.dart';
import '../widgets/custom_button.dart';

class BookDetailsPage extends StatelessWidget {
  final Book book;

  const BookDetailsPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final library = context.watch<LibraryProvider>();
    final borrowed = library.isBorrowed(book);
    final favourite = library.isFavourite(book);

    return Scaffold(
      appBar: AppBar(title: const Text('Book Details')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: 'book-${book.id}',
                  child: SizedBox(
                    height: 280,
                    child: book.coverUrl == null
                        ? const _CoverFallback()
                        : CachedNetworkImage(
                            imageUrl: book.coverUrl!,
                            fit: BoxFit.contain,
                            errorWidget: (_, __, ___) =>
                                const _CoverFallback(),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  book.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  book.author,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (book.publishYear != null)
                  Text('First published: ${book.publishYear}'),
                const SizedBox(height: 24),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text(
                    borrowed
                        ? 'This book is in your library.'
                        : 'Add this book to your library to track it.',
                    key: ValueKey(borrowed),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: borrowed ? 'Return Book' : 'Borrow Book',
                  onPressed: () {
                    final provider = context.read<LibraryProvider>();
                    if (borrowed) {
                      provider.returnBook(book);
                    } else {
                      provider.borrowBook(book);
                    }
                  },
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => context
                      .read<LibraryProvider>()
                      .toggleFavourite(book),
                  icon: Icon(
                    favourite ? Icons.favorite : Icons.favorite_border,
                  ),
                  label: Text(
                    favourite ? 'Remove Favourite' : 'Add Favourite',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CoverFallback extends StatelessWidget {
  const _CoverFallback();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 200,
      child: ColoredBox(
        color: Color(0xFFE8EDE7),
        child: Center(
          child: Icon(
            Icons.menu_book_rounded,
            size: 72,
            color: Color(0xFF245747),
          ),
        ),
      ),
    );
  }
}
