import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/book.dart';

class BookService {
  BookService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<Book>> fetchBooks({String query = 'fiction'}) async {
    final uri = Uri.https(
      'openlibrary.org',
      '/search.json',
      {
        'q': query,
        'fields': 'key,title,author_name,cover_i,first_publish_year',
        'limit': '30',
      },
    );

    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Unable to fetch books (HTTP ${response.statusCode})');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final documents = data['docs'] as List<dynamic>? ?? [];

    return documents
        .whereType<Map<String, dynamic>>()
        .map(Book.fromJson)
        .toList();
  }
}
