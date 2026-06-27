import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final String title;
  final List<String> authors;
  final int? coverI;
  final int? firstPublishYear;
  final String key;

  const Book({
    required this.title,
    required this.authors,
    this.coverI,
    this.firstPublishYear,
    required this.key,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    List<String> authorsList = [];
    
    // search.json uses 'author_name' which is a list of strings
    if (json['author_name'] != null) {
      authorsList = List<String>.from(json['author_name']);
    } 
    // fallback for other endpoints if they use 'authors'
    else if (json['authors'] != null) {
      authorsList = (json['authors'] as List)
          .map((author) => author['name'] as String)
          .toList();
    }

    return Book(
      title: json['title'] ?? 'Unknown Title',
      authors: authorsList,
      coverI: json['cover_i'] ?? json['cover_id'],
      firstPublishYear: json['first_publish_year'],
      key: json['key'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author_name': authors,
      'cover_i': coverI,
      'first_publish_year': firstPublishYear,
      'key': key,
    };
  }

  String get coverUrl {
    if (coverI == null) {
      return 'https://via.placeholder.com/150'; // Placeholder if no cover
    }
    return 'https://covers.openlibrary.org/b/id/$coverI-L.jpg';
  }

  @override
  List<Object?> get props => [title, authors, coverI, firstPublishYear, key];
}
