import '../models/book_model.dart';
import '../models/book_detail_model.dart';
import '../providers/book_api_provider.dart';

class BookRepository {
  final BookApiProvider apiProvider;

  BookRepository({required this.apiProvider});

  Future<List<Book>> getBooks() async {
    return await apiProvider.fetchBooks();
  }

  Future<List<Book>> searchBooks(String query) async {
    return await apiProvider.searchBooks(query);
  }

  Future<BookDetail> getBookDetail(String key) async {
    return await apiProvider.fetchBookDetail(key);
  }
}
