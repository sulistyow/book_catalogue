import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';
import '../models/book_detail_model.dart';

class BookApiProvider {
  final http.Client client;
  final BASE_URL = 'https://openlibrary.org';

  BookApiProvider({required this.client});

  Future<List<Book>> fetchBooks() async {
    try {
      final response = await client.get(
        Uri.parse('$BASE_URL/search.json?subject=children&limit=20'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> docs = data['docs'];
        return docs.map((json) => Book.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load books');
      }
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e) {
      throw Exception('Unknown error: $e');
    }
  }

  Future<List<Book>> searchBooks(String query) async {
    try {
      final response = await client.get(
        Uri.parse('$BASE_URL/search.json?q=${Uri.encodeComponent(query)}&limit=20'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> docs = data['docs'];
        return docs.map((json) => Book.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search books');
      }
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e) {
      throw Exception('Unknown error: $e');
    }
  }

  Future<BookDetail> fetchBookDetail(String key) async {
    try {
      // API Key structure handling: The user provides "key": "/works/OL267096W".
      // The API expects https://openlibrary.org/works/OL468431W.json
      final url = '$BASE_URL$key.json';

      final response = await client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return BookDetail.fromJson(data);
      } else {
        throw Exception('Failed to load book details');
      }
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e) {
      throw Exception('Unknown error: $e');
    }
  }
}
