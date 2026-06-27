import 'package:equatable/equatable.dart';

class BookDetail extends Equatable {
  final String title;
  final String description;
  final List<int> covers;
  final List<String> subjects;

  const BookDetail({
    required this.title,
    required this.description,
    required this.covers,
    required this.subjects,
  });

  factory BookDetail.fromJson(Map<String, dynamic> json) {
    String descriptionText = 'No description available.';
    if (json['description'] != null) {
      if (json['description'] is String) {
        descriptionText = json['description'];
      } else if (json['description'] is Map) {
        descriptionText =
            json['description']['value'] ?? 'No description available.';
      }
    }

    List<int> coversList = [];
    if (json['covers'] != null) {
      coversList = List<int>.from(json['covers']);
    }

    List<String> subjectsList = [];
    if (json['subjects'] != null) {
      subjectsList = List<String>.from(json['subjects']);
    }

    return BookDetail(
      title: json['title'] ?? 'Unknown Title',
      description: descriptionText,
      covers: coversList,
      subjects: subjectsList,
    );
  }

  String get coverUrl {
    if (covers.isEmpty || covers.first == -1) {
      return 'https://via.placeholder.com/150';
    }
    return 'https://covers.openlibrary.org/b/id/${covers.first}-L.jpg';
  }

  @override
  List<Object?> get props => [title, description, covers, subjects];
}
