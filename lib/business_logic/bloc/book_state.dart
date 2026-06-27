import 'package:equatable/equatable.dart';
import '../../data/models/book_model.dart';
import '../../data/models/book_detail_model.dart';

abstract class BookState extends Equatable {
  const BookState();

  @override
  List<Object> get props => [];
}

class BookInitial extends BookState {}

class BookLoading extends BookState {}

class BookLoaded extends BookState {
  final List<Book> books;

  const BookLoaded({required this.books});

  @override
  List<Object> get props => [books];
}

class BookError extends BookState {
  final String message;

  const BookError({required this.message});

  @override
  List<Object> get props => [message];
}

class BookDetailLoading extends BookState {}

class BookDetailLoaded extends BookState {
  final BookDetail bookDetail;

  const BookDetailLoaded({required this.bookDetail});

  @override
  List<Object> get props => [bookDetail];
}

class BookDetailError extends BookState {
  final String message;

  const BookDetailError({required this.message});

  @override
  List<Object> get props => [message];
}
