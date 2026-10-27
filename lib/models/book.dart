class Book {
  final String id;
  final String title;
  final String author;
  final int? publishYear;
  final int? coverId;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    this.publishYear,
    this.coverId,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final authors = json['author_name'] as List<dynamic>?;

    return Book(
      id: json['key']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Unknown Title',
      author: authors == null || authors.isEmpty
          ? 'Unknown Author'
          : authors.first.toString(),
      publishYear: json['first_publish_year'] is int
          ? json['first_publish_year'] as int
          : null,
      coverId: json['cover_i'] is int ? json['cover_i'] as int : null,
    );
  }

  String? get coverUrl {
    if (coverId == null) return null;
    return 'https://covers.openlibrary.org/b/id/$coverId-M.jpg';
  }
}
