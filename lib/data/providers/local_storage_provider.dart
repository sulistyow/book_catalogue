import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book_model.dart';

class LocalStorageProvider {
  static const _favoritesKey = 'favorite_books';

  Future<List<Book>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString(_favoritesKey);
    
    if (favoritesJson == null) {
      return [];
    }

    final List<dynamic> decoded = jsonDecode(favoritesJson);
    return decoded.map((e) => Book.fromJson(e)).toList();
  }

  Future<void> saveFavorites(List<Book> books) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(books.map((b) => b.toJson()).toList());
    await prefs.setString(_favoritesKey, encoded);
  }
}
