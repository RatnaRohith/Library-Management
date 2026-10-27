import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../providers/library_provider.dart';
import '../services/book_service.dart';
import '../widgets/book_card.dart';
import 'book_details_page.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onLogout;

  const HomePage({super.key, required this.onLogout});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _search = TextEditingController();
  final _service = BookService();

  List<Book> _books = [];
  bool _loading = true;
  String? _error;
  int _selectedIndex = 0;
  int _requestId = 0;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks([String query = 'fiction']) async {
    final requestId = ++_requestId;
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final books = await _service.fetchBooks(query: query);
      if (!mounted || requestId != _requestId) return;
      setState(() {
        _books = books;
        _loading = false;
      });
    } catch (_) {
      if (!mounted || requestId != _requestId) return;
      setState(() {
        _error = 'Could not load books. Check your connection and retry.';
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final library = context.watch<LibraryProvider>();
    final isMyLibrary = _selectedIndex == 1;
    final visibleBooks = isMyLibrary ? library.borrowedBooks : _books;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BookNest'),
        actions: [
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Log out?'),
                  content: const Text('You can sign in again using your saved credentials.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        widget.onLogout();
                      },
                      child: const Text('Log out'),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'My Library',
            icon: const Icon(Icons.bookmarks_outlined),
            onPressed: () => setState(() => _selectedIndex = 1),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isMyLibrary ? 'My Library' : 'Find your next read',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                if (!isMyLibrary)
                  TextField(
                    controller: _search,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) => _loadBooks(
                      value.trim().isEmpty ? 'fiction' : value.trim(),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search books or authors',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        tooltip: 'Search',
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () => _loadBooks(
                          _search.text.trim().isEmpty
                              ? 'fiction'
                              : _search.text.trim(),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: _loading && !isMyLibrary
                ? const Center(child: CircularProgressIndicator())
                : _error != null && !isMyLibrary
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(_error!, textAlign: TextAlign.center),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () => _loadBooks(
                                  _search.text.trim().isEmpty
                                      ? 'fiction'
                                      : _search.text.trim(),
                                ),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : visibleBooks.isEmpty
                        ? Center(
                            child: Text(
                              isMyLibrary
                                  ? 'No borrowed books yet.\nExplore the catalogue and borrow a book.'
                                  : 'No books found.',
                              textAlign: TextAlign.center,
                            ),
                          )
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              final width = constraints.maxWidth;
                              final columns = width >= 1100
                                  ? 5
                                  : width >= 750
                                      ? 4
                                      : width >= 480
                                          ? 3
                                          : 2;

                              return GridView.builder(
                                key: ValueKey(isMyLibrary),
                                padding: const EdgeInsets.all(12),
                                itemCount: visibleBooks.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: columns,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.56,
                                ),
                                itemBuilder: (context, index) {
                                  final book = visibleBooks[index];
                                  return AnimatedOpacity(
                                    opacity: 1,
                                    duration: Duration(
                                      milliseconds: 250 + (index % 10) * 15,
                                    ),
                                    child: BookCard(
                                      book: book,
                                      favourite: library.isFavourite(book),
                                      onFavourite: () =>
                                          library.toggleFavourite(book),
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute<void>(
                                            builder: (_) =>
                                                BookDetailsPage(book: book),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.library_books_outlined),
            selectedIcon: Icon(Icons.library_books),
            label: 'My Library',
          ),
        ],
      ),
    );
  }
}
